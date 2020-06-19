/********************************************************************************************************
 * @file     ARShowTipsView.m 
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
//  ShowTipsView.m
//  Device-Blue-T
//
//  Created by Arvin on 2016/7/27.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ARShowTipsView.h"

@implementation ARShowTipsView
- (instancetype)initFrame {
    self = [[[NSBundle mainBundle] loadNibNamed:@"ARShowTipsView" owner:nil options:nil] firstObject];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 20;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:66/255.0 green:193/255.0 blue:247/255.0 alpha:1.0].CGColor;
    self.bounds = CGRectMake(0, 0, 100, 100);
    return self;
}

@end
