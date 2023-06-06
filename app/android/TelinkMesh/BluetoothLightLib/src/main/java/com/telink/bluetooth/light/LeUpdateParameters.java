/********************************************************************************************************
 * @file LeUpdateParameters.java
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

import java.util.Arrays;

/**
 * 更新网络参数
 *
 * @see LightService#updateMesh(Parameters)
 */
public final class LeUpdateParameters extends Parameters {

    /**
     * 创建{@link LeOtaParameters}实例
     *
     * @return
     */
    public static LeUpdateParameters create() {
        return new LeUpdateParameters();
    }

    /**
     * 旧的网络名
     *
     * @param value
     * @return
     */
    public LeUpdateParameters setOldMeshName(String value) {
        this.set(PARAM_MESH_NAME, value);
        return this;
    }

    /**
     * 新的网络名
     *
     * @param value
     * @return
     */
    public LeUpdateParameters setNewMeshName(String value) {
        this.set(PARAM_NEW_MESH_NAME, value);
        return this;
    }

    /**
     * 旧的密码
     *
     * @param value
     * @return
     */
    public LeUpdateParameters setOldPassword(String value) {
        this.set(PARAM_MESH_PASSWORD, value);
        return this;
    }

    /**
     * 新的密码
     *
     * @param value
     * @return
     */
    public LeUpdateParameters setNewPassword(String value) {
        this.set(PARAM_NEW_PASSWORD, value);
        return this;
    }

    /**
     * LTK,如果不设置将使用厂商默认值,即{@link Manufacture#getFactoryLtk()}
     *
     * @param value
     * @return
     */
    public LeUpdateParameters setLtk(byte[] value) {
        this.set(PARAM_LONG_TERM_KEY, value);
        return this;
    }

    /**
     * 更新的设备列表
     *
     * @param value
     * @return
     * @see DeviceInfo
     */
    public LeUpdateParameters setUpdateDeviceList(DeviceInfo... value) {
        this.set(PARAM_DEVICE_LIST, Arrays.asList(value));
        return this;
    }
}
