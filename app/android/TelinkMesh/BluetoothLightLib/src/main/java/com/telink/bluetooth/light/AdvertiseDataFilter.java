/********************************************************************************************************
 * @file AdvertiseDataFilter.java
 *
 * @brief for TLSR chips
 *
 * @author telink
 * @date Sep. 30, 2017
 *
 * @par Copyright (c) 2017, Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

package com.telink.bluetooth.light;

import android.bluetooth.BluetoothDevice;

/**
 * 广播包过滤接口
 *
 * @param <E>
 */
public interface AdvertiseDataFilter<E extends LightPeripheral> {

    /**
     * 过滤接口
     *
     * @param device     扫描到的蓝牙设备
     * @param rssi       信号强度
     * @param scanRecord 广播数据包
     * @return
     */
    E filter(BluetoothDevice device, int rssi,
             byte[] scanRecord);
}
