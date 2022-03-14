/********************************************************************************************************
 * @file     SingleSettingViewController.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/1/11
 *
 * @par     Copyright (c) [2014], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
 *
 *          Licensed under the Apache License, Version 2.0 (the "License");
 *          you may not use this file except in compliance with the License.
 *          You may obtain a copy of the License at
 *
 *              http://www.apache.org/licenses/LICENSE-2.0
 *
 *          Unless required by applicable law or agreed to in writing, software
 *          distributed under the License is distributed on an "AS IS" BASIS,
 *          WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *          See the License for the specific language governing permissions and
 *          limitations under the License.
 *******************************************************************************************************/

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
