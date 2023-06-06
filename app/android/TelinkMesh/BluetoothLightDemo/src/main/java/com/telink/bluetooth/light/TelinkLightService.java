/********************************************************************************************************
 * @file TelinkLightService.java
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

import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;

public final class TelinkLightService extends LightService {

    private static TelinkLightService mThis;

    public static TelinkLightService Instance() {
        return mThis;
    }

    @Override
    public IBinder onBind(Intent intent) {

        if (this.mBinder == null)
            this.mBinder = new LocalBinder();

        return super.onBind(intent);
    }

    @Override
    public void onCreate() {

        super.onCreate();

        mThis = this;

        if (this.mAdapter == null)
            this.mAdapter = new LightAdapter();
        this.mAdapter.start(this);
    }

    public class LocalBinder extends Binder {
        public TelinkLightService getService() {
            return TelinkLightService.this;
        }
    }
}
