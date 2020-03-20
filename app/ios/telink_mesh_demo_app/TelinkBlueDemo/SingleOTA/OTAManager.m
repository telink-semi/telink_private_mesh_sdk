/********************************************************************************************************
 * @file     OTAManager.m
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
//  OTAManager.m
//  TelinkBlueDemo
//
//  Created by Liangjiazhi on 2019/4/26.
//  Copyright © 2019年 Green. All rights reserved.
//

#import "OTAManager.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "DemoDefine.h"

#define kOTAWriteInterval (0.005)

@interface OTAManager()

@property (nonatomic,strong) BTCentralManager *centraManager;

@property (nonatomic,assign) NSTimeInterval connectPeripheralWithUUIDTimeoutInterval;//timeout of connect peripheral
@property (nonatomic,assign) NSTimeInterval writeOTAInterval;//interval of write ota data, default is 6ms
@property (nonatomic,assign) NSTimeInterval readTimeoutInterval;//timeout of read OTACharacteristic(write 8 packet, read one time)

@property (nonatomic,strong) NSNumber *currentAddress;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*allAddresses;
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,copy) singleDeviceCallBack singleSuccessCallBack;
@property (nonatomic,copy) singleDeviceCallBack singleFailCallBack;
@property (nonatomic,copy) singleProgressCallBack singleProgressCallBack;
@property (nonatomic,copy) finishCallBack finishCallBack;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*successAddresses;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*failAddresses;

@property (nonatomic,assign) NSInteger offset;
@property (nonatomic,assign) NSInteger otaIndex;//index of current ota packet
@property (nonatomic,strong) NSData *localData;
@property (nonatomic,assign) NSInteger number; //数据包的包个数；
@property(nonatomic,strong) NSTimer *scanTimer;//第一次进入时候Login－TimeOut
@property (nonatomic,assign) NSInteger scanCount;//扫描次数
@property (nonatomic,assign) BOOL OTAing;
@property (nonatomic,assign) BOOL stopOTAFlag;
@property (nonatomic,assign) BOOL sendFinish;
@property (nonatomic,assign) BOOL isStartSend;
@property (nonatomic,assign) BOOL sendFinishAndDisconnect;

@end

@implementation OTAManager

+ (OTAManager *)share{
    static OTAManager *shareOTA = nil;
    static dispatch_once_t tempOnce=0;
    dispatch_once(&tempOnce, ^{
        shareOTA = [[OTAManager alloc] init];
        [shareOTA initData];
    });
    return shareOTA;
}

- (void)initData{
    _centraManager = BTCentralManager.shareBTCentralManager;
    
    _connectPeripheralWithUUIDTimeoutInterval = 10.0;
    _writeOTAInterval = kOTAWriteInterval;
    _readTimeoutInterval = 5.0;
    
    _currentAddress = @(0);
    _currentIndex = 0;
    
    _OTAing = NO;
    _stopOTAFlag = NO;
    _offset = 0;
    _otaIndex = -1;
    _sendFinish = NO;
    
    _allAddresses = [[NSMutableArray alloc] init];
    _successAddresses = [[NSMutableArray alloc] init];
    _failAddresses = [[NSMutableArray alloc] init];
}


/**
 OTA，can not call repeat when app is OTAing
 
 @param otaData data for OTA
 @param addressNumbers addresses for OTA
 @param singleSuccessAction callback when single model OTA  success
 @param singleFileAction callback when single model OTA  fail
 @param singleProgressAction callback with single model OTA progress
 @param finishAction callback when all models OTA finish
 @return use API success is ture;user API fail is false.
 */
