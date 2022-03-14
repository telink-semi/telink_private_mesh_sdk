/********************************************************************************************************
 * @file     DeviceModel.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/11/14
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


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LightStataType) {
    LightStataTypeOutline,
    LightStataTypeOn,
    LightStataTypeOff,
};

@interface DeviceModel : NSObject{
@public
    int grpAdress[8];
}

/**
 *地址：0x0100,0x0200,0x0300
 */
@property(nonatomic,assign)uint32_t u_DevAdress;

/**
 *状态－0-离线状态   1-－在线关灯状态  3-－－在线开灯状态
 */

@property(nonatomic,assign)LightStataType stata;

/**
 *亮度－0-到 100；
 */
@property(nonatomic,assign)NSUInteger brightness;

@property (nonatomic, strong) NSString *versionString;

-(BOOL)addGrpAddressPro:(int)addAdr;
-(BOOL)removeGrpAddressPro:(int)addAdr;

- (void)updataLightStata:(DeviceModel *)model;
- (instancetype)initWithModel:(DeviceModel *)model;

@end
