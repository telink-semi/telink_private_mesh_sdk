/********************************************************************************************************
 * @file MeshEvent.java
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

/**
 * 网络事件
 */
public class MeshEvent extends DataEvent<Integer> {

    public static final String UPDATE_COMPLETED = "com.telink.bluetooth.light.EVENT_UPDATE_COMPLETED";
    /**
     * 连接到不任何设备的时候分发此事件
     */
    public static final String OFFLINE = "com.telink.bluetooth.light.EVENT_OFFLINE";
    /**
     * 出现异常时分发此事件,比如蓝牙关闭了
     */
    public static final String ERROR = "com.telink.bluetooth.light.EVENT_ERROR";

    public MeshEvent(Object sender, String type, Integer args) {
        super(sender, type, args);
    }

    public static MeshEvent newInstance(Object sender, String type, Integer args) {
        return new MeshEvent(sender, type, args);
    }
}
