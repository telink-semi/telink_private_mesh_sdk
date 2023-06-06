/********************************************************************************************************
 * @file     ARShowTips.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2016/7/27
 *
 * @par     Copyright (c) [2014], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/

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
