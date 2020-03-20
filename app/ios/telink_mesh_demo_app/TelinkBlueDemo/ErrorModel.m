/********************************************************************************************************
 * @file     ErrorModel.m 
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
//  ErrorModel.m
//  TelinkBlueDemo
//
//  Created by Arvin on 2018/1/22.
//  Copyright © 2018年 Green. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel
- (instancetype)initWithID:(NSString *)identify address:(NSUInteger)add {
    if (self = [super init]) {
        _identify = identify;
        _address = add;
    }
    return self;
}
- (NSString *)description {
    return @{@"add" : @(self.address), @"id":self.identify, @"addcount": @(self.count), @"sucess":(self.isSuccess?@"success":@"fail")}.description;
}
@end

