/********************************************************************************************************
 * @file MeshCommandUtil.java
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
package com.telink.bluetooth.light.util;

import com.telink.bluetooth.light.TelinkLightService;

/**
 * Created by kee on 2018/4/28.
 */

public class MeshCommandUtil {

    /**
     * 停止mesh ota
     */
    public static void sendStopMeshOTACommand() {
        byte opcode = (byte) 0xC6;
        int address = 0xFFFF;
        byte[] params = new byte[]{(byte) 0xFE, (byte) 0xFF};
        TelinkLightService.Instance().sendCommandNoResponse(opcode, address,
                params);
    }

    /**
     * 获取设备OTA状态
     */
    public static void getDeviceOTAState() {
        byte opcode = (byte) 0xC7;
        int address = 0x0000;
        byte[] params = new byte[]{0x20, 0x05};
        TelinkLightService.Instance().sendCommandNoResponse(opcode, address,
                params);
    }

    /**
     * 获取设备版本
     */
    public static void getVersion() {
        byte opcode = (byte) 0xC7;
        int address = 0xFFFF;
        byte[] params = new byte[]{0x20, 0x00};
        TelinkLightService.Instance().sendCommandNoResponse(opcode, address, params);
    }


}
