/********************************************************************************************************
 * @file     BTCentralManager+MeshAdd.m
 *
 * @brief    for TLSR chips
 *
 * @author     telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *
 *             The information contained herein is confidential and proprietary property of Telink
 *              Semiconductor (Shanghai) Co., Ltd. and is available under the terms
 *             of Commercial License Agreement between Telink Semiconductor (Shanghai)
 *             Co., Ltd. and the licensee in separate contract or the terms described here-in.
 *           This heading MUST NOT be removed from this file.
 *
 *              Licensees are granted free, non-transferable use of the information in this
 *             file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided.
 *
 *******************************************************************************************************/
//
//  BTCentralManager+MeshAdd.m
//  TelinkMeshLib
//
//  Created by 梁家誌 on 2019/1/5.
//  Copyright © 2019 Telink. All rights reserved.
//

#import "BTCentralManager+MeshAdd.h"

@implementation BTCentralManager (MeshAdd)

-(void)log:(uint8_t *)bytes Len:(int)len Str:(NSString *)str {
    NSMutableString *tempMStr=[[NSMutableString alloc] init];
    for (int i=0;i<len;i++)
        [tempMStr appendFormat:@"%0x ",bytes[i]];
    NSLog(@"%@ == %@",str,tempMStr);
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
    Byte byte[12] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc9, 0x11, 0x02, 0x08, 0x2f};
    [self log:byte Len:14 Str:@"allDefault"];
    [self sendCommand:byte Len:12];
}

///清除临时设置
- (void)allResett {
    Byte byte[12] = {0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0xc9, 0x11, 0x02, 0x08, 0x00};
    [self log:byte Len:14 Str:@"allResett"];
    [self sendCommand:byte Len:12];
}

@end
