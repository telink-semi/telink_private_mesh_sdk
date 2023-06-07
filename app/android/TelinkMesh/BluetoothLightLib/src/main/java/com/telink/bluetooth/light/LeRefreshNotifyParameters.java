/********************************************************************************************************
 * @file LeRefreshNotifyParameters.java
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
 * 自动刷新Notify参数
 *
 * @see LightService#autoRefreshNotify(Parameters)
 */
public final class LeRefreshNotifyParameters extends Parameters {

    /**
     * 创建{@link LeRefreshNotifyParameters}实例
     *
     * @return
     */
    public static LeRefreshNotifyParameters create() {
        return new LeRefreshNotifyParameters();
    }

    /**
     * 刷新次数
     *
     * @param value
     * @return
     */
    public LeRefreshNotifyParameters setRefreshRepeatCount(int value) {
        this.set(PARAM_AUTO_REFRESH_NOTIFICATION_REPEAT, value);
        return this;
    }

    /**
     * 间隔时间,单位毫秒
     *
     * @param value
     * @return
     */
    public LeRefreshNotifyParameters setRefreshInterval(int value) {
        this.set(PARAM_AUTO_REFRESH_NOTIFICATION_DELAY, value);
        return this;
    }
}
