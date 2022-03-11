/********************************************************************************************************
 * @file     MeshAddVC.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/2/28
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

#import "MeshAddVC.h"
#import "AppDelegate.h"
#import "DemoDefine.h"
#import "SysSetting.h"
#import "ARMainVC.h"
#import "DeviceAddCell.h"
#import "UIAlertView+Extension.h"
#import "MeshOTAManager.h"

//mesh模式加灯超时时间
#define kMeshAddTimeOut 15

@interface MeshAddVC () <BTCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, strong) NSString *currentSetMac;
@property (nonatomic, assign) NSInteger currentDeviceType;
@property (nonatomic, assign) int addressInt;
@property (nonatomic, strong) NSMutableArray *macs;

@property (nonatomic, assign) uint32_t addresse;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray <NSDictionary *>* savelist;
@property (nonatomic, strong) NSTimer *configueTimer;
@property (nonatomic, strong) NSTimer *scanTimer;
@property (nonatomic, assign) BOOL isAllDefault;

@property (nonatomic, assign) int addTimeOut;//加灯超时时间

@property (nonatomic, strong) NSString *nName;
@property (nonatomic, strong) NSString *nPassword;

@property (nonatomic, assign) int retrySetAddressCount;//设置短地址重试次数

@property (nonatomic, assign) BOOL isCheckEnd;

@end


/**
 mesh添加模式流程可以参考文档Telink_Mesh_Scan_Flow_pdf.pdf
 */
@implementation MeshAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[MeshOTAManager share] setHandleMacNotify:YES];
    [self stopAction];
    ARShowTips.shareTips.hidden();
    [self.macs removeAllObjects];
    NSArray *ar = self.parentViewController.childViewControllers;
    for (int i=0; i<ar.count; i++) {
        UIViewController *v = ar[i];
        if ([v isKindOfClass:[ARMainVC class]]) {
            ARMainVC *vc = (ARMainVC *)v;
            vc.isNeedRescan = YES;
            [vc changeMeshInfoReload];
            [vc.filterlist removeAllObjects];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isCheckEnd = NO;
    [[MeshOTAManager share] setHandleMacNotify:NO];
    BTCentralManager.shareBTCentralManager.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    if ([BTCentralManager shareBTCentralManager].isLogin) {
        ARShowTips.shareTips.showTip(@"正在获取列表");
        if ([BTCentralManager.shareBTCentralManager.currentName isEqualToString:SysSetting.shareSetting.currentUserName]&&
            [BTCentralManager.shareBTCentralManager.currentPwd isEqualToString:SysSetting.shareSetting.currentUserPassword]) {
            [BTCentralManager.shareBTCentralManager allDefault];
            [BTCentralManager.shareBTCentralManager performSelector:@selector(checkMeshScanSupportState) withObject:nil afterDelay:0.1];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self performSelector:@selector(startAndRetryGetAddressMac) withObject:nil afterDelay:1];
//            });
            self.isAllDefault = YES;
        }else{
            [[BTCentralManager shareBTCentralManager] getAddressMac];
        }
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:2.0*4-0.1 target:self selector:@selector(scantimout) userInfo:nil repeats:false];
    }else{
        ARShowTips.shareTips.showTip(@"正在扫描设备");
        [BTCentralManager shareBTCentralManager].scanWithOut_Of_Mesh = YES;
        [[BTCentralManager shareBTCentralManager] startScanWithName:@"telink_mesh1" Pwd:@"123" AutoLogin:YES];
        self.scanTimer = [NSTimer scheduledTimerWithTimeInterval:kMeshAddTimeOut target:self selector:@selector(scantimout) userInfo:nil repeats:false];
    }
}

- (void)configData{
    _nName = [SysSetting shareSetting].currentUserName;
    _nPassword = [SysSetting shareSetting].currentUserPassword;
    
    if ([[SysSetting shareSetting] currentLocalDevices]&&[[SysSetting shareSetting] currentLocalDevices].count > 0) {
        NSArray *arr = [[[SysSetting shareSetting] currentLocalDevices] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            int b1 = [obj1 intValue];
            int b2 = [obj2 intValue];
            return b1 > b2;
        }];
        self.addressInt = [arr.lastObject intValue] + 1;
    }else{
        self.addressInt = 1;
    }
    
    self.addTimeOut = 0;
    self.retrySetAddressCount = 0;
}

- (void)stopAction{
    kEndTimer(self.scanTimer);
    kEndTimer(self.configueTimer)
}