- (BOOL)startOTAWithOtaData:(NSData *)otaData addressNumbers:(NSArray <NSNumber *>*)addressNumbers singleSuccessAction:(singleDeviceCallBack)singleSuccessAction singleFailAction:(singleDeviceCallBack)singleFailAction singleProgressAction:(singleProgressCallBack)singleProgressAction finishAction:(finishCallBack)finishAction{
    if (_OTAing) {
        NSLog(@"OTAing, can't call repeated.");
        return NO;
    }
    if (!otaData || otaData.length == 0) {
        NSLog(@"OTA data is invalid.");
        return NO;
    }
    if (addressNumbers.count == 0) {
        NSLog(@"OTA devices list is invaid.");
        return NO;
    }
    
    _localData = otaData;
    [_allAddresses removeAllObjects];
    [_allAddresses addObjectsFromArray:addressNumbers];
    _currentIndex = 0;
    _singleSuccessCallBack = singleSuccessAction;
    _singleFailCallBack = singleFailAction;
    _singleProgressCallBack = singleProgressAction;
    _finishCallBack = finishAction;
    [_successAddresses removeAllObjects];
    [_failAddresses removeAllObjects];
    [self configBTCentralManagerDelegate];
    [self refreshCurrentModel];
    [self otaNext];
    
    return YES;
}

/// stop OTA
- (void)stopOTA{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    _singleSuccessCallBack = nil;
    _singleFailCallBack = nil;
    _singleProgressCallBack = nil;
    _finishCallBack = nil;
    _stopOTAFlag = YES;
    _OTAing = NO;
    _isStartSend = NO;
    _sendFinishAndDisconnect = NO;
    _centraManager.isAutoLogin = YES;
    _centraManager.delegate = nil;
}

- (void)configBTCentralManagerDelegate{
    _centraManager.isAutoLogin = NO;
    _centraManager.delegate = self;
}

- (void)otaSuccessAction{
    self.OTAing = NO;
    self.sendFinish = NO;
    self.stopOTAFlag = YES;
    self.isStartSend = NO;
    self.sendFinishAndDisconnect = NO;
    if (self.singleSuccessCallBack) {
        self.singleSuccessCallBack(self.currentAddress);
    }
    [self.successAddresses addObject:self.currentAddress];
    self.currentIndex ++;
    [self refreshCurrentModel];
    [self otaNext];
}

- (void)otaFailAction{
    self.OTAing = NO;
    self.sendFinish = NO;
    self.stopOTAFlag = YES;
    self.isStartSend = NO;
    self.sendFinishAndDisconnect = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    if (self.singleFailCallBack) {
        self.singleFailCallBack(self.currentAddress);
    }
    [self.failAddresses addObject:self.currentAddress];
    self.currentIndex ++;
    [self refreshCurrentModel];
    [self otaNext];
}

- (void)refreshCurrentModel{
    if (self.currentIndex < self.allAddresses.count) {
        self.currentAddress = self.allAddresses[self.currentIndex];
    }
}

- (void)otaNext{
    if (self.currentIndex == self.allAddresses.count) {
        //all device are OTA finished.
        if (self.finishCallBack) {
            self.finishCallBack(self.successAddresses,self.failAddresses);
        }
    } else {
        //There are devices that can OTA.
        self.OTAing = YES;
        self.stopOTAFlag = NO;
        self.otaIndex = -1;
        self.offset = 0;
        [self StartConnectIsAutoLogin:NO];
    }
}

- (NSInteger)number {
    NSUInteger len = self.localData.length;
    BOOL ret = (NSInteger)(len %16);
    return !ret?((NSInteger)(len/16)+1):((NSInteger)(len/16)+2);
}

-(void)StartConnectIsAutoLogin:(BOOL)isAutoLogin{
    if (_centraManager.selConnectedItem.blDevInfo.state == CBPeripheralStateConnected  && _centraManager.selConnectedItem.u_DevAdress == self.currentAddress.integerValue) {
        [_centraManager readFeatureOfselConnectedItem];
    } else {
        _scanCount = 0;
        kEndTimer(self.scanTimer)
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(scanAction:) userInfo:@(isAutoLogin) repeats:YES];
        [self.scanTimer fire];
    }
}

-(void)scanAction:(NSTimer *)timer{
    NSLog(@"scanAction:");
    _scanCount++;
    if (_scanCount == 3) {
        _scanCount = 0;
        kEndTimer(self.scanTimer)
        return;
    }
    [_centraManager startScanWithName:kSettingLastName Pwd:kSettingLastPwd AutoLogin:[timer.userInfo boolValue]];
}

