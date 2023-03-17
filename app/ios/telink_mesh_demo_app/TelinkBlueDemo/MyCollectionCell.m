/********************************************************************************************************
 * @file     MyCollectionCell.m 
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
//  MyCollectionViewCell.m
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

#import "MyCollectionCell.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"

@interface MyCollectionCell()
@end

@implementation MyCollectionCell
- (void)updateState:(DeviceModel *)model {
    NSString *tempImgName = nil;
    switch (model.stata) {
        case LightStataTypeOutline:         tempImgName  =@"icon_light_offline"; break;
        case LightStataTypeOff:                tempImgName=@"icon_light_off";        break;
        case LightStataTypeOn:                tempImgName=@"icon_light_on";        break;
        default: break;
    }
    self.imgView.image = [UIImage imageNamed:tempImgName];
    self.titleLab.text = [NSString stringWithFormat:@"%02X:%ld", model.u_DevAdress>>8, (unsigned long)model.brightness];
    BOOL ret = [BTCentralManager shareBTCentralManager].selConnectedItem.u_DevAdress==model.u_DevAdress;
    self.titleLab.textColor = ret?[UIColor redColor] : [UIColor blackColor];
}


@end
