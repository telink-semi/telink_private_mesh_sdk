/********************************************************************************************************
 * @file     flash.c 
 *
 * @brief    for TLSR chips
 *
 * @author	 telink
 *
 * @par      Copyright (c) Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *           
 *			 The information contained herein is confidential and proprietary property of Telink 
 * 		     Semiconductor (Shanghai) Co., Ltd. and is available under the terms 
 *			 of Commercial License Agreement between Telink Semiconductor (Shanghai) 
 *			 Co., Ltd. and the licensee in separate contract or the terms described here-in. 
 *           This heading MUST NOT be removed from this file.
 *
 * 			 Licensees are granted free, non-transferable use of the information in this 
 *			 file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided. 
 *           
 *******************************************************************************************************/

#include "../tl_common.h"
#include "../drivers/spi.h"
#include "flash.h"
#include "spi_i.h"
#include "../mcu/watchdog_i.h"

extern u32 flash_adr_mac; // CFG_SECTOR_ADR_MAC_CODE
u32 flash_sector_calibration = CFG_SECTOR_ADR_CALIBRATION_CODE;

#if AUTO_ADAPT_MAC_ADDR_TO_FLASH_TYPE_EN
_attribute_aligned_(4)	Flash_CapacityDef	flash_capacity;

void flash_set_capacity(Flash_CapacityDef flash_cap)
{
	flash_capacity = flash_cap;
}

Flash_CapacityDef flash_get_capacity(void)
{
	return flash_capacity;
}

void blc_readFlashSize_autoConfigCustomFlashSector(void)
{
	u8 temp_buf[4];
	flash_read_mid(temp_buf);
	u8	flash_cap = temp_buf[2];

    if(CFG_ADR_MAC_512K_FLASH == CFG_SECTOR_ADR_MAC_CODE){
    	if(flash_cap == FLASH_SIZE_1M){
    	    #define MAC_SIZE_CHECK      (6)
    	    u8 mac_null[MAC_SIZE_CHECK] = {0xff,0xff,0xff,0xff,0xff,0xff};
    	    u8 mac_512[MAC_SIZE_CHECK], mac_1M[MAC_SIZE_CHECK];
    	    flash_read_page(CFG_ADR_MAC_512K_FLASH, MAC_SIZE_CHECK, mac_512);
    	    flash_read_page(CFG_ADR_MAC_1M_FLASH, MAC_SIZE_CHECK, mac_1M);
    	    if((0 == memcmp(mac_512,mac_null, MAC_SIZE_CHECK))
    	     &&(0 != memcmp(mac_1M,mac_null, MAC_SIZE_CHECK))){
        		flash_adr_mac = CFG_ADR_MAC_1M_FLASH;
        		flash_sector_calibration = CFG_ADR_CALIBRATION_1M_FLASH;
    		}
    	}
	}else if(CFG_ADR_MAC_1M_FLASH == CFG_SECTOR_ADR_MAC_CODE){
	    if(flash_cap != FLASH_SIZE_1M){
            while(1){ // please check your Flash size
                #if(MODULE_WATCHDOG_ENABLE)
                wd_clear();
                #endif
            }
		}
	}

	flash_set_capacity(flash_cap);
}
#endif

static inline int flash_is_busy(){		// should be called by _attribute_ram_code_ function
	return mspi_read() & 0x01;				//  the busy bit, pls check flash spec
}

_attribute_ram_code_ static void flash_send_cmd(u8 cmd){
	mspi_high();
	sleep_us(1);
	mspi_low();
	mspi_write(cmd);
	mspi_wait();
}

_attribute_ram_code_ static void flash_send_addr(u32 addr){
	mspi_write((u8)(addr>>16));
	mspi_wait();
	mspi_write((u8)(addr>>8));
	mspi_wait();
	mspi_write((u8)(addr));
	mspi_wait();
}

