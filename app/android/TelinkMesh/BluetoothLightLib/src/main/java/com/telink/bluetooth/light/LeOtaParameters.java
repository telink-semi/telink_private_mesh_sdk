/********************************************************************************************************
 * @file LeOtaParameters.java
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

/**
 * OTA参数
 *
 * @see LightService#startOta(Parameters)
 */
public final class LeOtaParameters extends Parameters {

    /**
     * 创建{@link LeOtaParameters}实例
     *
     * @return
     */
    public static LeOtaParameters create() {
        return new LeOtaParameters();
    }

    /**
     * 网络名
     *
     * @param value
     * @return
     */
    public LeOtaParameters setMeshName(String value) {
        this.set(PARAM_MESH_NAME, value);
        return this;
    }

    /**
     * 密码
     *
     * @param value
     * @return
     */
    public LeOtaParameters setPassword(String value) {
        this.set(PARAM_MESH_PASSWORD, value);
        return this;
    }

    /**
     * 扫描超时时间,单位秒
     *
     * @param value
     * @return
     */
    public LeOtaParameters setLeScanTimeoutSeconds(int value) {
        this.set(PARAM_SCAN_TIMEOUT_SECONDS, value);
        return this;
    }

    /**
     * 要进行OTA的设备
     *
     * @param value
     * @return
     * @see OtaDeviceInfo
     */
    public LeOtaParameters setDeviceInfo(OtaDeviceInfo value) {
        this.set(PARAM_DEVICE_LIST, value);
        return this;
    }
}
