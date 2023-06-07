/********************************************************************************************************
 * @file OtaDevice.java
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
package com.telink.bluetooth.light.model;

import java.io.Serializable;

/**
 * MeshOTA升级过程中会将正在升级的设备保存在本地
 * 在意外退出或者连接状态不稳定时，优先连接保存的设备；
 * Created by Administrator on 2017/4/25.
 */

public class OtaDevice implements Serializable {
    private static final long serialVersionUID = 2L;

    // saved mesh info
    public String meshName;
    public String meshPwd;
    public String mac;
}