- (void)sendPartData{
    if (self.stopOTAFlag) {
        return;
    }
    
    _isStartSend = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(readTimeout) object:nil];
    });
    
    if (self.currentAddress && _centraManager.selConnectedItem && _centraManager.selConnectedItem.blDevInfo.state == CBPeripheralStateConnected) {
        NSInteger lastLength = _localData.length - _offset;
        
        self.otaIndex ++;

        //OTA 结束包特殊处理
        if (lastLength == 0) {
            [_centraManager sendOTAEndDataWithIndex:(int)self.otaIndex];
            self.sendFinish = YES;
            return;
        }
        
        NSInteger writeLength = (lastLength >= 16) ? 16 : lastLength;
        NSData *writeData = [self.localData subdataWithRange:NSMakeRange(self.offset, writeLength)];
        [_centraManager sendOTAData:writeData index:(int)self.otaIndex];
        self.offset += writeLength;
        
        float progress = (self.offset * 100.0) / self.localData.length;
        if (self.singleProgressCallBack) {
            self.singleProgressCallBack(progress);
        }
        
        if ((self.otaIndex + 1) % 8 == 0) {
            [_centraManager readFeatureOfselConnectedItem];
            [self performSelector:@selector(readTimeout) withObject:nil afterDelay:self.readTimeoutInterval];
            return;
        }
        //注意：index=0与index=1之间的时间间隔修改为300ms，让固件有充足的时间进行ota配置。
        NSTimeInterval timeInterval = self.writeOTAInterval;
        if (self.otaIndex == 0) {
            timeInterval = 0.3;
        }
        [self performSelector:@selector(sendPartData) withObject:nil afterDelay:timeInterval];
    }
}

- (void)readTimeout{
    [_centraManager stopScan];
    [self otaFailAction];
}

-(void)loginAction{
    _centraManager.isAutoLogin = NO;
    [_centraManager loginWithPwd:[SysSetting shareSetting].currentUserPassword];
}

#pragma BTCentralManager delegate
-(void)OnDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag{
    NSLog(@"%@",item);
    if (flag == DevChangeFlag_Add) {
        NSLog(@"扫描到设备");
        if (item.u_DevAdress == self.currentAddress.integerValue) {
            [_centraManager connectWithItem:item];
        }
    }
    if (item.u_DevAdress == self.currentAddress.integerValue && item&& flag == DevChangeFlag_Connected) {
        _scanCount = 0;
        kEndTimer(self.scanTimer)
        [self performSelector:@selector(loginAction) withObject:nil afterDelay:1];
    }else if(item.u_DevAdress == self.currentAddress.integerValue && item && flag == DevChangeFlag_Login){
        //为提高手机的兼容性，在点对点OTA阶段，APPlogin成功后，ios与安卓统一延时三秒钟，再发送OTA数据包。
        [_centraManager performSelector:@selector(readFeatureOfselConnectedItem) withObject:nil afterDelay:3.0];
    }else if(item.u_DevAdress == self.currentAddress.integerValue && item && flag == DevChangeFlag_DisConnected){
        if (self.isStartSend && !self.sendFinish && self.otaIndex < self.number && self.otaIndex != 0) {
            [self otaFailAction];
            return;
        }
        if (self.isStartSend && self.sendFinish) {
            [self StartConnectIsAutoLogin:NO];
            self.sendFinishAndDisconnect = YES;
            return;
        }
    }else if(item.u_DevAdress == self.currentAddress.integerValue && item && flag == DevChangeFlag_ConnecteFail){
        if (self.isStartSend && self.sendFinish) {
            [self otaFailAction];
            return;
        }
    }
}

-(void)OnConnectionDevFirmWare:(NSData *)data{
    if (!_OTAing) {
        return;
    }
    
//    NSString *firm = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSString *firmWare = !_isStartSend ? [NSString stringWithFormat:@"升级之前firmWare：%@",firm]:[NSString stringWithFormat:@"升级之后firmWare：%@",firm];
//    NSLog(@"%@", firmWare);
    
    if (!_isStartSend) {
        if (!_sendFinish) {
            //发送第一个OTA包
            [self sendPartData];
        }
    }else{
        if (!_sendFinish) {
            [self sendPartData];
        }else{
            if (self.sendFinishAndDisconnect) {
                _sendFinish = YES;
                [self otaSuccessAction];
            }
        }
    }
}

@end
