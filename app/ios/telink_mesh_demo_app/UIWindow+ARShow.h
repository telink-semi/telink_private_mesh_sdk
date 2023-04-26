/********************************************************************************************************
 * @file     UIWindow+ARShow.h 
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
//  UIWindow+ARShow.h
//  OTA
//
//  Created by telink on 16/7/12.
//  Copyright © 2016年 Arvin.shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWindow ([UIApplication sharedApplication].keyWindow)
#define kWindowShow(tips) ([kWindow alertShowTips:tips])
@interface UIWindow (ARShow)

- (void)alertShowTips:(NSString *)content;
@end
