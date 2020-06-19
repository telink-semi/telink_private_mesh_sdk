/********************************************************************************************************
 * @file     AppDelegate.h 
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
//  AppDelegate.h
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#define kDuration @"Duration"
#import "BTCentralManager.h"
#import "LogVC.h"
#define  kDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)SettingViewController *settingVC;
@property (nonatomic, strong)UIButton *logBtn;
@property (nonatomic, strong) LogVC *logVC;
@end

