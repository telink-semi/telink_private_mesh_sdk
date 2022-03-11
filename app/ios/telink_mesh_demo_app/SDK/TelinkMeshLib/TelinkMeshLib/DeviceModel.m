/********************************************************************************************************
 * @file     DeviceModel.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/11/14
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

#import "DeviceModel.h"

@implementation DeviceModel

-(BOOL)addGrpAddressPro:(int)addAdr
{
    BOOL result=NO;
    for (int i=0; i<8; i++)
    {
        if (grpAdress[i]==0xff)
        {
            grpAdress[i]=addAdr;
            result=YES;
            break;
        }
    }
    return result;
}

-(BOOL)removeGrpAddressPro:(int)addAdr
{
    BOOL result=NO;
    for (int i=0; i<8; i++)
    {
        if (grpAdress[i]==addAdr)
        {
            grpAdress[i]=0xff;
            result=YES;
        }
    }
    return result;
}

- (void)updataLightStata:(DeviceModel *)model {
    self.stata = model.stata;
    self.brightness = model.brightness;
}

- (instancetype)initWithModel:(DeviceModel *)model {
    if (self=[super init]) {
        _u_DevAdress = model.u_DevAdress;
        _brightness = model.brightness;
        _stata = model.stata;
        _versionString = model.versionString;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[DeviceModel class]]) {
        return _u_DevAdress == ((DeviceModel *)object).u_DevAdress;
    } else {
        return NO;
    }
}

@end
