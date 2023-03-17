/********************************************************************************************************
 * @file     ARMainVC.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/10
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

#import "ARMainVC.h"
#import "ARTips.h"
#import "MeshInfoViewController.h"
#import "AppDelegate.h"
#import "SysSetting.h"
#import "AddDeviceViewController.h"
#import "MyCollectionCell.h"
#import "DemoDefine.h"
#import "SingleSettingViewController.h"
#import "MeshAddVC.h"
#import "MeshOTAVC.h"
#import "MeshOTAManager.h"
#import "UIAlertView+Extension.h"
#import "TranslateTool.h"

#define kMaxScanCount (3)

@interface ARMainVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BTCentralManagerDelegate> {
    NSInteger Rescan_Count;
}
@property (nonatomic, strong) NSMutableArray *hasBeenOTADevicesAddress;
@property (nonatomic, strong) NSMutableArray *hasBeenOTAFailDevicesAddress;
@property (nonatomic, strong) NSData *otaData;
@property (nonatomic, assign) NSInteger number; //数据包的包个数；
@property (nonatomic, assign) NSInteger location;  //当前所发送的包的Index；
@property (nonatomic, strong) NSTimer *otaTimer;
@property (nonatomic, strong) NSTimer *scanDeviceTimer;
@property (nonatomic, assign) BOOL isStartOTA;
@property (nonatomic, assign) BOOL isSingleSendFinsh;
@property (nonatomic, assign) BOOL isHasBeganSend;
@property (nonatomic, assign) BOOL isSingleFinish;
@property (nonatomic, assign) BOOL isAllFinish;
@property (nonatomic, assign) BOOL isPartDataSendFinsh;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) OTATipShowVC *otaShowTipVC;
@property (nonatomic, assign) BOOL isPushToLogVC;//从logVC返回时，不需要获取设备状态。

@end

@implementation ARMainVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configUI];
    Rescan_Count = 0;
    [kDelegate logBtn];
    _isPushToLogVC = NO;
    
    //根据保存本地的meshOTAState调用接口
    [self configMeshOTAStateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [BTCentralManager shareBTCentralManager].delegate = self;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40 - self.tabBarController.tabBar.frame.size.height;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    if (kCentralManager.isLogin) {
        if (!self.isNeedRescan) {
            if (_isPushToLogVC) {
                return;
            }
            [kCentralManager setNotifyOpenPro];
        }
    }else{
        self.isNeedRescan = YES;
    }
    
    if (self.isNeedRescan && ![[MeshOTAManager share] hasMeshStateData]) {
//        self.collectionSource = nil;
//        [self.collectionView reloadData];
        [self startScan];
        self.isNeedRescan = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _isPushToLogVC = delegate.logBtn.selected;
}

- (void)configUI{
    self.title = @"Single";
    self.isNeedRescan = YES;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(10, 10, 50, 28);
    [leftBtn setTitle:@"Setting" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(settingMesh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice)];
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn2.frame = CGRectMake(10, 10, 70, 28);
    [rightBtn2 setTitle:@"Mesh Add" forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(AddDeviceThroughMesh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn2];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    //collectionView添加长按手势，进入设备详情
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.collectionView addGestureRecognizer:longPress];
    
    //添加双手指长按手势，用于退出OTA
    UILongPressGestureRecognizer *quitOtaGesture = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(removeOTAView:)];
    quitOtaGesture.numberOfTouchesRequired = 2;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addGestureRecognizer:quitOtaGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeDevice:) name:RemoveDeviceKey object:nil];
}

- (void)configMeshOTAStateData{
    if ([MeshOTAManager share].hasMeshStateData) {
        //存在本地数据
        NSDictionary *dict = [[MeshOTAManager share] getSaveMeshStateData];
        //先搜索设备3秒，判断是否存在直连设备的地址，没走再走随机连接登录
        [BTCentralManager shareBTCentralManager].delegate = self;
        [kCentralManager startScanWithName:kSettingLastName Pwd:kSettingLastPwd AutoLogin:NO];
        [self performSelector:@selector(connectLastDeviceAddress:) withObject:dict[@"address"] afterDelay:3.0];
        
    } else {
        //不存在
    }
}

- (void)connectLastDeviceAddress:(NSNumber *)address{
    BOOL hasConnect = NO;
    for (BTDevItem *item in [BTCentralManager shareBTCentralManager].devArrs) {
        if (item.u_DevAdress >> 8 == address.integerValue) {
            [[BTCentralManager shareBTCentralManager] connectWithItem:item];
            hasConnect = YES;
            break;
        }
    }
    if (!hasConnect) {
        kCentralManager.scanWithOut_Of_Mesh = NO;
        [kCentralManager startScanWithName:kSettingLastName Pwd:kSettingLastPwd AutoLogin:YES];
    }
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    DeviceModel *model = self.collectionSource[indexPath.item];
    [cell updateState:model];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(90, 115);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //得到灯现在的状态
    DeviceModel *pathModel = self.collectionSource[indexPath.row];
    switch (pathModel.stata) {
        case LightStataTypeOutline: return; break;
        case LightStataTypeOff:
            [kCentralManager turnOnCertainLightWithAddress:pathModel.u_DevAdress]; break;
        case LightStataTypeOn:
            [kCentralManager turnOffCertainLightWithAddress:pathModel.u_DevAdress]; break;
        default: break;
    }
}

#pragma mark- Click Events
#pragma mark 点击全开全关
- (IBAction)allOn:(UISwitch *)sender {
    if (sender.on) {
        [[BTCentralManager shareBTCentralManager] turnOnAllLight];
    }else{
        [[BTCentralManager shareBTCentralManager] turnOffAllLight];
    }
}

#pragma mark 点击进入setting界面
- (void)settingMesh {
    __weak typeof(self) weakSelf = self;
    MeshInfoViewController *tempCon= [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MeshInfoViewController"];
    [tempCon setUpdateMeshInfo:^(NSString *name, NSString *pwd) {
        if ([BTCentralManager shareBTCentralManager].isLogin && [BTCentralManager.shareBTCentralManager.currentName isEqualToString:SysSetting.shareSetting.currentUserName]&&
            [BTCentralManager.shareBTCentralManager.currentPwd isEqualToString:SysSetting.shareSetting.currentUserPassword]) {
                [BTCentralManager.shareBTCentralManager setNotifyOpenPro];
        }else{
            [weakSelf changeMeshInfoReload];
            kCentralManager.scanWithOut_Of_Mesh = NO;
            [[BTCentralManager shareBTCentralManager] startScanWithName:SysSetting.shareSetting.currentUserName Pwd:SysSetting.shareSetting.currentUserPassword AutoLogin:YES];
        }
    }];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.meshInfoVC = tempCon;
    [self.navigationController pushViewController:tempCon animated:YES];
}

- (void)changeMeshInfoReload{
    _collectionSource = nil;
    [self collectionSource];
    [self.collectionView reloadData];
}

#pragma mark 点击通过普通模式加灯
- (void)addDevice {
    if ([self localNameNilOrNot]) {
        [self popMessage];
        return;
    }
    self.collectionSource = nil;
//    [self collectionSource];
    self.tabBarController.tabBar.hidden = YES;
    AddDeviceViewController *tempCon=[[AddDeviceViewController alloc] init];
    [self.navigationController pushViewController:tempCon animated:YES];
}

- (BOOL)localNameNilOrNot {
    BOOL eq = [kSettingLastName isEqualToString:kSettingLatestName]&&[kSettingLastPwd isEqualToString:kSettingLatestPwd];
    BOOL nilor = !kSettingLatestName.length || !kSettingLatestPwd.length;
    return eq || nilor;
}

- (void)popMessage {
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:ARTip message:ARChangeMeshInfo delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timerFireMethod:) userInfo:promptAlert repeats:YES];
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer {
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

#pragma mark 点击通过mesh模式添加设备
- (void)AddDeviceThroughMesh {
    BOOL n = [SysSetting shareSetting].currentUserName.length && SysSetting.shareSetting.currentUserPassword.length && ![[SysSetting shareSetting].currentUserName isEqualToString:@"telink_mesh1"] && [[SysSetting shareSetting].oldUserName isEqualToString:@"telink_mesh1"];
    BOOL o = ![[SysSetting shareSetting].currentUserName isEqualToString:@"telink_mesh1"]&&[SysSetting shareSetting].currentUserPassword.length;
    
    if (n || o) {
//        if (o) {
//            [[SysSetting shareSetting] saveMeshInfoWithName:[SysSetting shareSetting].oUserName password:[SysSetting shareSetting].oUserPassword isOld:NO];
//        }
        self.collectionSource = nil;
        [self collectionSource];
        MeshAddVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MeshAddVC"];
        [self.navigationController pushViewController:vc animated:YES];
        vc.locationDevices = self.collectionSource;
        return;
    }
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ARTip message:ARNewMeshName preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeURL;
        textField.placeholder = @"mesh name";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"mesh password";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        kSettingLatestName = alert.textFields.firstObject.text;
//        kSettingLatestPwd = alert.textFields.lastObject.text;
        BOOL eq = ![alert.textFields.firstObject.text isEqualToString:@"telink_mesh1"]&&[alert.textFields.firstObject.text length]&&[alert.textFields.lastObject.text length]&&![alert.textFields.firstObject.text containsString:@" "]&&[alert.textFields.lastObject.text containsString:@" "];
        if (eq) {
            [weakSelf popMessage];
            return ;
        }
        [[SysSetting shareSetting] saveMeshInfoWithName:alert.textFields.firstObject.text password:alert.textFields.lastObject.text isCurrent:YES];
        [[SysSetting shareSetting] addMesh:YES Name:alert.textFields.firstObject.text pwd:alert.textFields.lastObject.text];

        weakSelf.collectionSource = nil;
        [weakSelf collectionSource];
        MeshAddVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"MeshAddVC"];
        vc.locationDevices = weakSelf.collectionSource;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark MeshOTA入口
- (IBAction)startMeshOTA{
    MeshOTAVC *nextVC = [[MeshOTAVC alloc] init];
    nextVC.collectionSource = self.collectionSource;
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark 普通OTA入口(OTA当前直连灯)
- (void)startOTA {
    [self addchild];
    self.isStartOTA = YES;
    if (kCentralManager.isLogin) {
        self.location = 0;
        self.otaShowTipVC.otaItem = [[BTDevItem alloc] initWithDevice:kCentralManager.selConnectedItem];
        kCentralManager.isAutoLogin = NO;
        [self.otaShowTipVC.otaDevices addObject:kCentralManager.selConnectedItem];
        NSString *tip = [NSString stringWithFormat:@"begain ota device with address: %x", self.otaShowTipVC.otaItem.u_DevAdress];
        [self.otaShowTipVC showTip:tip];
        [self sendPcaket];
    }else{
        [self scanDeviceForOTA];
    }
}

- (void)addchild {
    self.otaShowTipVC.view.frame = CGRectMake(0, 0, kMScreenW, kMScreenH);
    [[UIApplication sharedApplication].windows[0] addSubview:self.otaShowTipVC.view];
    //    [self addChildViewController:self.otaShowTipVC];
    //    [self.view addSubview:self.otaShowTipVC.view];
    //    [self.otaShowTipVC didMoveToParentViewController:self];
    //    self.otaShowTipVC.view.frame = CGRectMake(0, 0, kMScreenW, kMScreenH);
}
- (void)removeChild {
    [self.otaShowTipVC.view removeFromSuperview];
    //    [self.otaShowTipVC willMoveToParentViewController:nil];
    //    [self.otaShowTipVC removeFromParentViewController];
}

#pragma mark 发送OTA数据包
- (void)sendPcaket {
    if(self.location < 0) return;
    kEndTimer(self.otaTimer)
    if (self.location >= self.number) {
        return;
    }
    NSUInteger packLoction;
    NSUInteger packLength;
    
    if (self.location+1 == self.number) {
        packLength = 0;
    }else if(self.location+1 == self.number-1){
        packLength = [self.otaData length]-self.location*16;
    }else{
        packLength = 16;
    }
    packLoction = self.location*16;
    NSRange range = NSMakeRange(packLoction, packLength);
    NSData *sendData = [self.otaData subdataWithRange:range];
    [kCentralManager sendPack:sendData];
    if (self.location+1==self.number) {
        self.isSingleSendFinsh = YES;
        [self.otaShowTipVC showTip:@"Send_Single_Finished"];
    }
    CGFloat per = self.location *1.0 / self.number;
    
    self.otaShowTipVC.progressL.text = [NSString stringWithFormat:@"----%.f%%--- ",per*100.f];
    self.otaShowTipVC.progressV.progress = per;
    
    self.location++;
    if (((packLoction + packLength)%kOTAPartSize == 0 && packLoction!= 0)||self.location+1==self.number) {
        [kCentralManager readFeatureOfselConnectedItem];
        if (!self.isSingleSendFinsh) {
            if (!((packLoction + packLength)%(1024*kPrintPerDataSend))) {
                NSString *p = [NSString stringWithFormat:@"%d KB data has been send", (int)((packLoction + packLength)/(1024))];
                [self.otaShowTipVC showTip:p];
            }
        }
        return;
    }
    self.otaTimer = [NSTimer scheduledTimerWithTimeInterval:0.00 target:self selector:@selector(sendPcaket) userInfo:nil repeats:YES];
}

- (void)scanDeviceForOTA {
    [kCentralManager startScanWithName:kSettingLastName Pwd:kSettingLastPwd AutoLogin:NO];
    kEndTimer(self.scanDeviceTimer)
    self.scanDeviceTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(scantimeOut:) userInfo:nil repeats:YES];
}

- (void)scantimeOut:(NSTimer *)timer {
    Rescan_Count++;
    NSString *tip;
    if (Rescan_Count <= kMaxScanCount) {
        if ([self.otaShowTipVC.hasOTADevices containsObject:self.otaShowTipVC.otaItem.uuidString]) {
            tip = [NSString stringWithFormat:@"reboot address: %x  for %ld/s", self.otaShowTipVC.otaItem.u_DevAdress, 6 * Rescan_Count];
        }else{
            tip = [NSString stringWithFormat:@"scan address: %x  for %ld/s", self.otaShowTipVC.otaItem.u_DevAdress, 6 * Rescan_Count];
        }
    }else{
        if (self.hasBeenOTADevicesAddress.count>0) {
            tip = [NSString stringWithFormat:@"ota success devices %lu个 : %@, fail devices %lu个 : %@", (unsigned long)self.hasBeenOTADevicesAddress.count,[self.hasBeenOTADevicesAddress componentsJoinedByString:@" - "], (unsigned long)self.hasBeenOTAFailDevicesAddress.count, [self.hasBeenOTAFailDevicesAddress componentsJoinedByString:@" - "]];
        }else{
            tip = [NSString stringWithFormat:@"No more device found" ];
        }
        kEndTimer(timer)
        [kCentralManager stopScan];
    }
    [self.otaShowTipVC showTip:tip];
}

#pragma mark 退出OTA手势
- (void)removeOTAView:(UILongPressGestureRecognizer *)sender{
    kEndTimer(self.otaTimer)
    self.location = 0;
    self.isStartOTA = NO;
    self.isAllFinish = NO;
    self.isSingleFinish = NO;
    self.isPartDataSendFinsh = NO;
    [self.otaShowTipVC.otaDevices removeAllObjects];
    [self.otaShowTipVC.hasOTADevices removeAllObjects];
    [self.hasBeenOTADevicesAddress removeAllObjects];
    [self removeChild];
//    [self.collectionSource removeAllObjects];
    [self.collectionView reloadData];
    [self startScan];
}

#pragma mark 长按进入设备详情手势
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    if (!kCentralManager.isLogin) return;
    if (longPress.state==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
        if (!self.collectionSource||!indexPath)  return;
        SingleSettingViewController *tempCon=[[SingleSettingViewController alloc] initWithNibName:@"SingleSettingViewController" bundle:[NSBundle mainBundle]];
        tempCon.isGroup=NO;
        tempCon.selData=[self.collectionSource objectAtIndex:indexPath.item];
        [self.navigationController pushViewController:tempCon animated:YES];
    }
}

#pragma mark 开始扫描连接登录mesh
- (void)startScan {
//    [self.collectionSource removeAllObjects];
    [self.collectionView reloadData];
    kCentralManager.scanWithOut_Of_Mesh = NO;
    [kCentralManager startScanWithName:kSettingLastName Pwd:kSettingLastPwd AutoLogin:YES];
}

#pragma mark - BTCentralManagerDelegate
#pragma mark SDK各个阶段可能返回的错误码
- (void)exceptionReport:(int)stateCode errorCode:(int)errorCode {
    NSLog(@"stateCode-errorCode :%d-%d",stateCode, errorCode);
}

#pragma mark 扫描设备变化
- (void)OnDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag {
    //特殊处理：打开APP时，发现上一次处于meshOTA
    if (flag == DevChangeFlag_Login && [MeshOTAManager share].hasMeshStateData && ![MeshOTAManager share].isMeshOTAing) {
        //存在本地数据
        NSDictionary *dict = [[MeshOTAManager share] getSaveMeshStateData];
        [[MeshOTAManager share] continueMeshOTAWithDeviceType:[dict[@"deviceType"] integerValue] progressHandle:^(MeshOTAState meshState, NSInteger progress) {
            if (meshState == MeshOTAState_normal) {
                //点对点OTA阶段
                NSString *t = [NSString stringWithFormat:@"ota firmware push... progress:%ld%%", (long)progress];
                ARShowTips.shareTips.showTip(t);
            }else if (meshState == MeshOTAState_continue){
                //meshOTA阶段
                NSString *t = [NSString stringWithFormat:@"package meshing... progress:%ld%%", (long)progress];
                ARShowTips.shareTips.showTip(t);
            }
        } finishHandle:^(NSInteger successNumber, NSInteger failNumber) {
            NSString *tip = [NSString stringWithFormat:@"success:%ld,fail:%ld", (long)successNumber, (long)failNumber];
            [UIAlertView alertWithMessage:tip];
        } errorHandle:^(NSError *error) {
            [UIAlertView alertWithMessage:error.domain];
            ARShowTips.shareTips.delayHidden(1);
        }];
    }
    //特殊处理，离线时，设备都断开
    if (flag == DevChangeFlag_DisConnected) {
        [self resetStatusOfAllLight];
    }
    
    if (!self.isStartOTA) {
        return;
    }
    kCentralManager.isAutoLogin = NO;
    switch (flag) {
        case DevChangeFlag_Add:
            [self dosomethingWhenDiscoverDevice:item];
            break;
        case DevChangeFlag_Connected:
            [self dosomethingWhenConnectedDevice:item];
            break;
        case DevChangeFlag_Login:
            [self dosomethingWhenLoginDevice:item];
            break;
        case DevChangeFlag_DisConnected:
            [self dosomethingWhenDisConnectedDevice:item];
            break;
        default:
            break;
    }
}

#pragma mark 蓝牙扫描到登录的Characteristic的代理回调
- (void)scanedLoginCharacteristic {
    if (!self.isStartOTA) return;
    [kCentralManager loginWithPwd:nil];
}

#pragma mark 硬件操作状态的代理回调
-(void)OnDevOperaStatusChange:(id)sender Status:(OperaStatus)status{
    if (status == DevOperaStatus_SetNetwork_Finish) {
        /*
         test code
         
         [self startScan];
         */
    }
}