//  make this a asynchorous version
_attribute_ram_code_ static void flash_wait_done()
{
	sleep_us(100); 
	flash_send_cmd(FLASH_READ_STATUS_CMD);

	int i;
	for(i = 0; i < 10000000; ++i){
		if(!flash_is_busy()){
			break;
		}
	}
	mspi_high();
}

_attribute_ram_code_ void flash_erase_sector(u32 addr){
	u8 r = irq_disable();
#if(MODULE_WATCHDOG_ENABLE)
	wd_clear();
#endif
	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_SECT_ERASE_CMD);
	flash_send_addr(addr);	
	mspi_high();
	flash_wait_done();
	irq_restore(r);
}

//  Note: differrent size or type may use differrent command of block erase.
#if 0
_attribute_ram_code_ void flash_erase_block(u32 addr){
	u8 r = irq_disable();
#if(MODULE_WATCHDOG_ENABLE)
	wd_clear();
#endif
	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_BLK_ERASE_CMD);
	flash_send_addr(addr);	
	mspi_high();
	flash_wait_done();
	irq_restore(r);
}
#endif

_attribute_ram_code_ void flash_write_page_256(u32 addr, u32 len, u8 *buf){
	u8 r = irq_disable();
	// important:  buf must not reside at flash, such as constant string.  If that case, pls copy to memory first before write 
	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_WRITE_CMD);
	flash_send_addr(addr);
	
	u32 i;
	for(i = 0; i < len; ++i){
		mspi_write(buf[i]);		/* write data */
		mspi_wait();
	}
	mspi_high();
	flash_wait_done();
	irq_restore(r);
}

#define PAGE_SIZE     256
#if (__PROJECT_OTA_BOOT__ || PINGPONG_OTA_DISABLE)
_attribute_ram_code_
#endif
void flash_write_page(u32 addr, u32 len, u8 *buf){
    u32 len_empty = PAGE_SIZE - (u8)addr;
    while(len){
        if(len >= len_empty){
            flash_write_page_256(addr, len_empty, buf);
            len -= len_empty;
            addr += len_empty;
            buf += len_empty;
            len_empty = PAGE_SIZE;
        }else{
            flash_write_page_256(addr, len, buf);
            len = 0;
        }
    }
}

_attribute_ram_code_ void flash_read_page(u32 addr, u32 len, u8 *buf){
	u8 r = irq_disable();
	flash_send_cmd(FLASH_READ_CMD);
	flash_send_addr(addr);	
	
	mspi_write(0x00);		/* dummy,  to issue clock */
	mspi_wait();
	mspi_ctrl_write(0x0a);	/* auto mode */
	mspi_wait();
	/* get data */
	for(int i = 0; i < len; ++i){
		*buf++ = mspi_get();
		mspi_wait();
	}
	mspi_high();
	irq_restore(r);
}

#if (__PROJECT_LIGHT_SWITCH__)
#define FLASH_PROTECT_ENABLE    0
#else
#define FLASH_PROTECT_ENABLE    0
#endif

u8 flash_protect_en = FLASH_PROTECT_ENABLE;

#if (!__PROJECT_OTA_BOOT__)
_attribute_ram_code_ u32 flash_get_jedec_id(){
    #if (__PROJECT_MASTER_LIGHT_8266__ || __PROJECT_MASTER_LIGHT_8267__)
    return FLASH_ID_MD25D40;       // save ram
    #else
	u8 r = irq_disable();
	flash_send_cmd(FLASH_GET_JEDEC_ID);
	u8 manufacturer = mspi_read();
	u8 mem_type = mspi_read();
	u8 cap_id = mspi_read();
	mspi_high();
	irq_restore(r);
	return (u32)((manufacturer << 24 | mem_type << 16 | cap_id));
	#endif
}

#if 0
#define FLASH_GET_KGD       0x4B

_attribute_ram_code_ u16 flash_get_KGD(){
	u8 r = irq_disable();
	flash_send_cmd(FLASH_GET_KGD);
	u16 kgd;
	kgd = mspi_read();
	kgd = (kgd << 8) + mspi_read();
	mspi_high();
	irq_restore(r);
	return kgd;
}
#endif

