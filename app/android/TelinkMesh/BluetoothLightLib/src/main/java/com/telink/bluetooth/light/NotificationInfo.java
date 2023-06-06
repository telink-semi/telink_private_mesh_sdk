/********************************************************************************************************
 * @file NotificationInfo.java
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
 * NotificationInfo封装收到的蓝牙Notification信息
 */
public final class NotificationInfo implements Parcelable {

    public static final Creator<NotificationInfo> CREATOR = new Creator<NotificationInfo>() {
        @Override
        public NotificationInfo createFromParcel(Parcel in) {
            return new NotificationInfo(in);
        }

        @Override
        public NotificationInfo[] newArray(int size) {
            return new NotificationInfo[size];
        }
    };

    /**
     * 操作码
     */
    public int opcode;

    /**
     * vendor Id
     */
    public int vendorId;
    /**
     * 源地址
     */
    public int src;
    /**
     * 参数
     */
    public byte[] params = new byte[10];

    /**
     * 当前连接的设备
     */
    public DeviceInfo deviceInfo;

    public NotificationInfo() {
    }

    public NotificationInfo(Parcel in) {
        this.opcode = in.readInt();
        this.vendorId = in.readInt();
        this.src = in.readInt();
        in.readByteArray(this.params);
        Object ret = in.readValue(DeviceInfo.class.getClassLoader());
        if (ret != null) {
            this.deviceInfo = (DeviceInfo) ret;
        }
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.opcode);
        dest.writeInt(this.vendorId);
        dest.writeInt(this.src);
        dest.writeByteArray(this.params);

        if (this.deviceInfo != null) {
            dest.writeValue(this.deviceInfo);
        }
    }

    @Override
    public int describeContents() {
        return 0;
    }
}
