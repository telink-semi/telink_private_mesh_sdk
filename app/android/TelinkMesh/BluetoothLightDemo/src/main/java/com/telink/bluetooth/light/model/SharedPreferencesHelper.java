/********************************************************************************************************
 * @file SharedPreferencesHelper.java
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
import android.content.SharedPreferences;

/**
 * Created by kee on 2017/12/22.
 */

public class SharedPreferencesHelper {
    private static final String FILE_NAME = "com.telink.bluetooth.light.SharedPreferences";

    private static final String KEY_MESH_NAME = "com.telink.bluetooth.light.mesh_name";
    private static final String KEY_MESH_PASSWORD = "com.telink.bluetooth.light.mesh_password";

    private static final String KEY_DIR_PATH = "com.telink.bluetooth.light.KEY_DIR_PATH";

    public static String getMeshName(Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getString(KEY_MESH_NAME, null);
    }

    public static String getMeshPassword(Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getString(KEY_MESH_PASSWORD, null);
    }

    public static void saveMeshName(Context context, String name) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(KEY_MESH_NAME, name)
                .apply();
    }

    public static void saveMeshPassword(Context context, String pwd) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(KEY_MESH_PASSWORD, pwd)
                .apply();
    }

    public static void saveDirPath(Context context, String path) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(KEY_DIR_PATH, path)
                .apply();
    }

    public static String getDirPath(Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(FILE_NAME, Context.MODE_PRIVATE);
        return sharedPreferences.getString(KEY_DIR_PATH, null);
    }
}