FLASH_ADDRESS_EXTERN;
extern u32  ota_program_offset;

static u32 flash_id = 0;

void flash_get_id(){
    flash_id = flash_get_jedec_id();
}

#if (FLASH_PROTECT_ENABLE)
STATIC_ASSERT(CFG_SECTOR_ADR_MAC_CODE >= 0x70000);
static u16 T_flash_status = -1;

_attribute_ram_code_ u16 flash_status_read(){
    #if (__PROJECT_MASTER_LIGHT_8266__ || __PROJECT_MASTER_LIGHT_8267__)
    return 0;       // save ram
    #else
    u16 status = 0;
	u8 r = irq_disable();

	flash_send_cmd(FLASH_READ_STATUS_CMD);
	for(int i = 0; i < 10000000; ++i){
		if(!flash_is_busy()){
			break;
		}
	}
    status = mspi_read();
	mspi_wait();

	if(FLASH_ID_GD25Q40 == flash_id){
    	flash_send_cmd(FLASH_READ_STATUS_CMD1);
        status = status + (mspi_read() << 8);
    	mspi_wait();
	}
	
	mspi_high();

	irq_restore(r);
	return status;
	#endif
}
_attribute_ram_code_ void flash_status_write(u16 status){
    #if (__PROJECT_MASTER_LIGHT_8266__ || __PROJECT_MASTER_LIGHT_8267__)
    // save ram
    #else
	u8 r = irq_disable();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_WRITE_STATUS_CMD);
	mspi_write((u8)status);
	mspi_wait();
	if(FLASH_ID_GD25Q40 == flash_id){
    	mspi_write((u8)(status >> 8));
    	mspi_wait();
	}
	
	mspi_high();
	flash_wait_done();

	irq_restore(r);
	#endif
}

int flash_protect_GD25Q40B(u8 idx){
	u8 r = irq_disable();
	int ret = 0;
	u16 status;
    #if 1   // read status before write
	T_flash_status = status = flash_status_read();
	
	status &= (u16)(~((u16)(0x7c) | (BIT(6) << 8)));
	#else   // use default 0
	status = 0;
	#endif
	
	if(FLASH_NONE == idx){
	
	}else if(FLASH_GD25Q40_0x00000_0x1ffff == idx){
        status |= (u16)(0b01010 << 2);              //0x0028;//
	}else if(FLASH_GD25Q40_0x00000_0x3ffff == idx){
        status |= (u16)(0b01011 << 2);              //0x002c;//
	}else if(FLASH_GD25Q40_0x00000_0x6ffff == idx){
        status |= (u16)((0b00001 << 2) | (BIT(6)<< 8));   //0x4004;//
	}else if(FLASH_GD25Q40_0x40000_0x7ffff == idx){
        status |= (u16)(0b00011 << 2);              //0x000c;//
    }else{
        ret = -1;
    	irq_restore(r);
    	return ret;
    }

    if(T_flash_status == status){
        ret = 0;
    	irq_restore(r);
    	return ret;
    }
    
    flash_status_write(status);

	#if 1   // check
	sleep_us(100);
	T_flash_status = flash_status_read();
	if((T_flash_status & ((u16)((u16)(0x7c) | (BIT(6) << 8))))
	 != (status & ((u16)((u16)(0x7c) | (BIT(6) << 8))))){
        ret = -1;
	}
	#endif
	
	irq_restore(r);
	return ret;
}

