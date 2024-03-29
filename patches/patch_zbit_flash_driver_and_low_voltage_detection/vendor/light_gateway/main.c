/********************************************************************************************************
 * @file     main.c 
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

#include "../../proj/tl_common.h"

#include "../../proj/mcu/watchdog_i.h"
#include "../../vendor/common/user_config.h"

#include "../../proj_lib/rf_drv.h"
#include "../../proj_lib/pm.h"

extern void user_init();
extern void proc_button_ahead();
void main_loop(void);

FLASH_ADDRESS_DEFINE;
int main (void) {
	FLASH_ADDRESS_CONFIG;
#if(MCU_CORE_TYPE == MCU_CORE_8278)
	cpu_wakeup_init(LDO_MODE,EXTERNAL_XTAL_24M);
#else
	cpu_wakeup_init();
#endif
	usb_dp_pullup_en (1);

#if(MCU_CORE_TYPE == MCU_CORE_8258 || MCU_CORE_TYPE == MCU_CORE_8278)
#if (CLOCK_SYS_CLOCK_HZ == 16000000)
	clock_init(SYS_CLK_16M_Crystal);
#elif (CLOCK_SYS_CLOCK_HZ == 32000000)
	clock_init(SYS_CLK_32M_Crystal);
#endif
#else
	clock_init();
#endif

	dma_init();
	gpio_init();	

	irq_init();

//	usb_init();
	
#if(MCU_CORE_TYPE == MCU_CORE_8258 || MCU_CORE_TYPE == MCU_CORE_8278)
	rf_drv_init(RF_MODE_BLE_1M);
	blc_app_loadCustomizedParameters();
#else
	rf_drv_init(0);
#endif

    user_init ();

    usb_log_init ();

    irq_enable();

	while (1) {
#if(MODULE_WATCHDOG_ENABLE)
		wd_clear();
#endif
		main_loop ();
	}
}


