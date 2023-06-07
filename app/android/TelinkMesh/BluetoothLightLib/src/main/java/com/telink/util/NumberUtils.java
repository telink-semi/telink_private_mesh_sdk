/********************************************************************************************************
 * @file NumberUtils.java
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

public final class NumberUtils {

    private NumberUtils() {
    }

    static public int byteToInt(byte s, int bitStartPosition, int bitEndPosition) {
        int bit = bitEndPosition - bitStartPosition + 1;
        int maxValue = 1 << bit;
        int result = 0;

        for (int i = bitEndPosition, j = bit; i > bitStartPosition; i--, j--) {
            result += (s >> i & 0x01) << j;
        }

        return result & maxValue;
    }

    static public long bytesToLong(byte[] s, int start, int length) {
        int end = start + length;
        int max = length - 1;
        long result = 0;

        for (int i = start, j = max; i < end; i++, j--) {
            result += (s[i] & 0xFF) << (8 * j);
        }

        return result;
    }
}