- (void)scantimout {
    kEndTimer(self.scanTimer);
    kEndTimer(self.configueTimer);
    ARShowTips.shareTips.hidden();
    __weak typeof(self) weakSelf = self;
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } title:@"Hint" message:@"mesh add timeout" cancelButtonName:@"Sure" otherButtonTitles:nil, nil];
}

#pragma mark - BTCentralManagerDelegate
/*
 f4 d4 81 13 0 e7 b3 e1 11 2 13 0 13 3 62 59 ff ff 0 0
 d6 ee 81 46 0 70 af e1 11 2 46 0 46 e1 53 13 ff ff 0 0
 13 53 47 32 0 ab cc e1 11 2 32 0 41 46 b3 dd ff ff 5 0
 */
- (void)OnDevNotify:(id)sender Byte:(uint8_t *)byte {
    // Mark: 回来的最后两位为mac地址的最后两位，如果客户6位mac地址的最后两位不为0xff，此处应作调整
    //获取mac回包与修改短地址回包都是0xe1
    if (byte[7] == 0xe1 && byte[16] == 0xff && byte[17]==0xff) {
        kEndTimer(self.scanTimer);
        NSMutableString *macAddress = [[NSMutableString alloc] init];
        for (int i=5; i>=0; i--) {
            Byte mac = 0;
            memcpy(&mac, byte+12+i, 1);
            [macAddress appendString:[NSString stringWithFormat:@"%02X", mac]];
            if (i) [macAddress appendString:@":"];
        }
        if (!self.isAdd && ![self.macs containsObject:macAddress]) {
            kEndTimer(self.configueTimer)
            self.addresse = byte[10];
            self.currentSetMac = macAddress;
            self.currentDeviceType = byte[18];
            [self beginSingle];
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRetrySetAddress) object:nil];
                [self performSelector:@selector(startRetrySetAddress) withObject:nil afterDelay:2.0];
            });
        }else{
            if ([macAddress isEqualToString:self.currentSetMac] && ![self.macs containsObject:self.currentSetMac]) {
                NSString *m = self.currentSetMac;
                NSDictionary *dic = @{
                                      Address : @(self.addressInt),
                                      Mac : m,
                                      Productuuid : @(self.currentDeviceType),
                                      Version : @""
                                      };
                [self.savelist addObject:dic];
                [self.macs addObject:self.currentSetMac];
                NSLog(@"修改短地址0x%x成功。",self.addressInt);
                self.addressInt++;

                [self.tableview reloadData];
                self.isAdd = false;
                ARShowTips.shareTips.showTip(@"正在获取列表");
                [self endRetrySetAddress];
                [self startAndRetryGetAddressMac];
            }
        }
    }
    else if (byte[7] == 0xca && byte[10] == 0x00){
        //mesh add 完成，设备返回数据
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addDevicesTimeout) object:nil];
        });
        [self allResett];
        __weak typeof(self) weakSelf = self;
        [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } title:@"Hint" message:@"收到0xCA，notify配置mesh info完成" cancelButtonName:@"Sure" otherButtonTitles:nil, nil];

    }
    else if (byte[7] == 0xc8) {
        UInt8 address = byte[10];
        NSLog(@"c8:byte[10]=0x%x",address);
        if (!_isCheckEnd) {
            if ([self checkLocationHasAddress:address]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(noSupportDevice) object:nil];
                    [self performSelector:@selector(noSupportDevice) withObject:nil afterDelay:2.0];
                });
            } else {
                //有设备支持mesh组网
                self.isCheckEnd = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(noSupportDevice) object:nil];
                    [self performSelector:@selector(startAndRetryGetAddressMac) withObject:nil afterDelay:0.5];
                });
            }
        }
    }
}

- (void)noSupportDevice {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scantimout) object:nil];
    });
    kEndTimer(self.scanTimer);
    ARShowTips.shareTips.hidden();
    NSLog(@"allResett");
    [self allResett];
    __weak typeof(self) weakSelf = self;
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } title:@"Hint" message:@"没有支持mesh组网的设备，添加结束" cancelButtonName:@"Sure" otherButtonTitles:nil, nil];
}

- (BOOL)checkLocationHasAddress:(UInt8)address {
    BOOL tem = NO;
    for (DeviceModel *model in self.locationDevices) {
        if (model.u_DevAdress >> 8 == address) {
            tem = YES;
            break;
        }
    }
    return tem;
}

