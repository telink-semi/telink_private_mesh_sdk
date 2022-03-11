/********************************************************************************************************
 * @file     MeshOTAManager.h
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/4/24
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
#import "BTCentralManager.h"

typedef void(^ProgressBlock)(MeshOTAState meshState,NSInteger progress);
typedef void(^FinishBlock)(NSInteger successNumber,NSInteger failNumber);
typedef void(^ErrorBlock)(NSError *error);

@interface MeshOTAManager : NSObject

+ (MeshOTAManager*)share;

///开始meshOTA，设备在非OTA状态下时调用
- (void)startMeshOTAWithDeviceType:(NSInteger )deviceType otaData:(NSData *)otaData progressHandle:(ProgressBlock )progressBlock finishHandle:(FinishBlock )finishBlock errorHandle:(ErrorBlock )errorBlock;

///继续meshOTA，打开APP发现本地存在meshOTA的state数据时调用
- (void)continueMeshOTAWithDeviceType:(NSInteger )deviceType progressHandle:(ProgressBlock )progressBlock finishHandle:(FinishBlock )finishBlock errorHandle:(ErrorBlock )errorBlock;

///停止meshOTA，上面的start和continue两个接口会自动调用stop，用户中途想停止meshOTA可以调用该接口
- (void)stopMeshOTA;

///查询当前是否处在meshOTA
- (BOOL)isMeshOTAing;

///设置是否处理mac地址的notify回包(bytes[7] == 0xe1),因为meshAdd时，会收到大量不需要处理的mac回包。
- (void)setHandleMacNotify:(BOOL)able;

///设置当前的设备状态列表
- (void)setCurrentDevices:(NSArray <DeviceModel *>*)devices;

- (NSArray <DeviceModel *>*)getAllDevices;

- (BOOL)hasMeshStateData;

- (NSDictionary *)getSaveMeshStateData;

@end