#pragma mark 获取硬件的版本号数据的代理回调
- (void)OnConnectionDevFirmWare:(NSData *)data{
    if (![MeshOTAManager share].isMeshOTAing) {
        //非meshOTA状态，才处理这里的单灯OTA
        Byte *byte = (Byte *)[data bytes];
        NSMutableString *mStr = [NSMutableString string];
        for (int i = 0; i<data.length; i++) {
            [ mStr appendFormat:@"%c",byte[i] ];
        }
        if (self.isSingleFinish) {
            Byte b[4];
            memset(b, 0, 4);
            Byte *ob = (Byte *)[self.otaData bytes];
            memcpy(b, ob + 2, 4);
            int cp = memcmp(b, byte, 4);
            if (cp) {
                [self.otaShowTipVC showTip:@"校验失败，版本与目标版本不匹配，OTA失败"];
            }else{
                [self.otaShowTipVC showTip:@"校验成功，OTA升级成功"];
            }
        }
        NSString *showFirm = [NSString stringWithFormat:@"%@-%@",self.isSingleFinish ? (@"升级后:"):(@"升级前"),mStr];
        if (((self.location - 1) * 16.0) / kOTAPartSize == 1) {
            [self.otaShowTipVC showTip:showFirm];
        }
        if (!self.isSingleFinish) {
            [self sendPcaket];
        }else{
            [self.otaShowTipVC showTip:showFirm];
            self.otaShowTipVC.otaItem = nil;
            
            self.isSingleFinish = NO;
            self.isSingleSendFinsh = NO;
            self.location = 0;
            Rescan_Count = 0;
            //save devices has been ota
            [[SysSetting shareSetting] addDevice:true
                                            Name:[SysSetting shareSetting].currentUserName
                                             pwd:[SysSetting shareSetting].currentUserPassword
                                          device:kCentralManager.selConnectedItem
                                         address:@(self.otaShowTipVC.otaItem.u_DevAdress>>8)
                                         version:mStr];
            
            [self.otaShowTipVC.otaDevices removeObject:kCentralManager.selConnectedItem];
            //扫描进行下一个
            
            self.otaShowTipVC.progressV.progress = 0;
            self.otaShowTipVC.progressL.text = @"0/100";
            [self scanDeviceForOTA];
        }
    }
}

