/********************************************************************************************************
 * @file Test.java
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
package com.telink;

import com.telink.util.MeshUtils;

import java.util.ArrayList;
import java.util.List;

public class Test {


    public static void main(String[] args) {

//        test1();
//        test2();
//        test3();
//        test4();
//        test5();
        test6();

//        test11();
//        test12();
//        test13();
//        test14();
//        test15();
    }


    private static void test1() {
        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(null);
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test2() {

        List<Integer> allocAddress = new ArrayList<>();
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MAX);

        int groupAddr;

        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test3() {

        List<Integer> allocAddress = new ArrayList<>();
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MAX);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN);


        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test4() {

        List<Integer> allocAddress = new ArrayList<>();
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN);

        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test5() {

        List<Integer> allocAddress = new ArrayList<>();

        int addr = MeshUtils.GROUP_ADDRESS_MIN;

        for (int i = 0; i < 100; i++) {
            allocAddress.add(addr);
            addr++;
        }

        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test6() {

        List<Integer> allocAddress = new ArrayList<>();

        int addr = MeshUtils.GROUP_ADDRESS_MAX;

        for (int i = 0; i < 100; i++) {
            System.out.println(addr);
            allocAddress.add(addr);
            addr -= 5;
        }

        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN + 5);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN + 6);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN + 7);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN + 8);
        allocAddress.add(MeshUtils.GROUP_ADDRESS_MIN + 9);

        System.out.println("----------------");

        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocGroupAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test11() {
        int deviceAddr;
        for (int i = 0; i < 10; i++) {
            deviceAddr = MeshUtils.allocDeviceAddress(null);
            System.out.println(deviceAddr + ":" + Integer.toHexString(deviceAddr));
        }
    }

    private static void test12() {

        List<Integer> allocAddress = new ArrayList<>();
        allocAddress.add(MeshUtils.DEVICE_ADDRESS_MAX);

        int groupAddr;

        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocDeviceAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test13() {

        List<Integer> allocAddress = new ArrayList<>();

        allocAddress.add(MeshUtils.DEVICE_ADDRESS_MAX);
        allocAddress.add(MeshUtils.DEVICE_ADDRESS_MIN);

        int groupAddr;

        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocDeviceAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }

    private static void test14() {

        List<Integer> allocAddress = new ArrayList<>();
        allocAddress.add(MeshUtils.DEVICE_ADDRESS_MIN);

        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocDeviceAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }


    private static void test15() {

        List<Integer> allocAddress = new ArrayList<>();

        int addr = MeshUtils.DEVICE_ADDRESS_MIN;

        for (int i = 0; i < 250; i++) {
            allocAddress.add(addr++);
        }

        int groupAddr;
        for (int i = 0; i < 10; i++) {
            groupAddr = MeshUtils.allocDeviceAddress(allocAddress);
            if (groupAddr != -1) {
                allocAddress.add(groupAddr);
            }
            System.out.println(groupAddr + ":" + Integer.toHexString(groupAddr));
        }
    }
}
