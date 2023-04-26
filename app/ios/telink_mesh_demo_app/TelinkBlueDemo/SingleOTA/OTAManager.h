/********************************************************************************************************
 * @file     OTAManager.h
 *
 * @brief    for TLSR chips
 *
 * @author     telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *
 *             The information contained herein is confidential and proprietary property of Telink
 *              Semiconductor (Shanghai) Co., Ltd. and is available under the terms
 *             of Commercial License Agreement between Telink Semiconductor (Shanghai)
 *             Co., Ltd. and the licensee in separate contract or the terms described here-in.
 *           This heading MUST NOT be removed from this file.
 *
 *              Licensees are granted free, non-transferable use of the information in this
 *             file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided.
 *
 *******************************************************************************************************/
//
//  OTAManager.h
//  TelinkBlueDemo
//
//  Created by Liangjiazhi on 2019/4/26.
//  Copyright © 2019年 Green. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^singleDeviceCallBack)(NSNumber *address);
typedef void(^singleProgressCallBack)(float progress);
typedef void(^finishCallBack)(NSArray <NSNumber *>*successNumbers,NSArray <NSNumber *>*fileNumbers);

@interface OTAManager : NSObject

+ (OTAManager *)share;

/**
 OTA，can not call repeat when app is OTAing
 
 @param otaData data for OTA
 @param addressNumbers addresses for OTA
 @param singleSuccessAction callback when single model OTA  success
 @param singleFailAction callback when single model OTA  fail
 @param singleProgressAction callback with single model OTA progress
 @param finishAction callback when all models OTA finish
 @return use API success is ture;user API fail is false.
 */
- (BOOL)startOTAWithOtaData:(NSData *)otaData addressNumbers:(NSArray <NSNumber *>*)addressNumbers singleSuccessAction:(singleDeviceCallBack)singleSuccessAction singleFailAction:(singleDeviceCallBack)singleFailAction singleProgressAction:(singleProgressCallBack)singleProgressAction finishAction:(finishCallBack)finishAction;

/// stop OTA
- (void)stopOTA;

@end

NS_ASSUME_NONNULL_END
