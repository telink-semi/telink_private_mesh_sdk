/********************************************************************************************************
 * @file ErrorReportInfo.java
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
 * Created by kee on 2017/10/18.
 */

public class ErrorReportInfo implements Parcelable {


    /**
     * state code
     */
    public int stateCode;

    /**
     * error code
     */
    public int errorCode;

    public int deviceId;

    public ErrorReportInfo() {

    }

    public static final Creator<ErrorReportInfo> CREATOR = new Creator<ErrorReportInfo>() {
        @Override
        public ErrorReportInfo createFromParcel(Parcel in) {
            return new ErrorReportInfo(in);
        }

        @Override
        public ErrorReportInfo[] newArray(int size) {
            return new ErrorReportInfo[size];
        }
    };

    public ErrorReportInfo(Parcel in) {
        this.stateCode = in.readInt();
        this.errorCode = in.readInt();
        this.deviceId = in.readInt();
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(this.stateCode);
        dest.writeInt(this.errorCode);
        dest.writeInt(this.deviceId);
    }

}
