/********************************************************************************************************
 * @file GetTimeNotificationParser.java
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

import java.util.Calendar;

/**
 * 时间同步通知解析器
 */
public final class GetTimeNotificationParser extends NotificationParser<Calendar> {

    private GetTimeNotificationParser() {
    }

    public static GetTimeNotificationParser create() {
        return new GetTimeNotificationParser();
    }

    @Override
    public byte opcode() {
        return Opcode.BLE_GATT_OP_CTRL_E9.getValue();
    }

    @Override
    public Calendar parse(NotificationInfo notifyInfo) {

        byte[] params = notifyInfo.params;
        int offset = 0;

        int year = ((params[offset++] & 0xFF) << 8) + (params[offset++] & 0xFF);
        int month = (params[offset++] & 0xFF) - 1;
        int day = params[offset++] & 0xFF;
        int hour = params[offset++] & 0xFF;
        int minute = params[offset++] & 0xFF;
        int second = params[offset] & 0xFF;

        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day, hour, minute, second);

        return calendar;
    }
}
