/********************************************************************************************************
 * @file     ARTelinkBlueDemoTests.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2016/7/27
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

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
//#import "BTCentralManager.h"

@interface ARTelinkBlueDemoTests : XCTestCase

@end
//static Byte b16_1[16] = {0x31,0x08,0x32,0x09,0x32,0x0a,0x91,0x02,0x02,0xca,0x08,0x50,0x04,0xb1,0xfa,0x87};
//static Byte b16_2[2] = {};
@implementation ARTelinkBlueDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testSendOTAData {
    //    <0200 3108 3209320a 910202ca 085004b1 fa87 8c26>
//    NSData *d = [NSData dataWithBytes:b16_1 length:16];
//    [[BTCentralManager shareBTCentralManager] sendPack:d];
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
