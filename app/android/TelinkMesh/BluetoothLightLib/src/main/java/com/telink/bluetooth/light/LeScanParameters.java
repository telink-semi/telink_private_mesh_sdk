/********************************************************************************************************
 * @file LeScanParameters.java
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
 * 扫描参数类
 * <p>{@link LeScanParameters}定义了{@link LightService#startScan(Parameters)}方法的必须要设置的几项参数.
 *
 * @see LightService#startScan(Parameters)
 */
public final class LeScanParameters extends Parameters {

    /**
     * 创建LeScanParameters实例
     *
     * @return
     */
    public static LeScanParameters create() {
        return new LeScanParameters();
    }

    /**
     * 网络名
     *
     * @param value
     * @return
     */
    public LeScanParameters setMeshName(String value) {
        this.set(Parameters.PARAM_MESH_NAME, value);
        return this;
    }

    /**
     * 超时时间(单位秒),在这个时间段内如果没有发现任何设备将停止扫描.
     *
     * @param value
     * @return
     */
    public LeScanParameters setTimeoutSeconds(int value) {
        this.set(Parameters.PARAM_SCAN_TIMEOUT_SECONDS, value);
        return this;
    }

    /**
     * 踢出网络后的名称,默认值为out_of_mesh
     *
     * @param value
     * @return
     */
    public LeScanParameters setOutOfMeshName(String value) {
        this.set(PARAM_OUT_OF_MESH, value);
        return this;
    }

    /**
     * 扫描模式,true时扫描到一个设备就会立即停止扫描.
     *
     * @param singleScan
     * @return
     */
    public LeScanParameters setScanMode(boolean singleScan) {
        this.set(Parameters.PARAM_SCAN_TYPE_SINGLE, singleScan);
        return this;
    }

    /**
     * 扫描的设备mac
     *
     * @param mac 目标地址
     * @return this
     */
    public LeScanParameters setScanMac(String mac) {
        this.set(PARAM_SCAN_MAC, mac);
        return this;
    }


    /**
     * 扫描设备类型过滤
     *
     * @param type 目标类型
     * @return
     */
    public LeScanParameters setScanTypeFilter(int type) {
        this.set(PARAM_SCAN_TYPE_FILTER, type);
        return this;
    }

}
