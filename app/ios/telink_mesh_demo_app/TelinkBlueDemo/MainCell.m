/********************************************************************************************************
 * @file     MainCell.m 
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
//  MainCell.m
//  TelinkBlueDemo
//
//  Created by telink on 15/12/12.
//  Copyright © 2015年 Green. All rights reserved.
//

#import "MainCell.h"

@implementation MainCell


-(void)descriptionWith:(LightData *)tempdata{
    
    
    /**
      *
     
     //        LightData *tempData=[dataArrs objectAtIndex:indexPath.row];
     //        NSString *tempImgName=@"icon_light_offline";
     //
     /
     //  *灯的状态的回调
     //  */
    //        if (tempData.lightStatus==1)
    //            tempImgName=@"icon_light_off";
    //        else if (tempData.lightStatus==2)
    //        tempImgName=@"icon_light_on";
    //        tempCell.imgView.image=[UIImage imageNamed:tempImgName];
    //        tempCell.imgView.tag=indexPath.row;
    //        tempCell.titleLab.text=[NSString stringWithFormat:@"%0x",tempData.devAress];
    //        if ((tempData.devAress == [BTCentralManager shareBTCentralManager].selConnectedItem.u_DevAdress)) {
    //            tempCell.titleLab.textColor = [UIColor redColor];
    //        }else{
    //            tempCell.titleLab.textColor = [UIColor blackColor];
    //        }

    self.tintColor = [UIColor redColor];
    
    }



@end
