/********************************************************************************************************
 * @file LeScanEvent.java
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

package com.telink.bluetooth.event;

import com.telink.bluetooth.light.DeviceInfo;

/**
 * 扫描事件
 */
public class LeScanEvent extends DataEvent<DeviceInfo> {

    /**
     * 扫描到设备
     */
    public static final String LE_SCAN = "com.telink.bluetooth.light.EVENT_LE_SCAN";
    public static final String LE_SCAN_COMPLETED = "com.telink.bluetooth.light.EVENT_LE_SCAN_COMPLETED";
    /**
     * 扫描超时
     */
    public static final String LE_SCAN_TIMEOUT = "com.telink.bluetooth.light.EVENT_LE_SCAN_TIMEOUT";

    public LeScanEvent(Object sender, String type, DeviceInfo args) {
        super(sender, type, args);
    }

    public static LeScanEvent newInstance(Object sender, String type, DeviceInfo args) {
        return new LeScanEvent(sender, type, args);
    }
}
