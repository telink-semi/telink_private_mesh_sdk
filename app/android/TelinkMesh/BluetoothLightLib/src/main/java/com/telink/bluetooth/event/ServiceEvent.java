/********************************************************************************************************
 * @file ServiceEvent.java
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

import android.os.IBinder;

/**
 * LightService事件
 */
public class ServiceEvent extends DataEvent<IBinder> {

    /**
     * 服务启动
     */
    public static final String SERVICE_CONNECTED = "com.telink.bluetooth.light.EVENT_SERVICE_CONNECTED";
    /**
     * 服务关闭
     */
    public static final String SERVICE_DISCONNECTED = "com.telink.bluetooth.light.EVENT_SERVICE_DISCONNECTED";

    public ServiceEvent(Object sender, String type, IBinder args) {
        super(sender, type, args);
    }

    public static ServiceEvent newInstance(Object sender, String type, IBinder args) {
        return new ServiceEvent(sender, type, args);
    }
}