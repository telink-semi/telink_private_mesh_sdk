/********************************************************************************************************
 * @file MeshUtils.java
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

import java.security.SecureRandom;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public final class MeshUtils {

    public static final int GROUP_ADDRESS_MIN = 0x8001;
    public static final int GROUP_ADDRESS_MAX = 0x80FF;
    public static final int DEVICE_ADDRESS_MIN = 0x0001;
    public static final int DEVICE_ADDRESS_MAX = 0x00FF;

    public static final String CHARS = "123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ+-*/<>/?!@#$%^&;'[]{}|,.";

    private static final MeshAddressComparator MESH_ADDRESS_COMPARATOR = new MeshAddressComparator();

    private static int GroupAddress = GROUP_ADDRESS_MIN;
    private static int DeviceAddress = DEVICE_ADDRESS_MIN;

    private static SecureRandom rng;

    private MeshUtils() {
    }

    public static byte[] generateRandom(int length) {

        byte[] data = new byte[length];

        synchronized (MeshUtils.class) {
            if (rng == null) {
                rng = new SecureRandom();
            }
        }

        rng.nextBytes(data);

        return data;
    }

    public static byte[] generateChars(int length) {

        int charLen = CHARS.length() - 1;
        int charAt;

        byte[] data = new byte[length];

        for (int i = 0; i < length; i++) {
            charAt = (int) Math.round(Math.random() * charLen);
            data[i] = (byte) CHARS.charAt(charAt);
        }

        return data;
    }

    synchronized public static int allocGroupAddress(List<Integer> allocAddress) {

        if (allocAddress == null || allocAddress.isEmpty()) {

            GroupAddress = GROUP_ADDRESS_MIN;

            if ((GroupAddress + 1) > GROUP_ADDRESS_MAX)
                return -1;

            return GroupAddress++;
        }

        int count = allocAddress.size();

        if (count > (GROUP_ADDRESS_MAX - GROUP_ADDRESS_MIN))
            return -1;

        Collections.sort(allocAddress, MESH_ADDRESS_COMPARATOR);

        Integer last = allocAddress.get(count - 1);

        if ((last + 1) <= GROUP_ADDRESS_MAX)
            return last + 1;

        Integer prev = null;
        Integer next;

        int i = 0;

        while (i < count) {

            if (prev == null) {
                prev = allocAddress.get(i);
                i = 1;
                continue;
            }

            next = allocAddress.get(i);

            if ((prev + 1) != next && prev != GROUP_ADDRESS_MAX) {
                return prev + 1;
            }

            if ((i + 1) >= count) {

                if (next >= GROUP_ADDRESS_MAX) {
                    GroupAddress = GROUP_ADDRESS_MIN;
                    return GroupAddress++;
                } else {
                    return next + 1;
                }
            }

            prev = next;
            i++;
        }

        return -1;
    }

    synchronized public static int allocDeviceAddress(List<Integer> allocAddress) {

        if (allocAddress == null || allocAddress.isEmpty()) {

            DeviceAddress = DEVICE_ADDRESS_MIN;

            if ((DeviceAddress + 1) > DEVICE_ADDRESS_MAX)
                return -1;

            return DeviceAddress++;
        }

        int count = allocAddress.size();

        if (count > (DEVICE_ADDRESS_MAX - DEVICE_ADDRESS_MIN))
            return -1;

        Collections.sort(allocAddress, MESH_ADDRESS_COMPARATOR);

        Integer last = allocAddress.get(count - 1);

        if ((last + 1) <= DEVICE_ADDRESS_MAX)
            return last + 1;

        Integer prev = null;
        Integer next;

        int i = 0;

        while (i < count) {

            if (prev == null) {
                prev = allocAddress.get(i);
                i = 1;
                continue;
            }

            next = allocAddress.get(i);

            if ((prev + 1) != next && prev != DEVICE_ADDRESS_MAX) {
                return prev + 1;
            }

            if ((i + 1) >= count) {

                if (next >= DEVICE_ADDRESS_MAX) {
                    DeviceAddress = DEVICE_ADDRESS_MIN;
                    return DeviceAddress++;
                } else {
                    return next + 1;
                }
            }

            prev = next;
            i++;
        }

        return -1;
    }

    private static class MeshAddressComparator implements Comparator<Integer> {

        @Override
        public int compare(Integer lhs, Integer rhs) {

            if (lhs > rhs)
                return 1;
            if (lhs < rhs)
                return -1;
            return 0;
        }
    }
}
