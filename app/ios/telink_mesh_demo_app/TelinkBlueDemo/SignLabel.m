/********************************************************************************************************
 * @file     SignLabel.m 
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
//  SignLabel.m
//  TelinkBlueDemo
//
//  Created by telink on 16/1/12.
//  Copyright © 2016年 Green. All rights reserved.
//

#import "SignLabel.h"

@implementation SignLabel

+(SignLabel *)DesignLabel{
    UILabel *signLabel = [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width/2)-50, [UIScreen mainScreen].bounds.size.height-80,100 , 30)];
    signLabel.backgroundColor = [UIColor lightGrayColor];
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.font = [UIFont boldSystemFontOfSize:12];
    signLabel.textColor = [UIColor greenColor];
     signLabel.hidden = YES;
    return (SignLabel *)signLabel;
}
-(void)setLabelMessage:(NSString *)text Hidden:(BOOL)isHidden{
    self.text = text;
    self.hidden = isHidden;
}
@end
