/********************************************************************************************************
 * @file     flash.h 
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

#pragma once

#include "../common/types.h"
#include "../mcu/compiler.h"

enum{
	FLASH_WRITE_STATUS_CMD		=	0x01,
	FLASH_WRITE_CMD				=	0x02,
	FLASH_READ_CMD				=	0x03,
	FLASH_WRITE_DISABLE_CMD 	= 	0x04,
	FLASH_READ_STATUS_CMD		=	0x05,
	FLASH_WRITE_ENABLE_CMD 		= 	0x06,
	FLASH_SECT_ERASE_CMD		=	0x20,
	FLASH_READ_STATUS_CMD1		=	0x35,
	FLASH_GD_PUYA_READ_UID_CMD	=	0x4B,	//Flash Type = GD/PUYA
	FLASH_32KBLK_ERASE_CMD		=	0x52,
	FLASH_XTX_READ_UID_CMD		=	0x5A,	//Flash Type = XTX
	FLASH_CHIP_ERASE_CMD		=	0x60,   //or 0xc7
	FLASH_PAGE_ERASE_CMD		=	0x81,   //caution: only P25Q40L support this function
	FLASH_64KBLK_ERASE_CMD		=	0xD8,
	FLASH_POWER_DOWN			=	0xB9,
	FLASH_POWER_DOWN_RELEASE	=	0xAB,
	FLASH_GET_JEDEC_ID			=	0x9F,
};

/**
 * @brief     flash type definition
 */
 
typedef enum{
	FLASH_TYPE_GD = 0 ,
	FLASH_TYPE_XTX,
	FLASH_TYPE_PUYA
}Flash_TypeDef;

typedef enum {
	FLASH_SIZE_64K 	= 0x10,
	FLASH_SIZE_128K = 0x11,
	FLASH_SIZE_256K = 0x12,
	FLASH_SIZE_512K = 0x13,
	FLASH_SIZE_1M 	= 0x14,
	FLASH_SIZE_2M 	= 0x15,
	FLASH_SIZE_4M 	= 0x16,
	FLASH_SIZE_8M 	= 0x17,
} Flash_CapacityDef;

_attribute_ram_code_ void flash_erase_sector(u32 addr);
_attribute_ram_code_ void flash_erase_block(u32 addr);
/*_attribute_ram_code_ */void flash_write_page(u32 addr, u32 len, u8 *buf);
_attribute_ram_code_ void flash_read_page(u32 addr, u32 len, u8 *buf);

void flash_get_id();
int flash_protect_disable();
int flash_protect_up256k();
int flash_protect_down256k();
int flash_protect_8266_normal();
int flash_protect_OTA_copy();
int flash_protect_8267_normal();
int flash_protect_8269_normal();
int flash_protect_8266_OTA_clr_flag();
int flash_protect_8267_OTA_clr_flag();
int flash_unprotect_OTA_start();
int flash_protect_OTA_data_erase();
void flash_protect_debug();

/***********************************
 * @brief	  This function serves to read MID of flash
 * @param[in] buf - store MID of flash
 * @return    none.
 */
void flash_read_mid(unsigned char *buf);

/* according to your appliaction */
#if 0
/**
 * @brief     This function serves to erase a page(256 bytes).
 * @param[in] addr - the start address of the page needs to erase.
 * @return    none
 * @note      only 8359 support
 */
void flash_erase_page(unsigned int addr);

/**
 * @brief This function serves to erase a block(32k).
 * @param[in]   addr the start address of the block needs to erase.
 * @return none
 */
void flash_erase_32kblock(unsigned int addr);

/**
 * @brief This function serves to erase a block(64k).
 * @param[in]   addr the start address of the block needs to erase.
 * @return none
 */
void flash_erase_64kblock(unsigned int addr);

/**
 * @brief     This function serves to erase a page(256 bytes).
 * @param[in] addr - the start address of the page needs to erase.
 * @return    none
 */
void flash_erase_chip(void);


/**
 * @brief This function write the status of flash.
 * @param[in]  the value of status
 * @return status
 */
unsigned char flash_write_status(unsigned char data);

/**
 * @brief This function reads the status of flash.
 * @param[in]  none
 * @return none
 */
unsigned char flash_read_status(void);

/**
 * @brief  	Deep Power Down mode to put the device in the lowest consumption mode
 * 			it can be used as an extra software protection mechanism,while the device
 * 			is not in active use,since in the mode,  all write,Program and Erase commands
 * 			are ignored,except the Release from Deep Power-Down and Read Device ID(RDI)
 * 			command.This release the device from this mode
 * @param[in] none
 * @return none.
 */
void flash_deep_powerdown(void);

/**
 * @brief		The Release from Power-Down or High Performance Mode/Device ID command is a
 * 				Multi-purpose command.it can be used to release the device from the power-Down
 * 				State or High Performance Mode or obtain the devices electronic identification
 * 				(ID)number.Release from Power-Down will take the time duration of tRES1 before
 * 				the device will resume normal operation and other command are accepted.The CS#
 * 				pin must remain high during the tRES1(8us) time duration.
 * @param[in]   none
 * @return      none.
 */
void flash_release_deep_powerdown(void);

/**
 * @brief	  This function serves to read UID of flash
 * @param[in] idcmd - different flash vendor have different read-uid command
 *                    GD/PUYA:0x4B; XTX: 0x5A
 * @param[in] buf   - store UID of flash
 * @return    none.
 */
void flash_read_uid(unsigned char idcmd,unsigned char *buf);
/**
 * @brief 		 This function serves to read flash mid and uid,and check the correctness of mid and uid.
 * @param[out]   flash_mid - Flash Manufacturer ID
 * @param[out]   flash_uid - Flash Unique ID
 * @return       0:error 1:ok

 */
int flash_read_mid_uid_with_check( unsigned int *flash_mid ,unsigned char *flash_uid);
/**
 * @brief This function serves to protect data for flash.
 * @param[in]   type - flash type include GD,Puya and XTX
 * @param[in]   data - refer to Driver API Doc.
 * @return none
 */
void flash_lock(Flash_TypeDef type , unsigned short data);

/**
 * @brief This function serves to protect data for flash.
 * @param[in]   type - flash type include GD,Puya and XTX
 * @return none
 */
void flash_unlock(Flash_TypeDef type);
#endif

void flash_set_capacity(Flash_CapacityDef flash_cap);
Flash_CapacityDef flash_get_capacity(void);

extern unsigned int flash_sector_calibration;
extern u32 ota_firmware_size_k;

