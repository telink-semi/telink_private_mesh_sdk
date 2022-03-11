/********************************************************************************************************
 * @file     LightData.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/19
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LightData : NSObject
{
    uint32_t macAdress;
    uint32_t devAress;//地址
    uint32_t devAressPer;//一个字节地址
    int lightStatus;//0-离线  1-灯灭  2-灯亮
    int comStartAdress;
    int bright;
    int colorTel;//色温
    UIColor *color;
    NSString *music;
    id devItem;
    BOOL isGetStatus;
    
@public
    int grpAdress[8];
}
@property (nonatomic, assign) uint32_t devAress;
@property (nonatomic, assign) int comStartAdress;
@property (nonatomic, assign) uint32_t devAressPer;
@property (nonatomic, assign) uint32_t macAdress;
@property (nonatomic, assign) int lightStatus;
@property (nonatomic, assign) int bright;
@property (nonatomic, assign) int colorTel;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *music;
@property (nonatomic, strong) id devItem;
@property (nonatomic, assign, getter=isGetStatus) BOOL isGetStatus;

@property(nonatomic,strong)NSString *addressName;


-(BOOL)addGrpAddressPro:(int)addAdr;
-(BOOL)removeGrpAddressPro:(int)addAdr;

@end
