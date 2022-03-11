/********************************************************************************************************
 * @file     BTDevItem.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/11/14
 *
 * @par     Copyright (c) [2017], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#import "BTDevItem.h"

@implementation BTDevItem
@synthesize devIdentifier;
@synthesize name;
@synthesize blDevInfo;
@synthesize u_Name;
@synthesize u_Vid;
@synthesize u_Pid;
@synthesize u_Mac;
@synthesize rssi;
@synthesize isConnected;
@synthesize isBreakOff;
@synthesize isSeted;
@synthesize u_meshUuid;
@synthesize u_DevAdress;
@synthesize u_Status;
@synthesize isSetedSuff;
@synthesize productID;

- (instancetype)initWithDevice:(BTDevItem *)item {
    if (self=[super init]) {
        devIdentifier = item.devIdentifier;
        name = item.name;
        u_DevAdress = item.u_DevAdress;
        blDevInfo = item.blDevInfo;
        u_Name = item.u_Name;
        u_Vid = item.u_Vid;
        u_Mac = item.u_Mac;
        rssi = item.rssi;
        isConnected = item.isConnected;
    }
    return self;
}

-(id)init{
    self=[super init];
    [self initData];
    return self;
}

-(void)initData{
    self.isBreakOff=NO;
    self.isConnected=NO;
    self.isSeted=NO;
    self.isSetedSuff=NO;
}

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[BTDevItem class]]) {
        return u_Mac == ((BTDevItem *)object).u_Mac;
    } else {
        return NO;
    }
}

- (NSString *)uuidString {
    return self.blDevInfo.identifier.UUIDString;
}

///新增，返回Mac字符串
- (NSString *)getMacAddressFromU_Mac{
    if (u_Mac != 0) {
        NSString *tem = [NSString stringWithFormat:@"%08X",u_Mac];
        NSString *mac = [[[[kMacComplement stringByAppendingString:[tem substringWithRange:NSMakeRange(6, 2)]] stringByAppendingString:[tem substringWithRange:NSMakeRange(4, 2)]] stringByAppendingString:[tem substringWithRange:NSMakeRange(2, 2)]] stringByAppendingString:[tem substringWithRange:NSMakeRange(0, 2)]];
        return mac;
    } else {
        return nil;
    }
}

@end
