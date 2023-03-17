/********************************************************************************************************
 * @file UuidInformation.java
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


import androidx.annotation.Nullable;

import java.util.UUID;

public enum UuidInformation {

    TELINK_SERVICE(UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1910"), "Telink SmartLight Service"),
    TELINK_CHARACTERISTIC_PAIR(UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1914"), "pair"),
    TELINK_CHARACTERISTIC_COMMAND(UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1912"), "command"),
    TELINK_CHARACTERISTIC_NOTIFY(UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1911"), "notify"),
    TELINK_CHARACTERISTIC_OTA(UUID.fromString("00010203-0405-0607-0809-0a0b0c0d1913"), "ota"),

    SERVICE_DEVICE_INFORMATION(UUID.fromString("0000180a-0000-1000-8000-00805f9b34fb"), "Device Information Service"),
    CHARACTERISTIC_FIRMWARE(UUID.fromString("00002a26-0000-1000-8000-00805f9b34fb"), "Firmware Revision"),
    CHARACTERISTIC_MANUFACTURER(UUID.fromString("00002a29-0000-1000-8000-00805f9b34fb"), "Manufacturer Name"),
    CHARACTERISTIC_MODEL(UUID.fromString("00002a24-0000-1000-8000-00805f9b34fb"), "Model Number"),
    CHARACTERISTIC_HARDWARE(UUID.fromString("00002a27-0000-1000-8000-00805f9b34fb"), "Hardware Revision"),

    CUSTOM_SERVICE(UUID.fromString("19200d0c-0b0a-0908-0706-050403020100"), "Custom Service"),
    SUBVERSION_INFORMATION(UUID.fromString("00002af0-0000-1000-8000-00805f9b34fb"), "Subversion Info"),

    ;
    private String info;
    private UUID value;

    UuidInformation(UUID value, @Nullable String info) {
        this.value = value;
        this.info = info;
    }

    public String getInfo() {
        return info;
    }

    public UUID getValue() {
        return value;
    }
}
