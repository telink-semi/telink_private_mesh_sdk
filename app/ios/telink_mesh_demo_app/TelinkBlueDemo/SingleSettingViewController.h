/********************************************************************************************************
 * @file     SingleSettingViewController.h 
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
//  SingleSettingViewController.h
//  TelinkBlueDemo
//
//  Created by Ken on 11/27/15.
//  Copyright © 2015 Green. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DeviceModel;
@class BTDevItem;
@interface SingleSettingViewController : UIViewController

@property (nonatomic, assign, getter=isGroup) BOOL isGroup;
@property (nonatomic, assign) int32_t groupAdr;
@property(nonatomic, strong) NSString *groupName;

@property(nonatomic,strong)BTDevItem *btItem;

@property (nonatomic, strong) DeviceModel *selData;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *kickOutButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (nonatomic,strong) IBOutlet  UISlider *brightSlider;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (nonatomic,strong) IBOutlet  UISlider *tempSlider;

-(IBAction)brightValueChange:(id)sender;
-(IBAction)tempValueChange:(id)sender;

-(IBAction)addToGroupClick:(id)sender;
-(IBAction)removeFromGroupClick:(id)sender;

@end
