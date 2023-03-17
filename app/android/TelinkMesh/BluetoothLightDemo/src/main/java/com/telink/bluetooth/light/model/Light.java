/********************************************************************************************************
 * @file Light.java
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

import com.telink.bluetooth.light.ConnectionStatus;

import java.io.Serializable;

public final class Light implements Serializable {

    public String deviceName;
    public String meshName;
    public String macAddress;
    public int meshAddress;
    public int brightness;
    public int color;
    public int temperature;
    public ConnectionStatus connectionStatus;
    //    public DeviceInfo raw;
    public boolean selected;
    public int textColor;
    public String firmwareRevision;

    public int meshUUID;
    public int productUUID;

    public int status;
    public byte[] longTermKey = new byte[16];

    public String getLabel() {
        return Integer.toString(this.meshAddress, 16) + ":" + this.brightness;
    }

    public String getLabel1() {
        return "bulb-" + Integer.toString(this.meshAddress, 16);
    }

    public String getLabel2() {
        return Integer.toString(this.meshAddress, 16);
    }


}
