/********************************************************************************************************
 * @file Mesh.java
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
package com.telink.bluetooth.light.model;

import android.content.Context;
import android.text.TextUtils;

import com.telink.bluetooth.light.util.FileSystem;
import com.telink.util.MeshUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class Mesh implements Serializable {

    private static final long serialVersionUID = 1L;

    public String name;
    public String password;
    public String factoryName;
    public String factoryPassword;
    public OtaDevice otaDevice;

    //public String otaDevice;

    //    public List<Integer> allocDeviceAddress;
    public List<Light> devices = new ArrayList<>();


    public int getDeviceAddress() {
        if (devices == null || devices.size() == 0) {
            return 1;
        }

        flag_index:
        for (int i = MeshUtils.DEVICE_ADDRESS_MIN; i <= MeshUtils.DEVICE_ADDRESS_MAX; i++) {
            for (Light lxDeviceInfo : devices) {
                if (lxDeviceInfo.meshAddress == i) {
                    continue flag_index;
                }
            }
            return i;
        }

        return -1;


        /*int address = MeshUtils.allocDeviceAddress(this.allocDeviceAddress);

        if (address != -1) {
            if (this.allocDeviceAddress == null)
                this.allocDeviceAddress = new ArrayList<>();
            this.allocDeviceAddress.add(address);
        }

        return address;*/
    }

    public Light getDevice(int meshAddress) {
        if (this.devices == null)
            return null;

        for (Light info : devices) {
            if (info.meshAddress == meshAddress)
                return info;
        }
        return null;
    }

    public boolean removeDeviceByMeshAddress(int meshAddress) {
        if (devices == null || devices.size() == 0) {
            return false;
        }

        Iterator<Light> infoIterator = devices.iterator();
        while (infoIterator.hasNext()) {
            if (infoIterator.next().meshAddress == meshAddress) {
                infoIterator.remove();
                return true;
            }
        }

        return false;
    }

    public boolean saveOrUpdate(Context context) {
        return FileSystem.writeAsObject(context, name + "." + password, this);
//        return FileSystem.writeAsObject("telink.meshs", this);
    }

    public boolean isOtaProcessing() {
        if (name == null || password == null || otaDevice == null ||
                TextUtils.isEmpty(otaDevice.mac) || TextUtils.isEmpty(otaDevice.meshName) || TextUtils.isEmpty(otaDevice.meshPwd)) {
            return false;
        }
        return name.equals(otaDevice.meshName) && password.equals(otaDevice.meshPwd);
    }
}