int flash_protect_MD25D40(u8 idx){
	u8 r = irq_disable();
	int ret = 0;
	u16 status;
    #if 1   // read status before write
	T_flash_status = status = flash_status_read();
	
	status &= (u16)(~((u16)(0x1c)));
	#else   // use default 0
	status = 0;
	#endif
	
	if(FLASH_NONE == idx){
	
	}else if(FLASH_MD25D40_0x00000_0x3ffff == idx){
        status |= (u16)(0b110 << 2);              //0x0018;//
	}else if(FLASH_MD25D40_0x00000_0x6ffff == idx){
        status |= (u16)(0b100 << 2);              //0x0010;//
	}else{
        ret = -1;
    	irq_restore(r);
    	return ret;
    }

    if(T_flash_status == status){
        ret = 0;
    	irq_restore(r);
    	return ret;
    }
    
    flash_status_write(status);

	#if 1   // check
	sleep_us(100);
	T_flash_status = flash_status_read();
	if((T_flash_status & ((u16)(0x1c)))
	 != (status & ((u16)(0x7c)))){
        ret = -1;
	}
	#endif
	
	irq_restore(r);
	return ret;
}

int flash_protect_cmd(u8 idx){
    int ret = 0;
    if(FLASH_ID_GD25Q40 == flash_id){
        ret = flash_protect_GD25Q40B(idx);
    }else if(FLASH_ID_MD25D40 == flash_id){
        ret = flash_protect_MD25D40(idx);
    }else{
        ret = -1;
    }

    return ret;
}

int flash_protect(u8 idx){
    if(0 == flash_protect_en){
        return 0;
    }
    
    for(int i = 0; i < 5; ++i){
		if(0 == flash_protect_cmd(idx)){
			return 0;
		}
	}

	return -1;
}

int flash_protect_disable(){
    return flash_protect(FLASH_NONE);
}

int flash_protect_up256k(){
    if(FLASH_ID_GD25Q40 == flash_id){
        return flash_protect(FLASH_GD25Q40_0x00000_0x3ffff);
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_MD25D40_0x00000_0x3ffff);
    }

    return -1;
}

int flash_protect_down256k(){
    if(FLASH_ID_GD25Q40 == flash_id){
        return flash_protect(FLASH_GD25Q40_0x40000_0x7ffff);
    }

    return -1;
}

int flash_protect_8266_normal(){
    if(FLASH_ID_GD25Q40 == flash_id){
        return flash_protect(FLASH_GD25Q40_0x00000_0x1ffff);
    }else if(FLASH_ID_MD25D40 == flash_id){
        if(0x30000 == flash_adr_mac){           // can not be protect
            return flash_protect(FLASH_NONE);
        }else{
            return flash_protect(FLASH_MD25D40_0x00000_0x3ffff);
        }
    }

    return -1;
}

int flash_protect_8267_normal(){    
    if(FLASH_ID_GD25Q40 == flash_id){
        if(0 == ota_program_offset){
            if(0x30000 == flash_adr_mac){
                return flash_protect(FLASH_GD25Q40_0x40000_0x7ffff);
            }else if(0x70000 == flash_adr_mac){
                return flash_protect(FLASH_GD25Q40_0x00000_0x6ffff);
            }
        }else{
            return flash_protect(FLASH_GD25Q40_0x00000_0x1ffff);
        }
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_MD25D40_0x00000_0x6ffff);
    }

    return -1;
}

#if 0
int flash_protect_8269_normal(){        // same with 8267
    return flash_protect_8267_normal();
}
#endif

int flash_protect_8266_OTA_clr_flag(){    // clear flag of 0x3A000
    if(FLASH_ID_GD25Q40 == flash_id){
        return flash_protect(FLASH_GD25Q40_0x00000_0x3ffff);
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_NONE);
    }

    return -1;
}

int flash_protect_8267_OTA_clr_flag(){
    if(FLASH_ID_GD25Q40 == flash_id){
        if(0 == ota_program_offset){
            return flash_protect(FLASH_GD25Q40_0x00000_0x3ffff);
        }else{
            return flash_protect(FLASH_GD25Q40_0x40000_0x7ffff);
        }
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_NONE);
    }

    return -1;
}

int flash_unprotect_OTA_start(){
    if(FLASH_ID_GD25Q40 == flash_id){
        if(0x70000 == flash_adr_mac){
            #if (MCU_CORE_TYPE == MCU_CORE_8266)
            // keep normal
            #else
            return flash_protect(FLASH_NONE);
            #endif
        }else{
            // keep normal
        }
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_NONE);
    }

    return -1;
}

