/********************************************************************************************************
 * @file JsonTest.java
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
package com.telink.bluetooth.light.util;

import com.google.gson.Gson;

import java.io.Serializable;
import java.util.List;

/**
 * Created by kee on 2018/8/23.
 */

public class JsonTest {

    public static void main(String[] args) {
        Gson gson = new Gson();
        Mesh mesh = new Mesh();
        mesh.address = 1;
        mesh.name = "telink_mesh1";
        mesh.meshKey = new byte[]{12, 23};
//        mesh.groups = new ArrayList<>();
        String jsonResult = gson.toJson(mesh);
        System.out.print(jsonResult);


        Mesh mesh1 = gson.fromJson(jsonResult, Mesh.class);
    }


    public static class Mesh implements Serializable {
        public String name;
        public String pwd;
        public byte[] meshKey;
        public int address;
        public List<String> groups;
    }
}
