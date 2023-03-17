/********************************************************************************************************
 * @file     ARTelinkBlueDemoTests.m 
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
//  ARTelinkBlueDemoTests.m
//  ARTelinkBlueDemoTests
//
//  Created by Arvin on 2018/2/6.
//  Copyright © 2018年 Green. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "BTCentralManager.h"

@interface ARTelinkBlueDemoTests : XCTestCase

@end
static Byte b16_1[16] = {0x31,0x08,0x32,0x09,0x32,0x0a,0x91,0x02,0x02,0xca,0x08,0x50,0x04,0xb1,0xfa,0x87};
static Byte b16_2[2] = {};
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
    NSData *d = [NSData dataWithBytes:b16_1 length:16];
    [[BTCentralManager shareBTCentralManager] sendPack:d];
    
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
