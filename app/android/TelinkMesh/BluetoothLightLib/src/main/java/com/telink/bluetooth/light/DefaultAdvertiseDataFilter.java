/********************************************************************************************************
 * @file DefaultAdvertiseDataFilter.java
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

import android.bluetooth.BluetoothDevice;

import com.telink.bluetooth.TelinkLog;
import com.telink.util.Arrays;

/**
 * 默认的广播过滤器
 * <p>根据VendorId识别设备.
 */
public final class DefaultAdvertiseDataFilter implements AdvertiseDataFilter<LightPeripheral> {

    private DefaultAdvertiseDataFilter() {
    }

    public static DefaultAdvertiseDataFilter create() {
        return new DefaultAdvertiseDataFilter();
    }

    @Override
    public LightPeripheral filter(BluetoothDevice device, int rssi, byte[] scanRecord) {

        TelinkLog.d(device.getName() + "-->" + Arrays.bytesToHexString(scanRecord, ":"));

        int length = scanRecord.length;
        int packetPosition = 0;
        int packetContentLength;
        int packetSize;
        int position;
        int type;
        byte[] meshName = null;

        int rspData = 0;

        while (packetPosition < length) {

            packetSize = scanRecord[packetPosition];

            if (packetSize == 0)
                break;

            position = packetPosition + 1;
            type = scanRecord[position] & 0xFF;
            position++;

            if (type == 0x09) {

                packetContentLength = packetSize - 1;

                if (packetContentLength > 16 || packetContentLength <= 0)
                    return null;

                meshName = new byte[16];
                System.arraycopy(scanRecord, position, meshName, 0, packetContentLength);
            } else if (type == 0xFF) {

                rspData++;

                if (rspData == 2) {

                    int vendorId = ((scanRecord[position++] & 0xFF)) + ((scanRecord[position++] & 0xFF) << 8);

                    if (vendorId != Manufacture.getDefault().getVendorId())
                        return null;

                    int meshUUID = (scanRecord[position++] & 0xFF) + ((scanRecord[position++] & 0xFF) << 8);
                    position += 4;
                    int productUUID = (scanRecord[position++] & 0xFF) + ((scanRecord[position++] & 0xFF) << 8);
                    int status = scanRecord[position++] & 0xFF;
                    int meshAddress = (scanRecord[position++] & 0xFF) + ((scanRecord[position] & 0xFF) << 8);

                    LightPeripheral light = new LightPeripheral(device, scanRecord, rssi, meshName, meshAddress);
                    light.putAdvProperty(LightPeripheral.ADV_MESH_NAME, meshName);
                    light.putAdvProperty(LightPeripheral.ADV_MESH_ADDRESS, meshAddress);
                    light.putAdvProperty(LightPeripheral.ADV_MESH_UUID, meshUUID);
                    light.putAdvProperty(LightPeripheral.ADV_PRODUCT_UUID, productUUID);
                    light.putAdvProperty(LightPeripheral.ADV_STATUS, status);

                    return light;
                }
            }

            packetPosition += packetSize + 1;
        }

        return null;
    }
}
