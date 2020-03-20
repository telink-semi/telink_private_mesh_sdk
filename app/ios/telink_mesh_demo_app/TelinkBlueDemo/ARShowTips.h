/********************************************************************************************************
 * @file     ARShowTips.h 
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
//  ShowTips.h
//  Device-Blue-T
//
//  Created by Arvin on 2016/7/27.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ARShowTipsView.h"

#define ShowHandle          ([ARShowTips shareTips])
#define RemoveTipVDelay (3)

@interface ARShowTips : NSObject
@property (nonatomic, weak) ARShowTipsView *showTipsView;

+ (instancetype)shareTips;

- (void)alertShowTips:(NSString *)tips cancelBlock:(void(^)(void))cancelBlcok doBlcok:(void(^)(void))doBlock;

- (void(^)(NSString *tips))alertShow;
- (void (^)(void))alertHidden;
- (void (^)(void))alertVCHidden;

- (instancetype(^)(NSString *tip))showTip;
- (instancetype(^)(NSTimeInterval t))delayHidden;
- (instancetype(^)(void))hidden;
- (instancetype(^)(void))timeOut;

@end
