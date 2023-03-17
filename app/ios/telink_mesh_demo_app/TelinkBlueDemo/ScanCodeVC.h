/********************************************************************************************************
 * @file     ScanCodeVC.h 
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
//  ScanCodeVC.h
//  telinkLight
//
//  Created by telink on 16/8/26.
//  Copyright © 2016年 xlink. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ARScanView;
@interface ScanCodeVC : UIViewController
@property (nonatomic, copy) void(^scanCodeVCBlock)(id content);
- (void)scanDataViewControllerBackBlock:(void (^)(id content))block;
+ (instancetype)scanCodeVC;
@end
