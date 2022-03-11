/********************************************************************************************************
 * @file     ARMainVC.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/10
 *
 * @par     Copyright (c) [2017], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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
#import "DeviceModel.h"

static NSString *const RemoveDeviceKey = @"RemoveDeviceKey";

@interface ARMainVC : UIViewController

//方便其它地方获取当前的设备列表
@property(nonatomic, strong) NSMutableArray <DeviceModel *>*collectionSource;

@property (nonatomic, assign) BOOL isNeedRescan;
@property(nonatomic,strong) NSMutableArray *filterlist;

- (void)changeMeshInfoReload;

@end
