/********************************************************************************************************
 * @file     SharaDevice.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/22
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

#import "SharaDevice.h"

@implementation SharaDevice
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _version = [aDecoder decodeObjectForKey:@"version"];
        _mac = [aDecoder decodeObjectForKey:@"mac"];
        _address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.mac forKey:@"mac"];
    [aCoder encodeObject:self.address forKey:@"address"];
}

@end