int flash_protect_OTA_copy(){
    if(FLASH_ID_GD25Q40 == flash_id){
        return flash_protect(FLASH_GD25Q40_0x40000_0x7ffff);
    }else if(FLASH_ID_MD25D40 == flash_id){
        return flash_protect(FLASH_NONE);
    }

    return -1;
}

int flash_protect_OTA_data_erase(){
    #if (MCU_CORE_TYPE == MCU_CORE_8266)
    return flash_protect_8266_normal();
    #else
    return flash_protect(FLASH_NONE);
    #endif

    return -1;
}


void flash_protect_debug(){
#if 1
    static u8 T_protect_idx = 0;
    if(T_protect_idx){
        if(T_protect_idx == 0xff){
            T_protect_idx = 0;       // disprotect
        }
        flash_protect(T_protect_idx);
        T_protect_idx = 0;
    }

    #if (!__PROJECT_LIGHT_SWITCH__ && !__PROJECT_LPN__ && !__PROJECT_8263_SWITCH__ && !__PROJECT_8368_SWITCH__)
	static u32 tick;
	if (clock_time_exceed (tick, 40000))
	{
    	tick = clock_time();
    	static u8 st = 0;
    	u8 s = (!(gpio_read (GPIO_PD4))) || (!(gpio_read(GPIO_PD5))) || (!(gpio_read(GPIO_PC5))) || (!(gpio_read(GPIO_PC6)));
    	if ((!st) & s)
    	{
    	static u32 T_button;  T_button++;
            flash_protect(0);   // disprotect
    	}
    	st = s;
	}
	#endif
#endif    
}
#else
int flash_protect_8266_normal(){return -1;}
int flash_protect_8267_normal(){return -1;}
int flash_protect_8266_OTA_clr_flag(){return -1;}
int flash_protect_8267_OTA_clr_flag(){return -1;}
int flash_unprotect_OTA_start(){return -1;}
int flash_protect_OTA_copy(){return -1;}
int flash_protect_OTA_data_erase(){return -1;}
#endif
#endif

/**
 * @brief	  MAC id. Before reading UID of flash, you must read MID of flash. and then you can
 *            look up the related table to select the idcmd and read UID of flash
 * @param[in] buf - store MID of flash
 * @return    none.
 */
#if AUTO_ADAPT_MAC_ADDR_TO_FLASH_TYPE_EN // to save RAM
_attribute_ram_code_ void flash_read_mid(unsigned char *buf){
	unsigned char j = 0;
	unsigned char r = irq_disable();
	flash_send_cmd(FLASH_GET_JEDEC_ID);
	mspi_write(0x00);		/* dummy,  to issue clock */
	mspi_wait();
	mspi_ctrl_write(0x0a);	/* auto mode */
	mspi_wait();

	for(j = 0; j < 3; ++j){
		*buf++ = mspi_get();
		mspi_wait();
	}
	mspi_high();

	irq_restore(r);
}
#endif

/* according to your appliaction */
#if 0
#if 0   // function in ram code will be compiled into flash, even though it has never been called.
/**
 * @brief This function serves to erase a page(256 bytes).
 * @param[in]   addr the start address of the page needs to erase.
 * @return none
 */
_attribute_ram_code_ void flash_erase_page(unsigned int addr)
{
	unsigned char r = irq_disable();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_PAGE_ERASE_CMD);
	flash_send_addr(addr);
	mspi_high();
	flash_wait_done();

    irq_restore(r);
}

/**
 * @brief This function serves to erase a block(32k).
 * @param[in]   addr the start address of the block needs to erase.
 * @return none
 */
_attribute_ram_code_ void flash_erase_32kblock(unsigned int addr)
{
	unsigned char r = irq_disable();

	wd_clear();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_32KBLK_ERASE_CMD);
	flash_send_addr(addr);
	mspi_high();
	flash_wait_done();

    irq_restore(r);
}

