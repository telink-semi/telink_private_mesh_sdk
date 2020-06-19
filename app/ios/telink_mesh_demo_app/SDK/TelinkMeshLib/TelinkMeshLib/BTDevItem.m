/********************************************************************************************************
 * @file     BTDevItem.m 
 *
 * @brief    for TLSR chips
 *
 * @author	 telink
 * @date     Sep. 30, 2010
 *
 * @par      Copyright (c) 2010, Telink Semiconductor (Shanghai) Co., Ltd.
 *           All rights reserved.
 *           
 *			 The information contained herein is confidential and proprietary property of Telink 
 * 		     Semiconductor (Shanghai) Co., Ltd. and is available under the terms 
 *			 of Commercial License Agreement between Telink Semiconductor (Shanghai) 
 *			 Co., Ltd. and the licensee in separate contract or the terms described here-in. 
 *           This heading MUST NOT be removed from this file.
 *
 * 			 Licensees are granted free, non-transferable use of the information in this 
 *			 file under Mutual Non-Disclosure Agreement. NO WARRENTY of ANY KIND is provided. 
 *           
 *******************************************************************************************************/
//
//  BTDevItem.m
//  TelinkBlue
//
//  Created by Green on 11/14/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

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
