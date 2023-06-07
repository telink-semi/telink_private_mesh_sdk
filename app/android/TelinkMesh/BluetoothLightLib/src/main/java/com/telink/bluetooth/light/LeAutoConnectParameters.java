/********************************************************************************************************
 * @file LeAutoConnectParameters.java
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
 * 自动重连参数
 * <p>{@link LeAutoConnectParameters}定义了{@link LightService#autoConnect(Parameters)} 方法的必须要设置的几项参数.
 *
 * @see LightService#autoConnect(Parameters)
 */
public final class LeAutoConnectParameters extends Parameters {

    /**
     * 创建{@link LeAutoConnectParameters}实例
     *
     * @return
     */
    public static LeAutoConnectParameters create() {
        return new LeAutoConnectParameters();
    }

    /**
     * 网络名
     *
     * @param value
     * @return
     */
    public LeAutoConnectParameters setMeshName(String value) {
        this.set(PARAM_MESH_NAME, value);
        return this;
    }

    /**
     * 密码
     *
     * @param value
     * @return
     */
    public LeAutoConnectParameters setPassword(String value) {
        this.set(PARAM_MESH_PASSWORD, value);
        return this;
    }

    /**
     * 是否在登录后开启打开Notification
     *
     * @param value
     * @return
     */
    public LeAutoConnectParameters autoEnableNotification(boolean value) {
        this.set(PARAM_AUTO_ENABLE_NOTIFICATION, value);
        return this;
    }

    /**
     * 连接超时时间,单位秒.
     */
    public LeAutoConnectParameters setTimeoutSeconds(int timeoutSeconds) {
        this.set(PARAM_TIMEOUT_SECONDS, timeoutSeconds);
        return this;
    }

    /**
     * 自动连接时，连接指定设备
     * NULL,表示不指定
     *
     * @param mac
     * @return
     */
    public LeAutoConnectParameters setConnectMac(String mac) {
        this.set(PARAM_AUTO_CONNECT_MAC, mac);
        return this;
    }
}
