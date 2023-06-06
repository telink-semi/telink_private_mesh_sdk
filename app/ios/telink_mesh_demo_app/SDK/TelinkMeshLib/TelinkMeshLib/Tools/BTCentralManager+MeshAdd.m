/********************************************************************************************************
 * @file     BTCentralManager+MeshAdd.m
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2019/1/5
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

#import "BTCentralManager+MeshAdd.h"

#define kDEFAULT_TIMEOUT_SEC    (100)

@implementation BTCentralManager (MeshAdd)

-(void)log:(uint8_t *)bytes Len:(int)len Str:(NSString *)str {
    NSMutableString *tempMStr=[[NSMutableString alloc] init];
    for (int i=0;i<len;i++)
        [tempMStr appendFormat:@"%0x ",bytes[i]];
    NSLog(@"%@ == %@",str,tempMStr);
}


/// check is mesh ota supported by devices in mesh network
- (void)checkMeshScanSupportState {
    Byte byte[12] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc7, 0x11, 0x02, 0x10, 0x0a};
    [self log:byte Len:12 Str:@"checkMeshScanSupportState"];
    NSLog(@"checkMeshScanSupportState");
    [self sendCommand:byte Len:12];
}

/*
 ALL Default  : 12 11 11 00 00 ff ff c9 11 02 08 ff 00
 DeviceAdrMac : 0c 67 47 00 00 22  00 e0 11 02 30 00 01 10 16 00 00 67 ff ff
 GetDeviceAdrMac : 0c 67 47 00 00 ff  ff e0 11 02 ff ff 01 10
 */
///获取当前mesh网络的所有设备mac
- (void)getAddressMac{
    Byte byte[14] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xe0, 0x11, 0x02, 0xff, 0xff, 0x01, 0x10};
    [self log:byte Len:14 Str:@"getAddressMac"];
    NSLog(@"getAddressMac");
    [self sendCommand:byte Len:14];
}

///修改设备的短地址
- (void)changeDeviceAddress:(uint8_t)address new:(uint8_t)newAddress mac:(uint32_t)mac {
    Byte byte[20] = {0x00, 0x00, 0x00, 0x00, 0x00, address, 0x00, 0xe0, 0x11, 0x02, newAddress, 0x00, 0x01, 0x10, 0,0,0,0,0xff,0xff};
    memcpy(byte + 14, &mac, 4);
    [self log:byte Len:20 Str:@"changeAddressWithMac"];
    [self sendCommand:byte Len:20];
}

///临时设置当前网络到默认网络
- (void)allDefault {
    Byte byte[13] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc9, 0x11, 0x02, 0x08, 0x2f, 0x00};
    byte[11] = kDEFAULT_TIMEOUT_SEC & 0xFF;
    [self log:byte Len:13 Str:@"allDefault"];
    [self sendCommand:byte Len:13];
}

///清除临时设置
- (void)allResett {
    Byte byte[13] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc9, 0x11, 0x02, 0x08, 0x00, 0x00};
    [self log:byte Len:13 Str:@"allResett"];
    [self sendCommand:byte Len:13];
}

@end
