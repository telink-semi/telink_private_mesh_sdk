/********************************************************************************************************
 * @file DeviceInfo.java
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

import android.os.Parcel;
import android.os.Parcelable;

/**
 * 设备信息类
 */
public class DeviceInfo implements Parcelable {

    public static final Creator<DeviceInfo> CREATOR = new Creator<DeviceInfo>() {
        @Override
        public DeviceInfo createFromParcel(Parcel in) {
            return new DeviceInfo(in);
        }

        @Override
        public DeviceInfo[] newArray(int size) {
            return new DeviceInfo[size];
        }
    };

    /**
     * Mac地址
     */
    public String macAddress;
    /**
     * 设备名称
     */
    public String deviceName;

    /**
     * 网络名称
     */
    public String meshName;
    /**
     * 网络地址
     */
    public int meshAddress;
    public int meshUUID;
    /**
     * 设备的产品标识符
     */
    public int productUUID;
    public int status;
    public byte[] longTermKey = new byte[16];
    /**
     * 设备的firmware版本
     */
    public String firmwareRevision;

    // 子版本信息
    public String subversion;

    public int rssi;

    public DeviceInfo() {
    }

    public DeviceInfo(Parcel in) {
        this.macAddress = in.readString();
        this.deviceName = in.readString();
        this.meshName = in.readString();
        this.firmwareRevision = in.readString();
        this.subversion = in.readString();
        this.meshAddress = in.readInt();
        this.meshUUID = in.readInt();
        this.productUUID = in.readInt();
        this.status = in.readInt();
        in.readByteArray(this.longTermKey);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(this.macAddress);
        dest.writeString(this.deviceName);
        dest.writeString(this.meshName);
        dest.writeString(this.firmwareRevision);
        dest.writeString(this.subversion);
        dest.writeInt(this.meshAddress);
        dest.writeInt(this.meshUUID);
        dest.writeInt(this.productUUID);
        dest.writeInt(this.status);
        dest.writeByteArray(this.longTermKey);
    }
}
