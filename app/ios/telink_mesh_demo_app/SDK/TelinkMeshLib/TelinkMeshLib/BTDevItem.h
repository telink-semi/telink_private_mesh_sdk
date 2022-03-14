/********************************************************************************************************
 * @file     BTDevItem.h 
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
#import <CoreBluetooth/CoreBluetooth.h>

@interface BTDevItem : NSObject
{
    NSString *devIdentifier;//设备标示
    NSString *name;//
    CBPeripheral *blDevInfo;//设备信息
    
    NSString *u_Name;
    uint32_t u_Vid;
    uint32_t u_Pid;
    uint32_t u_Mac;
    uint32_t u_meshUuid;
    uint32_t u_DevAdress;
    uint32_t u_Status;
    int rssi;//蓝牙信号
    
    BOOL isSeted;//是否设置了Network Info
    BOOL isSetedSuff;//设置Network Info 是否成功
    
    BOOL isConnected;//是否已连接
    BOOL isBreakOff;//是否断开 关闭或者范围之外
    
    uint32_t productID;//设备类型标识
    
}
@property (nonatomic, strong) NSString *devIdentifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CBPeripheral *blDevInfo;
@property (nonatomic, strong) NSString *u_Name;
@property (nonatomic, assign) uint32_t u_Vid;
@property (nonatomic, assign) uint32_t u_Pid;
@property (nonatomic, assign) uint32_t u_Mac;
@property (nonatomic, assign) int rssi;
@property (nonatomic, assign, getter=isConnected) BOOL isConnected;
@property (nonatomic, assign, getter=isBreakOff) BOOL isBreakOff;
@property (nonatomic, assign, getter=isSeted) BOOL isSeted;
@property (nonatomic, assign) uint32_t u_meshUuid;
@property (nonatomic, assign) uint32_t u_DevAdress;
@property (nonatomic, assign) uint32_t u_Status;
@property (nonatomic, assign, getter=isSetedSuff) BOOL isSetedSuff;

@property(nonatomic,assign)uint32_t productID;

- (instancetype)initWithDevice:(BTDevItem *)item;
- (NSString *)uuidString;

//新增，补全Mac的默认字符串
#define kMacComplement  @"FFFF"

///新增，返回Mac字符串
- (NSString *)getMacAddressFromU_Mac;

@end
