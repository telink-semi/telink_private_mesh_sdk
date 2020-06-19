/********************************************************************************************************
 * @file     GroupCell.m 
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
//  GroupCell.m
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/4/12.
//  Copyright © 2017年 Green. All rights reserved.
//

#import "GroupCell.h"
#import "DemoDefine.h"
@implementation GroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)turnOn:(UISwitch *)sender {
    if (sender.on) {
        [kCentralManager turnOnCertainGroupWithAddress:self.groupID];
    }else{
        [kCentralManager turnOffCertainGroupWithAddress:self.groupID];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