#pragma mark 蓝牙在线、离线状态改变
- (void)OnCenterStatusChange:(id)sender {
    if (kCentralManager.centerState == CBCentralManagerStatePoweredOff) {
        [self resetStatusOfAllLight];
    }
}

#pragma mark 硬件上报了设备的状态
- (void)notifyBackWithDevice:(DeviceModel *)model {
    if (!model) return;
    NSMutableArray *macs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.collectionSource.count; i++) {
        if (![macs containsObject:@(self.collectionSource[i].u_DevAdress)]) {
            [macs addObject:@(self.collectionSource[i].u_DevAdress)];
        }
    }
    //更新既有设备状态
    if ([macs containsObject:@(model.u_DevAdress)]) {
        NSUInteger index = [macs indexOfObject:@(model.u_DevAdress)];
        DeviceModel *tempModel =[self.collectionSource objectAtIndex:index];
        [tempModel updataLightStata:model];
        [self.collectionView reloadData];
//        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
    //添加新设备
    else{
        if (model.stata == LightStataTypeOutline || [self.filterlist containsObject:@(model.u_DevAdress)]) {
            if ([self.filterlist containsObject:@(model.u_DevAdress)] && model.stata == LightStataTypeOutline) {
                [self.filterlist removeObject:@(model.u_DevAdress)];
            }
            return;
        }
        DeviceModel *omodel = [[DeviceModel alloc] initWithModel:model];
        [self.collectionSource addObject:omodel];
        [self.collectionView reloadData];
    }
    //更新设备状态列表到meshOTA管理类
    [[MeshOTAManager share] setCurrentDevices:self.collectionSource];
}

