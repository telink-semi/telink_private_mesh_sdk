/********************************************************************************************************
 * @file Parameters.java
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


import java.util.HashMap;
import java.util.Map;

public class Parameters {

    public static final String PARAM_MESH_NAME = "com.telink.bluetooth.light.PARAM_MESH_NAME";
    public static final String PARAM_OUT_OF_MESH = "com.telink.bluetooth.light.PARAM_OUT_OF_MESH";
    public static final String PARAM_MESH_PASSWORD = "com.telink.bluetooth.light.PARAM_MESH_PASSWORD";
    public static final String PARAM_NEW_MESH_NAME = "com.telink.bluetooth.light.PARAM_NEW_MESH_NAME";
    public static final String PARAM_NEW_PASSWORD = "com.telink.bluetooth.light.PARAM_NEW_PASSWORD";
    public static final String PARAM_TIMEOUT_SECONDS = "com.telink.bluetooth.light.PARAM_TIMEOUT_SECONDS";
    public static final String PARAM_LONG_TERM_KEY = "com.telink.bluetooth.light.PARAM_LONG_TERM_KEY";
    public static final String PARAM_AUTO_REFRESH_NOTIFICATION_REPEAT = "com.telink.bluetooth.light.PARAM_AUTO_REFRESH_NOTIFICATION_REPEAT";
    public static final String PARAM_AUTO_REFRESH_NOTIFICATION_DELAY = "com.telink.bluetooth.light.PARAM_AUTO_REFRESH_NOTIFICATION_DELAY";
    public static final String PARAM_DEVICE_LIST = "com.telink.bluetooth.light.PARAM_DEVICE_LIST";
    public static final String PARAM_SCAN_TIMEOUT_SECONDS = "com.telink.bluetooth.light.PARAM_SCAN_TIMEOUT_SECONDS";
    public static final String PARAM_SCAN_TYPE_SINGLE = "com.telink.bluetooth.light.PARAM_SCAN_TYPE_SINGLE";
    public static final String PARAM_OFFLINE_TIMEOUT_SECONDS = "com.telink.bluetooth.light.PARAM_OFFLINE_TIMEOUT_SECONDS";

    public static final String PARAM_AUTO_ENABLE_NOTIFICATION = "com.telink.bluetooth.light.PARAM_AUTO_ENABLE_NOTIFICATION";
    public static final String PARAM_AUTO_CONNECT_MAC = "com.telink.bluetooth.light.PARAM_AUTO_CONNECT_MAC";
    public static final String PARAM_SCAN_MAC = "com.telink.bluetooth.light.PARAM_SCAN_MAC";

    public static final String PARAM_SCAN_TYPE_FILTER = "com.telink.bluetooth.light.PARAM_SCAN_TYPE_FILTER";

    public static final int DEFAULT_SCAN_TYPE = -1;
    private final Map<String, Object> mParams = new HashMap<>();

    public Parameters() {
        this.set(PARAM_OUT_OF_MESH, "out_of_mesh");
        this.set(PARAM_SCAN_TYPE_FILTER, DEFAULT_SCAN_TYPE);
    }

    public static Parameters newInstance() {
        return new Parameters();
    }

    public static LeScanParameters createScanParameters() {
        return LeScanParameters.create();
    }

    public static LeUpdateParameters createUpdateParameters() {
        return LeUpdateParameters.create();
    }

    public static LeAutoConnectParameters createAutoConnectParameters() {
        return LeAutoConnectParameters.create();
    }

    public static LeRefreshNotifyParameters createRefreshNotifyParameters() {
        return LeRefreshNotifyParameters.create();
    }

    public static LeOtaParameters createOtaParameters() {
        return LeOtaParameters.create();
    }


    public Parameters set(String key, Object value) {
        this.mParams.put(key, value);
        return this;
    }

    public Object get(String key) {
        return this.mParams.get(key);
    }

    public byte[] getBytes(String key) {
        if (this.mParams.containsKey(key))
            return (byte[]) this.mParams.get(key);
        return null;
    }

    public int getInt(String key, int defaultValue) {
        if (this.mParams.containsKey(key))
            return (int) this.mParams.get(key);
        return defaultValue;
    }

    public int getInt(String key) {
        return this.getInt(key, 0);
    }

    public boolean getBoolean(String key, boolean defaultValue) {
        if (this.mParams.containsKey(key))
            return (boolean) this.mParams.get(key);
        return defaultValue;
    }

    public String getString(String key) {
        if (this.mParams.containsKey(key))
            return (String) this.mParams.get(key);
        return null;
    }

    public boolean getBoolean(String key) {
        return this.getBoolean(key, false);
    }

    public boolean contains(String key) {
        return this.mParams.containsKey(key);
    }

    public void clear() {
        this.mParams.clear();
    }
}
