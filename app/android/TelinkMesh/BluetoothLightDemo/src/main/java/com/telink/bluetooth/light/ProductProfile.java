/********************************************************************************************************
 * @file ProductProfile.java
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

public enum ProductProfile {

    DIM(0x0001, "单色灯"), CCT(0x0002, ""), RGBW(0x0003, "四色灯，红绿蓝白"), RGB(0x0004, "三色灯，红绿蓝"), C_SLEEP(0x0005, "色温灯"), UNKNOWN(-1, "未定义");

    private int value;
    private String info;

    ProductProfile(int value, String info) {
        this.value = value;
        this.info = info;
    }

    public static ProductProfile valueOf(int value) {
        if (value == DIM.getValue())
            return DIM;
        if (value == CCT.getValue())
            return CCT;
        if (value == RGBW.getValue())
            return RGBW;
        if (value == RGB.getValue())
            return RGB;
        if (value == C_SLEEP.getValue())
            return C_SLEEP;

        return UNKNOWN;
    }

    public int getValue() {
        return value;
    }

    public String getInfo() {
        return info;
    }
}
