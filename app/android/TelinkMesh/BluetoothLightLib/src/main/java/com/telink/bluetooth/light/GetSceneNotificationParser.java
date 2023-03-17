/********************************************************************************************************
 * @file GetSceneNotificationParser.java
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

public final class GetSceneNotificationParser extends NotificationParser<GetSceneNotificationParser.SceneInfo> {

    private GetSceneNotificationParser() {
    }

    public static GetSceneNotificationParser create() {
        return new GetSceneNotificationParser();
    }

    @Override
    public byte opcode() {
        return Opcode.BLE_GATT_OP_CTRL_C1.getValue();
    }

    @Override
    public SceneInfo parse(NotificationInfo notifyInfo) {

        byte[] params = notifyInfo.params;
        int offset = 8;
        int total = params[offset];

        if (total == 0)
            return null;

        offset = 0;
        int index = params[offset++] & 0xFF;
        int lum = params[offset++] & 0xFF;
        int r = params[offset++] & 0xFF;
        int g = params[offset++] & 0xFF;
        int b = params[offset] & 0xFF;

        SceneInfo sceneInfo = new SceneInfo();
        sceneInfo.index = index;
        sceneInfo.total = total;
        sceneInfo.lum = lum;
        sceneInfo.rgb = (r << 16) + (g << 8) + b;

        return sceneInfo;
    }

    public final class SceneInfo {
        public int index;
        public int total;
        public int lum;
        public int rgb;
    }
}
