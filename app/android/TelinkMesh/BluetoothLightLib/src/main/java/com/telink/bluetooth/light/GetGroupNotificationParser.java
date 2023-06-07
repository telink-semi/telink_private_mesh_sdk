/********************************************************************************************************
 * @file GetGroupNotificationParser.java
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

import java.util.ArrayList;
import java.util.List;

/**
 * 分组通知解析器
 */
public final class GetGroupNotificationParser extends NotificationParser<List<Integer>> {

    private GetGroupNotificationParser() {
    }

    public static GetGroupNotificationParser create() {
        return new GetGroupNotificationParser();
    }

    @Override
    public byte opcode() {
        return Opcode.BLE_GATT_OP_CTRL_D4.getValue();
    }

    @Override
    public List<Integer> parse(NotificationInfo notifyInfo) {

        List<Integer> mAddress = new ArrayList<>();

        byte[] params = notifyInfo.params;
        int length = params.length;
        int position = 0;
        int address;

        while (position < length) {
            address = params[position++];
            address = address & 0xFF;

            if (address == 0xFF)
                break;

            address = address | 0x8000;
            mAddress.add(address);
        }

        return mAddress;
    }
}
