/********************************************************************************************************
 * @file     BTCentralManager+MeshAdd.h
 *
 * @brief    for TLSR chips
 *
 * @author     telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *
 *             The information contained herein is confidential and proprietary property of Telink
 *              Semiconductor (Shanghai) Co., Ltd. and is available under the terms
 *             of Commercial License Agreement between Telink Semiconductor (Shanghai)
 *             Co., Ltd. and the licensee in separate contract or the terms described here-in.
 *           This heading MUST NOT be removed from this file.
 *
 *              Licensees are granted free, non-transferable use of the information in this
 *             file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided.
 *
 *******************************************************************************************************/
//
//  BTCentralManager+MeshAdd.h
//  TelinkMeshLib
//
//  Created by 梁家誌 on 2019/1/5.
//  Copyright © 2019 Telink. All rights reserved.
//

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
