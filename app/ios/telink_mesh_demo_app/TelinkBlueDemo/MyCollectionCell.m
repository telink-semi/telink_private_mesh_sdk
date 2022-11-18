/********************************************************************************************************
 * @file     MyCollectionCell.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/19
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

#import "MyCollectionCell.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "UIColor+Telink.h"

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
    self.titleLab.textColor = ret?[UIColor redColor] : UIColor.telinkTitleBlack;
}


@end
