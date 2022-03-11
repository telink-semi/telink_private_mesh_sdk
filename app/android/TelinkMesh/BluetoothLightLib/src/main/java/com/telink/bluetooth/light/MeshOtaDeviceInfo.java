/********************************************************************************************************
 * @file MeshOtaDeviceInfo.java
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

/**
 * OTA设备信息
 */
public class MeshOtaDeviceInfo extends DeviceInfo {

    public static final Creator<MeshOtaDeviceInfo> CREATOR = new Creator<MeshOtaDeviceInfo>() {
        @Override
        public MeshOtaDeviceInfo createFromParcel(Parcel in) {
            return new MeshOtaDeviceInfo(in);
        }

        @Override
        public MeshOtaDeviceInfo[] newArray(int size) {
            return new MeshOtaDeviceInfo[size];
        }
    };

    /**
     * firmware数据
     */
    public byte[] firmware;
    /**
     * ota进度
     */
    public int progress;

    public int type;

    public int mode;

    public MeshOtaDeviceInfo() {
    }

    public MeshOtaDeviceInfo(Parcel in) {
        super(in);
        this.progress = in.readInt();
        this.type = in.readInt();
        this.mode = in.readInt();
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest, flags);
        dest.writeInt(this.progress);
        dest.writeInt(this.type);
        dest.writeInt(this.mode);
    }
}