#pragma mark 特殊情况处理－默认已经与所有灯断开连接－－所有灯的状态设置为0---
-(void)resetStatusOfAllLight{
    for (DeviceModel *model in self.collectionSource) {
        model.stata = 0;
        model.brightness = 0;
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.collectionSource indexOfObject:model] inSection:0]]];
    }
}

#pragma mark SDK各个阶段的超时回调
- (void)loginTimeout:(TimeoutType)type {
    switch (type) {
        case TimeoutTypeConnectting:
            [kCentralManager connectPro];
            break;
        case TimeoutTypeScanServices:
            [kCentralManager.selConnectedItem.blDevInfo discoverServices:nil];
            break;
        case TimeoutTypeScanCharacteritics:
            for (CBService *ser in kCentralManager.selConnectedItem.blDevInfo.services) {
                [kCentralManager.selConnectedItem.blDevInfo discoverCharacteristics:nil forService:ser];
            }   break;
        case TimeoutTypeWritePairFeatureBack:
            [kCentralManager loginWithPwd:nil]; break;
        default:
            [self startScan];
            break;
    }
}

#pragma mark BTCentralManager发现设备
- (void)dosomethingWhenDiscoverDevice:(BTDevItem *)item {
    if ([self.otaShowTipVC.hasOTADevices containsObject:item.devIdentifier]||[self.hasBeenOTAFailDevicesAddress containsObject:@(item.u_DevAdress)]) {
        return;
    }else{
        kEndTimer(self.scanDeviceTimer)
    }
    if (!self.otaShowTipVC.otaItem&&![self.otaShowTipVC.hasOTADevices containsObject:item.devIdentifier]) {
        self.otaShowTipVC.otaItem = item;
        [kCentralManager connectWithItem:item];
        return;
    }
    //是否是上次ota的设备
    BOOL islastDevice = [self.otaShowTipVC.otaItem.uuidString isEqualToString:item.uuidString];
    BOOL contain = [self.otaShowTipVC hasOTA:item.uuidString];
    if (!contain) {
        //ota成功的设备中不包含扫描到的设备，有两种情况，
        //1:已经ota过，处于重启状态
        //2:没有ota过，或是ota失败
        //扫描到的设备是最后一次ota的device
        if (islastDevice) {
            NSString *tip;
            //假如发包完成，说明重启状态
            if (self.isSingleSendFinsh) {
                tip = [NSString stringWithFormat:@"reboot address: %x", self.otaShowTipVC.otaItem.u_DevAdress];
                [kCentralManager connectWithItem:item];
            }
            //未发包完成，说明ota失败，需retry
            else{
                //                tip = [NSString stringWithFormat:@"ota retry address: %x", self.otaShowTipVC.otaItem.u_DevAdress];
            }
            [self.otaShowTipVC showTip:tip];
        }
        //扫描到的设备不是最后一次ota的device
        
        else{
            //
            if (!self.isSingleSendFinsh) {
                self.otaShowTipVC.otaItem = item;
                if (kCentralManager.devArrs.count==1) {
                    [kCentralManager connectWithItem:item];
                }else{
                    CBPeripheral *per = [kCentralManager.devArrs[kCentralManager.devArrs.count-2] blDevInfo];
                    if (per.state!=CBPeripheralStateConnecting&&per.state!=CBPeripheralStateConnected) {
                        [kCentralManager connectWithItem:item];
                    }
                }
            }
        }
    }
}

