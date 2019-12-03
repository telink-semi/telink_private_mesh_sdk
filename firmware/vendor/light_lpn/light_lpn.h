/********************************************************************************************************
 * @file     light_lpn.h 
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

/* Enable C linkage for C++ Compilers: */
#if defined(__cplusplus)
extern "C" {
#endif

#include "../common/chip_type_project.h"

#if (__PROJECT_CHIP_TYPE_SEL__ == PROJECT_CHIP_8267)
#include "light_lpn_8267.h"
#elif (__PROJECT_CHIP_TYPE_SEL__ == PROJECT_CHIP_8269)
#include "light_lpn_8269.h"
#elif (__PROJECT_CHIP_TYPE_SEL__ == PROJECT_CHIP_8258)
#include "light_lpn_8258.h"
#else   // for (__PROJECT_CHIP_TYPE_SEL__ == PROJECT_CHIP_8266)
#include "light_lpn_8266.h"
#endif

/* Disable C linkage for C++ Compilers: */
#if defined(__cplusplus)
}
#endif
