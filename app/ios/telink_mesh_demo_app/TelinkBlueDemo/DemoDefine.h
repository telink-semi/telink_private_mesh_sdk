/********************************************************************************************************
 * @file     DemoDefine.h 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/11
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

#ifndef DemoDefine_h
#define DemoDefine_h
#import "AppDelegate.h"
#import "SysSetting.h"
#import "BTDevItem.h"
#import "OTATipShowVC.h"
#import "UIWindow+ARShow.h"
#import "ARShowTips.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTCentralManager+MeshAdd.h"

#define kEndTimer(timer) \
if (timer) { \
[timer invalidate]; \
timer = nil; \
}

/*meshOTA状态存储的字典内容为：{@"meshState":@(2) ,@"address":@(1) ,@"deviceType": @(4)}*/
#define kSaveMeshOTADictKey @"kSaveMeshOTADictKey"

//OTA压包修改参数
#define kOTAPartSize (16*8)

#define kPrintPerDataSend (6)

#define kBinFileName (@"light_8267_V1H_for_ota_test")

#define kMScreenW ([UIScreen mainScreen].bounds.size.width)
#define kMScreenH ([UIScreen mainScreen].bounds.size.height)

#define kDocumentFilePath(name) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name])
//#define kCanOpenBluetooth ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]])
//#define kOpenBluetooth ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Bluetooth"]])
#define kCentralManager ([BTCentralManager shareBTCentralManager])
#define kSettingLastName ([SysSetting shareSetting].currentUserName)
#define kSettingLastPwd ([SysSetting shareSetting].currentUserPassword)
#define kSettingLatestName ([SysSetting shareSetting].oldUserName)
#define kSettingLatestPwd ([SysSetting shareSetting].oldUserPassword)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


//系统版本
#define IOS_VERSION_10 (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_x_Max)?(YES):(NO)

//获取导航栏+状态栏的高度
#define kGetRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif /* DemoDefine_h */
