/********************************************************************************************************
 * @file GetMeshDeviceNotificationParser.java
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

import com.telink.bluetooth.TelinkLog;
import com.telink.util.Arrays;

/**
 * 获取mesh设备列表 notify数据解析
 */
public final class GetMeshDeviceNotificationParser extends NotificationParser<GetMeshDeviceNotificationParser.MeshDeviceInfo> {

    private GetMeshDeviceNotificationParser() {
    }

    public static GetMeshDeviceNotificationParser create() {
        return new GetMeshDeviceNotificationParser();
    }

    @Override
    public byte opcode() {
        return Opcode.BLE_GATT_OP_CTRL_E1.getValue();
    }

    @Override
    public MeshDeviceInfo parse(NotificationInfo notifyInfo) {

        byte[] params = notifyInfo.params;


        TelinkLog.d("mesh device info notification parser: " + Arrays.bytesToHexString(params, ":"));
        // 63,71,FB,6C,00,C3,02,E1,11,02,6C,00,6C,88,1D,63,FF,FF,00,00
        // params : 6C,00,6C,88,1D,63,FF,FF,00,00

//        int offset = 0;
        MeshDeviceInfo meshDeviceInfo = new MeshDeviceInfo();
        meshDeviceInfo.deviceId = (params[0] & 0xFF) | (params[1] & 0xFF << 8);
        meshDeviceInfo.macBytes = new byte[6];
        System.arraycopy(params, 2, meshDeviceInfo.macBytes, 0, 6);
        meshDeviceInfo.productUUID = (params[8] & 0xFF) | (params[9] & 0xFF << 8);
        // 反转高低位
//        Arrays.reverse(meshDeviceInfo.macBytes);
        return meshDeviceInfo;
    }


    public final class MeshDeviceInfo {

        public int deviceId;

        public int newDeviceId = -1;

        public byte[] macBytes;

        public int productUUID;
    }
}
