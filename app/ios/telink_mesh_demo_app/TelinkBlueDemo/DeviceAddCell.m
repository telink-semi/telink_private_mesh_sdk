/********************************************************************************************************
 * @file     DeviceAddCell.m 
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
//  DeviceAddCell.m
//  TelinkBlueDemo
//
//  Created by Arvin on 2018/3/1.
//  Copyright © 2018年 Green. All rights reserved.
//

#import "DeviceAddCell.h"

@interface DeviceAddCell ()


@end
@implementation DeviceAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addBtn.hidden = YES;
}

- (IBAction)changeAddressAndConfigueMesh:(UIButton *)sender {
    if (self.addDeviceBlock) {
        self.addDeviceBlock();
    }
}

@end
