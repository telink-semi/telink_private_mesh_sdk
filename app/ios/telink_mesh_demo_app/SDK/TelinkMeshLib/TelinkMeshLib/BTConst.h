/********************************************************************************************************
 * @file     BTConst.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/11/14
 *
 * @par     Copyright (c) [2014], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#ifndef TelinkBlue_BTConst_h
#define TelinkBlue_BTConst_h

#define BTDevInfo_Name @"Telink tLight"
#define BTDevInfo_UserNameDef @"telink_mesh1"
#define BTDevInfo_UserPasswordDef @"123"
#define BTDevInfo_UID  0x1102

#define BTDevInfo_ServiceUUID @"00010203-0405-0607-0809-0A0B0C0D1910"
#define BTDevInfo_FeatureUUID_Notify @"00010203-0405-0607-0809-0A0B0C0D1911"
#define BTDevInfo_FeatureUUID_Command @"00010203-0405-0607-0809-0A0B0C0D1912"
#define BTDevInfo_FeatureUUID_Pair @"00010203-0405-0607-0809-0A0B0C0D1914"
#define BTDevInfo_FeatureUUID_OTA  @"00010203-0405-0607-0809-0A0B0C0D1913"

#define Service_Device_Information @"0000180a-0000-1000-8000-00805f9b34fb"

#define Characteristic_Firmware @"00002a26-0000-1000-8000-00805f9b34fb"
//#define Characteristic_Manufacturer @"00002a29-0000-1000-8000-00805f9b34fb"
//#define Characteristic_Model @"00002a24-0000-1000-8000-00805f9b34fb"
//#define Characteristic_Hardware @"00002a27-0000-1000-8000-00805f9b34fb"

#define CheckStr(A) (!A || A.length<1)

#define kEndTimer(timer) \
if (timer) { \
[timer invalidate]; \
timer = nil; \
}
//!<命令延时参数
//#define kDuration (500)
#endif