#pragma mark BTCentralManager连接设备成功（mesh未登录）
- (void)dosomethingWhenConnectedDevice:(BTDevItem *)item {
    kEndTimer(self.scanDeviceTimer)
    NSString *tip = [NSString stringWithFormat:@"connected device address: %x", item.u_DevAdress];
    [self.otaShowTipVC showTip:tip];
}

#pragma mark BTCentralManager设备登录mesh成功
- (void)dosomethingWhenLoginDevice:(BTDevItem *)item {
        NSString *otip = [NSString stringWithFormat:@"login in success  mesh -> %@ / %@", kSettingLastName, kSettingLastPwd];
        [self.otaShowTipVC showTip:otip];
        if ([self.otaShowTipVC.otaItem.uuidString isEqualToString:item.uuidString]&&self.location&&!self.isSingleFinish&&self.isSingleSendFinsh) {
            self.isSingleFinish = YES;
            NSString *addressS = [NSString stringWithFormat:@"Finish single device OTA with address %02x", item.u_DevAdress];
            [self.otaShowTipVC showTip:addressS];
            [self.otaShowTipVC.hasOTADevices addObject:self.otaShowTipVC.otaItem.uuidString];
            NSString *otaadd = [NSString stringWithFormat:@"%02x",kCentralManager.selConnectedItem.u_DevAdress>>8];
            [self.hasBeenOTADevicesAddress addObject:otaadd];
            self.otaShowTipVC.progressL.text = @"100/100";
            self.otaShowTipVC.progressV.progress = 1.;
        }
        if (!self.isSingleFinish) {
            kCentralManager.isAutoLogin = NO;
            self.location = 0;
            self.isSingleSendFinsh = false;
        }
        [kCentralManager readFeatureOfselConnectedItem];
}

