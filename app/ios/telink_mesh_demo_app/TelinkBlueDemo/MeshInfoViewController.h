/********************************************************************************************************
 * @file     MeshInfoViewController.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/2/28
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

#import "BaseViewController.h"

@interface MeshInfoViewController : BaseViewController

@property (nonatomic,strong) IBOutlet UITextField *oNameTxt;
@property (nonatomic,strong) IBOutlet UITextField *oPasswordTxt;

@property (nonatomic,strong) IBOutlet UITextField *curNameTxt;
@property (nonatomic,strong) IBOutlet UITextField *curPasswordTxt;

//平常情况为80



-(IBAction)saveBtnClick:(id)sender;

@property (nonatomic, copy) void(^UpdateMeshInfo)(NSString *name, NSString *pwd);

@end
