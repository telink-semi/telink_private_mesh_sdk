/********************************************************************************************************
 * @file     OTATipShowVC.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/12
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
#import "DemoDefine.h"
@interface OTATipShowVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSMutableArray <BTDevItem *> *otaDevices;
@property (strong, nonatomic) NSMutableArray <NSString *> *hasOTADevices;
@property (weak, nonatomic) IBOutlet UILabel *progressL;
@property (strong, nonatomic) BTDevItem *otaItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
- (void)showTip:(NSString *)tip;
- (BOOL)hasOTA:(NSString *)uuidstr;
@end