#pragma mark BTCentralManager设备连接失败或者连接断开
- (void)dosomethingWhenDisConnectedDevice:(BTDevItem *)item {
    [self.otaShowTipVC showTip:@"disconnect...."];
    if (![self.otaShowTipVC.hasOTADevices containsObject:item.devIdentifier]) {
        if (self.isSingleSendFinsh) {
            NSString *tip = [NSString stringWithFormat:@"reboot with address: %x", self.otaShowTipVC.otaItem.u_DevAdress];
            [self.otaShowTipVC showTip:tip];
            Rescan_Count = 0;
        }else{
            [self.otaShowTipVC showTip:@"OTA fail..."];
            [self.hasBeenOTAFailDevicesAddress addObject:@(item.u_DevAdress)];
        }
    }
    [self scanDeviceForOTA];
}

- (void)OnDevNotify:(id)sender Byte:(uint8_t *)byte {
    NSData *data = [NSData dataWithBytes:byte length:20];
    Byte *dataByte = (Byte *)byte;
    UInt8 opCode = 0;
    memcpy(&opCode, dataByte+7, 1);
    UInt16 vendorID = 0;
    memcpy(&vendorID, dataByte+8, 2);
    NSData *parameters = [data subdataWithRange:NSMakeRange(10, 10)];
    NSString *string = [NSString stringWithFormat:@"APP receive opCode:0x%02X,vendorID:0x%04X,parameters:0x%@",opCode,vendorID,[TranslateTool convertDataToHexStr:parameters]];
    [BTCentralManager.shareBTCentralManager printContentWithString:string];
    NSLog(@"%@",string);
}

