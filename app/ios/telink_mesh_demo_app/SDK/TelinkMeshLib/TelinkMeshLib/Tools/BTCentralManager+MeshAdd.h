/********************************************************************************************************
 * @file     BTCentralManager+MeshAdd.h
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2019/1/5
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

#import "BTCentralManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTCentralManager (MeshAdd)

/**
check is mesh ota supported by devices in mesh network
*/
- (void)checkMeshScanSupportState;

/**
 获取当前mesh网络的所有设备mac
 */
- (void)getAddressMac;

/**
 修改设备的短地址
 
 @param address 修改前的短地址
 @param newAddress 修改后的短地址
 @param mac 设备的mac
 */
- (void)changeDeviceAddress:(uint8_t)address new:(uint8_t)newAddress mac:(uint32_t)mac;

/**
 临时设置当前网络到默认网络
 */
- (void)allDefault;

/**
 清除临时设置
 */
- (void)allResett;

@end

NS_ASSUME_NONNULL_END
