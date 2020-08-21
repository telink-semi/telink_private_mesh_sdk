/********************************************************************************************************
 * @file     ARMainVC.h 
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
//  ARMainVC.h
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/4/10.
//  Copyright © 2017年 Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceModel.h"

static NSString *const RemoveDeviceKey = @"RemoveDeviceKey";

@interface ARMainVC : UIViewController

//方便其它地方获取当前的设备列表
@property(nonatomic, strong) NSMutableArray <DeviceModel *>*collectionSource;

@property (nonatomic, assign) BOOL isNeedRescan;
@property(nonatomic,strong) NSMutableArray *filterlist;

- (void)changeMeshInfoReload;

@end
