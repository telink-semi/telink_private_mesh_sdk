/********************************************************************************************************
 * @file BuildUtils.java
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

package com.telink.util;

import android.os.Build;

public final class BuildUtils {

    private BuildUtils() {
    }

    public static int assetSdkVersion(String version) {

        String[] v1 = version.split("\\.");
        String[] v2 = Build.VERSION.RELEASE.split("\\.");

        int len1 = v1.length;
        int len2 = v2.length;

        int len = len1 > len2 ? len2 : len1;

        int tempV1;
        int tempV2;

        for (int i = 0; i < len; i++) {
            tempV1 = Integer.parseInt(v1[i]);
            tempV2 = Integer.parseInt(v2[i]);

            if (tempV2 < tempV1)
                return -1;
            else if (tempV2 > tempV1)
                return 1;
        }

        return 0;
    }
}
