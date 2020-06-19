/********************************************************************************************************
 * @file     SharaDevice.h 
 *
 * @brief    for TLSR chips
 *
 * @author	 telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
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
//
//  SharaDevice.h
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/12/22.
//  Copyright © 2017年 Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharaDevice : NSObject <NSCoding>
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSNumber *address;
@property (nonatomic, strong) NSNumber *mac;
@end