#pragma mark - notify
- (void)removeDevice:(NSNotification *)notify {
    NSMutableArray *macs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.collectionSource.count; i++) {
        if (![macs containsObject:@(self.collectionSource[i].u_DevAdress)]) {
            [macs addObject:@(self.collectionSource[i].u_DevAdress)];
        }
    }
    
    NSUInteger index = [macs indexOfObject:notify.userInfo[@"add"]];
    [self.collectionSource removeObjectAtIndex:index];
    [self.collectionView reloadData];
    [self.filterlist addObject:notify.userInfo[@"add"]];
    //删除本地数据
    NSInteger address = [notify.userInfo[@"add"] integerValue];
    [[SysSetting shareSetting] addDevice:NO Name:[BTCentralManager shareBTCentralManager].currentName pwd:[BTCentralManager shareBTCentralManager].currentPwd devices:@[@{Address:@(address >> 8)}]];
}

#pragma mark - lazy
- (NSMutableArray *)hasBeenOTAFailDevicesAddress {
    if (!_hasBeenOTAFailDevicesAddress) {
        _hasBeenOTAFailDevicesAddress = [[NSMutableArray alloc] init];
    }
    return _hasBeenOTAFailDevicesAddress;
}

- (NSMutableArray *)hasBeenOTADevicesAddress {
    if (!_hasBeenOTADevicesAddress) {
        _hasBeenOTADevicesAddress = [[NSMutableArray alloc] init];
    }
    return _hasBeenOTADevicesAddress;
}