- (void)OnDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag {
    if (flag == DevChangeFlag_Login) {
        ARShowTips.shareTips.showTip(@"正在获取列表");
        [[BTCentralManager shareBTCentralManager] checkMeshScanSupportState];
//        [[BTCentralManager shareBTCentralManager] getAddressMac];
    }
}

- (void)startRetrySetAddress{
    NSLog(@"startRetrySetAddress");
    kEndTimer(self.configueTimer)
    self.configueTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(beginSingle) userInfo:nil repeats:YES];
    [self.configueTimer fire];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRetrySetAddress) object:nil];
        [self performSelector:@selector(endRetrySetAddress) withObject:nil afterDelay:2.0*3-0.1];
    });
}

- (void)endRetrySetAddress{
    NSLog(@"endRetrySetAddress");
    self.retrySetAddressCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endRetrySetAddress) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startRetrySetAddress) object:nil];
    });
    kEndTimer(self.configueTimer)
}

- (void)startAndRetryGetAddressMac{
    NSLog(@"startAndRetryGetAddressMac");
    kEndTimer(self.configueTimer)
    self.configueTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(onceConfigue) userInfo:nil repeats:YES];
    [self.configueTimer fire];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(meshAddDevicesFinishAction) object:nil];
        [self performSelector:@selector(meshAddDevicesFinishAction) withObject:nil afterDelay:2.0*4-0.1];
    });
}

- (void)addDevicesTimeout{
    [self allResett];
    __weak typeof(self) weakSelf = self;
    [UIAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } title:@"Hint" message:@"60s后没有收到0xCA，添加完成" cancelButtonName:@"Sure" otherButtonTitles:nil, nil];
}

- (void)allResett{
    if (self.isAllDefault) {
        self.isAllDefault = NO;
        NSLog(@"allResett");
        [kCentralManager allResett];
    }
    ARShowTips.shareTips.delayHidden(1.0);
}

- (void)meshAddDevicesFinishAction{
    NSLog(@"meshAddDevicesFinishAction");
    kEndTimer(self.configueTimer);
    ARShowTips.shareTips.showTip(@"正在获取firmware version");
    //已经存在设备类型、mac地址，获取设备版本号信息，回包在MeshOTAManager.m处自动解析保存本地。
    [[BTCentralManager shareBTCentralManager] readFirmwareVersion];
    [self performSelector:@selector(changeMeshInfo) withObject:nil afterDelay:1.0];
}

- (void)changeMeshInfo {
    [[SysSetting shareSetting] addDevice:YES Name:_nName pwd:_nPassword devices:self.savelist];
    ARShowTips.shareTips.showTip(@"正在修改mesh info");
    [[BTCentralManager shareBTCentralManager] updateMeshInfo:_nName password:_nPassword];

    //在meshAdd添加单个设备时，没有返回0xca，特殊处理，后期可能去掉
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(addDevicesTimeout) withObject:nil afterDelay:60];
    });
}

- (void)onceConfigue {
    [[BTCentralManager shareBTCentralManager] getAddressMac];
}

- (void)beginSingle{
    NSLog(@"beginSingle");
    self.isAdd = YES;
    self.addTimeOut = 0;
    NSString *macstring = [[[self.currentSetMac componentsSeparatedByString:@":"] componentsJoinedByString:@""] substringFromIndex:4];
    uint32_t v = (uint32_t)strtoul([macstring UTF8String], 0, 16);
    NSString *tip = [NSString stringWithFormat:@"%@正在修改地址0x%x->0x%x",macstring,self.addresse,self.addressInt];
    ARShowTips.shareTips.showTip(tip);
    uint8_t address = self.retrySetAddressCount % 2 == 0 ? self.addresse : self.addressInt;
    [BTCentralManager.shareBTCentralManager changeDeviceAddress:address new:self.addressInt mac:v];
    self.retrySetAddressCount ++;
    if (self.retrySetAddressCount >= 4) {
        NSLog(@"self.retrySetAddressCount >= 4");
        [self endRetrySetAddress];
        [self startAndRetryGetAddressMac];
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.macs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceAddCell" forIndexPath:indexPath];
    NSNumber *mac = self.macs[indexPath.row];
    cell.info.text = [NSString stringWithFormat:@"mac: %@",mac];
    [cell.info sizeToFit];
    return cell;
}

#pragma mark - lazy
- (NSMutableArray <NSDictionary *>*)savelist {
    if (!_savelist) {
        _savelist = [NSMutableArray<NSDictionary *> new];
    }
    return _savelist;
}

- (NSMutableArray *)macs {
    if (!_macs) {
        _macs = [NSMutableArray new];
    }
    return _macs;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end