/**
 * @brief This function serves to erase a block(64k).
 * @param[in]   addr the start address of the block needs to erase.
 * @return none
 */
_attribute_ram_code_ void flash_erase_64kblock(unsigned int addr)
{
	unsigned char r = irq_disable();

	wd_clear();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_64KBLK_ERASE_CMD);
	flash_send_addr(addr);
	mspi_high();
	flash_wait_done();

    irq_restore(r);
}

/**
 * @brief This function serves to erase a page(256 bytes).
 * @param[in]   addr the start address of the page needs to erase.
 * @return none
 */
_attribute_ram_code_ void flash_erase_chip(void)
{
	unsigned char r = irq_disable();

	wd_clear();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_CHIP_ERASE_CMD);
	mspi_high();
	flash_wait_done();

    irq_restore(r);
}

/**
 * @brief This function write the status of flash.
 * @param[in]  the value of status
 * @return status
 */
_attribute_ram_code_ unsigned char flash_write_status(unsigned char data)
{
	unsigned char r = irq_disable();
	unsigned char result;
	//int i;
	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_WRITE_STATUS_CMD);
	mspi_write(data);
	mspi_wait();
	mspi_high();
	flash_wait_done();

	sleep_us(100);
	flash_send_cmd(FLASH_READ_STATUS_CMD);

	result = mspi_read();
	mspi_high();

	irq_restore(r);
	return  result;
}

/**
 * @brief This function reads the status of flash.
 * @param[in]  none
 * @return none
 */
_attribute_ram_code_ unsigned char flash_read_status(void){
	unsigned char r = irq_disable();
	unsigned char status =0;
	flash_send_cmd(FLASH_READ_STATUS_CMD);
	/* get low 8 bit status */
	status = mspi_read();
	mspi_high();
	irq_restore(r);
	return status;
}




/**
 * @brief  	Deep Power Down mode to put the device in the lowest consumption mode
 * 			it can be used as an extra software protection mechanism,while the device
 * 			is not in active use,since in the mode,  all write,Program and Erase commands
 * 			are ignored,except the Release from Deep Power-Down and Read Device ID(RDI)
 * 			command.This release the device from this mode
 * @param[in] none
 * @return none.
 */
_attribute_ram_code_ void flash_deep_powerdown(void)
{
	unsigned char r = irq_disable();

	flash_send_cmd(FLASH_POWER_DOWN);
	mspi_high();
	sleep_us(1);

    irq_restore(r);
}

/**
 * @brief		The Release from Power-Down or High Performance Mode/Device ID command is a
 * 				Multi-purpose command.it can be used to release the device from the power-Down
 * 				State or High Performance Mode or obtain the devices electronic identification
 * 				(ID)number.Release from Power-Down will take the time duration of tRES1 before
 * 				the device will resume normal operation and other command are accepted.The CS#
 * 				pin must remain high during the tRES1(8us) time duration.
 * @param[in] none
 * @return none.
 */
_attribute_ram_code_ void flash_release_deep_powerdown(void)
{
	unsigned char r = irq_disable();

	flash_send_cmd(FLASH_POWER_DOWN_RELEASE);
	mspi_high();
	flash_wait_done();
	mspi_high();

    irq_restore(r);
}
#endif

/**
 * @brief	  UID. Before reading UID of flash, you must read MID of flash. and then you can
 *            look up the related table to select the idcmd and read UID of flash
 * @param[in] idcmd - get this value to look up the table based on MID of flash
 * @param[in] buf   - store UID of flash
 * @return    none.
 */