- (NSMutableArray *)filterlist {
    if (!_filterlist) {
        _filterlist = [NSMutableArray new];
    }
    return  _filterlist;
}

- (NSMutableArray *)collectionSource{
    if (!_collectionSource) {
        _collectionSource = [[NSMutableArray alloc]init];
        for (NSNumber *add in [[SysSetting shareSetting] currentLocalDevices]) {
            DeviceModel *model = [[DeviceModel alloc] init];
            model.u_DevAdress = add.intValue << 8;
            model.stata = LightStataTypeOutline;
            model.brightness = 0;
            if (![_collectionSource containsObject:model]) {
                [_collectionSource addObject:model];
            }
        }
    }
    _collectionSource = [NSMutableArray arrayWithArray:[_collectionSource sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DeviceModel *b1 = obj1;
        DeviceModel *b2 = obj2;
        return b1.u_DevAdress > b2.u_DevAdress;
    }]];
    return _collectionSource;
}

- (OTATipShowVC *)otaShowTipVC {
    if (!_otaShowTipVC) {
        _otaShowTipVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OTATipShowVC"];
    }
    return _otaShowTipVC;
}

- (NSData *)otaData {
    if (!_otaData) {
        _otaData = [[NSFileHandle fileHandleForReadingAtPath:[[NSBundle mainBundle] pathForResource:kBinFileName ofType:@"bin"]] readDataToEndOfFile];
        NSLog(@"ota file : %@",kBinFileName);
    }
    return _otaData;
}

- (NSInteger)number {
    NSUInteger len = self.otaData.length;
    BOOL ret = (NSInteger)(len %16);
    //最后需要发送 firmware 数据长度为 0 的数据包用作结束标记。
    return !ret?((NSInteger)(len/16)+1):((NSInteger)(len/16)+2);
}

@end