_attribute_ram_code_ void flash_read_uid(unsigned char idcmd,unsigned char *buf)
{
	unsigned char j = 0;
	unsigned char r = irq_disable();
	flash_send_cmd(idcmd);
	if(idcmd==FLASH_GD_PUYA_READ_UID_CMD)				//< GD/puya
	{
		flash_send_addr(0x00);
		mspi_write(0x00);		/* dummy,  to issue clock */
		mspi_wait();
	}
	else if (idcmd==FLASH_XTX_READ_UID_CMD)		//< XTX
	{
		flash_send_addr(0x80);
		mspi_write(0x00);		/* dummy,  to issue clock */
		mspi_wait();

	}
	mspi_write(0x00);			/* dummy,  to issue clock */
	mspi_wait();
	mspi_ctrl_write(0x0a);		/* auto mode */
	mspi_wait();

	for(j = 0; j < 16; ++j){
		*buf++ = mspi_get();
		mspi_wait();
	}
	mspi_high();
	irq_restore(r);
}
/**
 * @brief 		 This function serves to read flash mid and uid,and check the correctness of mid and uid.
 * @param[out]   flash_mid - Flash Manufacturer ID
 * @param[out]   flash_uid - Flash Unique ID
 * @return       0:error 1:ok

 */
_attribute_ram_code_ int flash_read_mid_uid_with_check( unsigned int *flash_mid ,unsigned char *flash_uid)
{
	  unsigned char no_uid[16]={0x51,0x01,0x51,0x01,0x51,0x01,0x51,0x01,0x51,0x01,0x51,0x01,0x51,0x01,0x51,0x01};
	  int i,f_cnt=0;
	  unsigned int mid;
	  flash_read_mid((unsigned char*)&mid);
	  mid = mid&0xffff;
	  *flash_mid  = mid;
	 //     	  		 CMD        MID
	 //  GD25LD40C 		 0x4b     0x60c8
	 //  GD25LD05C  	 0x4b 	  0x60c8
	 //  P25Q40L   		 0x4b     0x6085
	 //  MD25D40DGIG	 0x4b     0x4051
	  if( (mid == 0x60C8) || (mid == 0x6085) ||(mid == 0x4051)){
		  flash_read_uid(FLASH_GD_PUYA_READ_UID_CMD,(unsigned char *)flash_uid);
	  }else{
		  return 0;
	  }
	  for(i=0;i<16;i++){
		if(flash_uid[i]==no_uid[i]){
			f_cnt++;
		}
	  }
	  if(f_cnt==16){//no uid flash
			  return 0;

	  }else{
		  return  1;
	  }
}
#if 0
/**
 * @brief This function serves to protect data for flash.
 * @param[in]   type - flash type include GD,Puya and XTX
 * @param[in]   data - refer to Driver API Doc.
 * @return none
 */
_attribute_ram_code_ void flash_lock(Flash_TypeDef type , unsigned short data)
{
	unsigned char r = irq_disable();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_WRITE_STATUS_CMD);
	if ((type == FLASH_TYPE_GD)||(type == FLASH_TYPE_XTX)){
		mspi_write((unsigned char)data);   //8 bit status
	}else if(type == FLASH_TYPE_PUYA){

		mspi_write((unsigned char)data);
		mspi_wait();
		mspi_write((unsigned char)(data>>8));//16bit status

	}
	mspi_wait();
	mspi_high();
	flash_wait_done();
	sleep_us(100);
	mspi_high();
	irq_restore(r);
}

/**
 * @brief This function serves to protect data for flash.
 * @param[in]   type - flash type include GD,Puya and XTX
 * @return none
 */
_attribute_ram_code_ void flash_unlock(Flash_TypeDef type)
{
	unsigned char r = irq_disable();

	flash_send_cmd(FLASH_WRITE_ENABLE_CMD);
	flash_send_cmd(FLASH_WRITE_STATUS_CMD);
	if ((type == FLASH_TYPE_GD)||(type == FLASH_TYPE_XTX)){
		mspi_write(0);   //8 bit status
	}else if(type == FLASH_TYPE_PUYA){

		mspi_write(0);
		mspi_wait();
		mspi_write(0);//16bit status

	}
	mspi_wait();
	mspi_high();
	flash_wait_done();
	sleep_us(100);
	mspi_high();
	irq_restore(r);
}
#endif
#endif


