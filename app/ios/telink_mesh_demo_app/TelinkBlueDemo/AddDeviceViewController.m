/********************************************************************************************************
 * @file     AddDeviceViewController.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/1/11
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

#define Login_Time_Out 20                  //登录超时
#define SetMesh_Time_Out 20            //加灯超时
#define Finished_Time_Out 24
#define ReplaceAddr_Time_Out  10    //分配地址

#import "AddDeviceViewController.h"
#import "AppDelegate.h"
#import "MeshInfoViewController.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "MyCollectionViewCell.h"
#import "SysSetting.h"
#import "LightData.h"
#import "TranslateTool.h"
#import "ErrorModel.h"

@interface AddDeviceViewController () <BTCentralManagerDelegate>
{   
    BTCentralManager *centralManager;
    UICollectionView *listView;
    BTDevItem *settingItem;//正在被设置的灯
    NSMutableArray *oldAddresses;  //旧地址
    NSMutableArray *newAddresses; //新地址
    BOOL existed;
    BOOL isSetMesh;
    BOOL addFinishedBtnClicked;
    
}
@property (nonatomic, strong) NSMutableArray *dataArrs;
@property (nonatomic, strong) UICollectionView *listView;
@property(nonatomic, strong) NSTimer *loginTimer;         //加灯定时器
@property(nonatomic, strong) NSTimer *setMeshTimer;       //加灯定时器
@property(nonatomic, strong) NSTimer *finishedTimer;      //结束控制定时器
@property(nonatomic, strong) NSTimer *replaceTmer;        //分配地址定时器
@property(nonatomic, assign) NSUInteger logintime;
@property(nonatomic, assign) NSUInteger setMeshTime;
@property(nonatomic, assign) NSUInteger finishedTime;
@property(nonatomic, assign) NSUInteger replaceTime;
@property(nonatomic, strong) UIButton *tempBtn;
@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, strong) NSMutableDictionary *failsource;

@property (nonatomic, strong) NSString *oName;
@property (nonatomic, strong) NSString *oPassword;
@property (nonatomic, strong) NSString *nName;
@property (nonatomic, strong) NSString *nPassword;

@end

static BOOL flages = YES;
static NSUInteger addressInt;

@implementation AddDeviceViewController
@synthesize listView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oldAddresses = [[NSMutableArray alloc]init];
    newAddresses = [[NSMutableArray alloc]init];
    
    [self configUI];
    
    centralManager=[BTCentralManager shareBTCentralManager];
    centralManager.delegate=self;

    isSetMesh = NO;
    [self fileHandle];    //处理文件存储
    [self performSelector:@selector(scanPro) withObject:self afterDelay:1];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    self.tabBarController.tabBar.hidden = YES;
    flages = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    centralManager.delegate = nil;
    [self.loginTimer invalidate];
    [self.setMeshTimer invalidate];
    [self.finishedTimer invalidate];
    self.logintime = 0;
    self.setMeshTime = 0;
    self.finishedTime = 0;
    [self fileControl];
    flages = NO;
    [[BTCentralManager shareBTCentralManager] stopScan];
}

- (void)configUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UICollectionViewFlowLayout *tempLayout=[[UICollectionViewFlowLayout alloc] init];
    [tempLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    CGRect parRect=self.view.bounds;
    CGRect btnRect=parRect;
    btnRect.origin.y=CGRectGetHeight(parRect)-55;
    btnRect.size.height=55;
    
    UIButton *tempBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [tempBtn setFrame:btnRect];
    [tempBtn addTarget:self action:@selector(addDeviceClick:) forControlEvents:UIControlEventTouchUpInside];
    [tempBtn setTitle:@"Adding" forState:UIControlStateDisabled];
    [tempBtn setTitle:@"Adding" forState:UIControlStateNormal];
    self.tempBtn = tempBtn;
    btnRect.origin.x=CGRectGetMaxX(btnRect);
    tempBtn.enabled = NO;
    [self.view addSubview:tempBtn];
    
    CGRect tempRect=parRect;
    tempRect.origin.y=64;
    tempRect.size.height=CGRectGetHeight(parRect)-CGRectGetHeight(btnRect)-64;
    self.listView=[[UICollectionView alloc] initWithFrame:tempRect collectionViewLayout:tempLayout];
    listView.dataSource=self;
    listView.delegate=self;
    listView.backgroundColor=[UIColor clearColor];
    
    [listView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"AddListViewCell"];
    
    [self.view addSubview:listView];

    self.navigationItem.title = @"Adding";
}

-(void)fileHandle{
    //前后mesh信息
    _oName = [SysSetting shareSetting].oldUserName;
    _oPassword = [SysSetting shareSetting].oldUserPassword;
    _nName = [SysSetting shareSetting].currentUserName;
    _nPassword = [SysSetting shareSetting].currentUserPassword;
    
    //数据存储考虑用属性列表处理
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    //创建文件名字
    NSString *fileName = [NSString stringWithFormat:@"%@-%@",_nName,_nPassword];
    NSString *filepath = [path stringByAppendingPathComponent:fileName];

    BOOL existedFile = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    existed = existedFile;
    
    if ([[SysSetting shareSetting] currentLocalDevices]&&[[SysSetting shareSetting] currentLocalDevices].count > 0) {
        NSArray *arr = [[[SysSetting shareSetting] currentLocalDevices] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            int b1 = [obj1 intValue];
            int b2 = [obj2 intValue];
            return b1 > b2;
        }];
        addressInt = [arr.lastObject intValue] + 1;
     }else{
        addressInt = 1;
    }
        self.filePath = filepath;
}

-(void)scanPro {
    centralManager.delegate=self;
    [BTCentralManager shareBTCentralManager].scanWithOut_Of_Mesh = YES;
    if (_oName.length) {
        [centralManager startScanWithName:_oName Pwd:_oPassword AutoLogin:YES];
    } else {
        [centralManager startScanWithName:@"telink_mesh1" Pwd:@"123" AutoLogin:YES];
    }
    self.navigationItem.title = @"-Logining-";
    self.logintime = 0;
    [self.loginTimer invalidate];
    self.loginTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:@"loginTimer" repeats:YES];
}

//超时处理
-(void)timeAction:(NSTimer *)timer{
    if ([timer.userInfo isEqualToString:@"loginTimer"]) {
        self.logintime++;
        if (self.logintime == Login_Time_Out/2) {
            [self scanPro];
            self.navigationItem.title = @"-Scaning Again-";
            self.logintime = Login_Time_Out/2;
        }
        if (self.logintime >= Login_Time_Out) {
            self.logintime = 0;
            [self.loginTimer invalidate];
            [centralManager stopScan];
            self.tempBtn.enabled = YES;
            self.navigationItem.title = @"-Finished-";
            [self.tempBtn setTitle:@"<-Unable To Connect To Other Services->" forState:UIControlStateNormal];
        }
    }else if([timer.userInfo isEqualToString:@"setMeshTimer"]){
        self.setMeshTime++;
        if (self.setMeshTime == SetMesh_Time_Out) {
            self.tempBtn.enabled = YES;
            self.navigationItem.title = @"-SetNetWork Failed, Trying Again-";
            self.setMeshTime = 0;
            [self.setMeshTimer invalidate];
            addressInt--;
            [self scanPro];
            [self addConfigueSign:false];
        }
    }else if([timer.userInfo isEqualToString:@"finishedTimer"]){
        self.finishedTime++;
        if (self.finishedTime == Finished_Time_Out) {
            self.finishedTime = 0;
            [self.finishedTimer invalidate];
            [centralManager stopScan];
            self.tempBtn.enabled = YES;
            [self.tempBtn setTitle:@"<-Add Finished->" forState:UIControlStateNormal];
            self.navigationItem.title = @"-Click...Add Finished-";
            NSUInteger sucess = 0;
            NSMutableString *tip = [NSMutableString new];
            for (ErrorModel *m in self.failsource.allValues) {
                if (m.isSuccess) {
                    sucess++;
                    if (m.count > 1) {
                        [tip appendFormat:@"设备%ld重试了%d次才成功",(unsigned long)m.address, m.count-1];
                        continue;
                    }
                }
            }
            [tip appendString:[NSString stringWithFormat:@"成功个数:%lu  失败次数:%lu",(unsigned long)sucess, self.failsource.allValues.count - sucess]];
            [[BTCentralManager shareBTCentralManager] performSelector:@selector(printContentWithString:) withObject:tip];
            [self.loginTimer invalidate];
        }
    }else if([timer.userInfo isEqualToString:@"replaceTmer"]){
        self.replaceTime++;
        if (self.replaceTime == ReplaceAddr_Time_Out ) {
            //修改地址超时－－－重新扫描连接分配地址
            self.navigationItem.title = @"-Distributing Address Fail...Trying Again-";
            [self scanPro];
        }
        //修改地址超时
    }
}

#pragma mark - BTCentralManagerDelegate
-(void)OnDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag{
    
    if (flag == DevChangeFlag_Login && isSetMesh == NO) {
        self.finishedTime = 0;
        [self.finishedTimer invalidate];
        self.logintime = 0;
        [self.loginTimer invalidate];
        if (addressInt >= 256) {
            [self.tempBtn setTitle:@"<-《Address Overflow》->" forState:UIControlStateNormal];
            self.navigationItem.title = @"-Click_Address overflow-";
            [self fileControl];
            [self popMessage];
            return;
        }
//        [centralManager replaceDeviceAddress:centralManager.selConnectedItem.u_DevAdress WithNewDevAddress:addressInt];
        [centralManager replaceDeviceAddress:0 WithNewDevAddress:addressInt];
        self.navigationItem.title = @"-Distributing Address-";
        settingItem = item;
        [self.replaceTmer invalidate];
        self.replaceTime = 0;
        self.replaceTmer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:@"replaceTmer" repeats:YES];
        if ([self.failsource.allKeys containsObject:settingItem.devIdentifier]) {
            [self addConfigueSign:false];
        }else{
            self.failsource[settingItem.devIdentifier] = [[ErrorModel alloc] initWithID:settingItem.devIdentifier address:addressInt];
        }
        [oldAddresses addObject:[NSString stringWithFormat:@"%u",settingItem.u_DevAdress]];
    }
    
}

-(void)OnDevOperaStatusChange:(id)sender Status:(OperaStatus)status{
    if (status == DevOperaStatus_SetNetwork_Finish) {
        self.setMeshTime = 0;
        [self.setMeshTimer invalidate];
        isSetMesh = NO;
        //查询版本号
        [centralManager readFeatureOfselConnectedItem];
    }
}

- (void)addSingleSuccess{
    [self addConfigueSign:true];

    [self scanPro];
    addressInt++;
    self.finishedTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:@"finishedTimer" repeats:YES];
    [self CreateLightSign];
}

-(void)resultOfReplaceAddress:(uint32_t )resultAddress{
        NSString *result = [NSString stringWithFormat:@"%u",resultAddress];
        NSString *addInt = [NSString stringWithFormat:@"%ld",(unsigned long)addressInt];
    
//设置成功的时候
    if ([result isEqualToString:addInt]){
        self.replaceTime = 0;
        [self.replaceTmer invalidate];
        //修改mesh名称之前的[centralManager stopScan]为多余的，连接设备之前已经调用过停止扫描了(BTCentralManager.m line.858)
//        [centralManager stopScan];
        isSetMesh = YES;
//        uint8_t tlkBuffer[20]={0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0xdf,0x0,0x0,0x0,0x0};
        GetLTKBuffer;
        if ([[settingItem u_Name]isEqualToString:@"out_of_mesh"]) {
            [[BTCentralManager shareBTCentralManager] setOut_Of_MeshWithName:@"out_of_mesh" PassWord:@"123" NewNetWorkName:_nName Pwd:_nPassword ltkBuffer:ltkBuffer ForCertainItem:settingItem];
            
        }else{
            if (_nName.length) {
                [[BTCentralManager shareBTCentralManager] setOut_Of_MeshWithName:_oName PassWord:_oPassword NewNetWorkName:_nName Pwd:_nPassword ltkBuffer:ltkBuffer ForCertainItem:settingItem];
            } else {
                [[BTCentralManager shareBTCentralManager] setOut_Of_MeshWithName:@"telink_mesh1" PassWord:@"123" NewNetWorkName:_oName Pwd:_oPassword ltkBuffer:ltkBuffer ForCertainItem:settingItem];
            }
        }
        [newAddresses addObject:result];                   //新地址加入
        self.setMeshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:@"setMeshTimer" repeats:YES];
        self.navigationItem.title = @"-Setting NetWork-";
    }else{
//设置失败的时候
        [self scanPro];
        [oldAddresses removeLastObject];    //失败时候将最后一个元素取出
        [self addConfigueSign:false];
    }

  }

/*data:<56312e48 00000000 00000000>*/
-(void)OnConnectionDevFirmWare:(NSData *)data{
    NSString *firm = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(0, 4)] encoding:NSUTF8StringEncoding];
    NSLog(@"OnConnectionDevFirmWare:%@",firm);
    
    [[SysSetting shareSetting] addDevice:true
                                    Name:_nName
                                     pwd:_nPassword
                                  device:settingItem
                                 address:@(addressInt)
                                 version:firm];

    [self addSingleSuccess];
}

//实现该回调的目的是以下四个超时时，APP立刻进行下一轮扫描添加，而不是等待10秒的扫描超时。
#pragma mark SDK各个阶段的超时回调
- (void)loginTimeout:(TimeoutType)type {
    switch (type) {
        case TimeoutTypeConnectting:
            [BTCentralManager.shareBTCentralManager printContentWithString:@"connect timeout!!!"];
            NSLog(@"connect timeout!!!");
            [self scanPro];
            break;
        case TimeoutTypeScanServices:
            [BTCentralManager.shareBTCentralManager printContentWithString:@"scan services timeout!!!"];
            NSLog(@"scan services timeout!!!");
            [self scanPro];
            break;
        case TimeoutTypeScanCharacteritics:
            [BTCentralManager.shareBTCentralManager printContentWithString:@"scan characteritics timeout!!!"];
            NSLog(@"scan characteritics timeout!!!");
            [self scanPro];
            break;
        case TimeoutTypeWritePairFeatureBack:
            [BTCentralManager.shareBTCentralManager printContentWithString:@"pair timeout!!!"];
            NSLog(@"pair timeout!!!");
            [self scanPro];
            break;
        default:

            break;
    }
}

- (void)addConfigueSign:(BOOL)success {
    ErrorModel *m;
    if ([self.failsource.allKeys containsObject:settingItem.devIdentifier]) {
        m = self.failsource[settingItem.devIdentifier];
        self.failsource[settingItem.devIdentifier] = m;
    }else{
        m = [[ErrorModel alloc] initWithID:settingItem.devIdentifier address:addressInt];
        self.failsource[settingItem.devIdentifier] = m;
    }
    m.count = m.count + 1;
    m.isSuccess = success;
}

-(void)CreateLightSign{
    LightData *tempData = [[LightData alloc]init];
    
    tempData.addressName = [NSString stringWithFormat:@"%u->%lu",settingItem.u_DevAdress>>8,addressInt-1];
    tempData.devAress = (uint32_t)(addressInt-1)<<8;
    NSLog(@"settingItem.productID = %d",settingItem.productID);
    [self.dataArrs addObject:tempData];
    [listView reloadData];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArrs.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden=@"AddListViewCell";
    MyCollectionViewCell *tempCell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIden forIndexPath:indexPath];
    [tempCell sizeToFit];
    if (!tempCell)
    {
        return nil;
    }
    
    if (indexPath.row>=0 && indexPath.row<_dataArrs.count)
    {
        LightData *tempData=[_dataArrs objectAtIndex:indexPath.row];

        NSString *tempImgName=@"icon_light_on";
        tempCell.imgView.image=[UIImage imageNamed:tempImgName];
        tempCell.imgView.tag=indexPath.row;
        tempCell.titleLab.text = [NSString stringWithFormat:@"(%@)",tempData.addressName];
        tempCell.titleLab.font = [UIFont boldSystemFontOfSize:12];
        if ((tempData.devAress == [BTCentralManager shareBTCentralManager].selConnectedItem.u_DevAdress)) {
            tempCell.titleLab.textColor = [UIColor redColor];
        }else{
            tempCell.titleLab.textColor = [UIColor blackColor];
        }

    }
    return tempCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 125);
}

///点击添加，返回设备列表界面
-(void)addDeviceClick:(id)sender {
        if (!_nName || _nName.length<1) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (!_nPassword || _nPassword.length<1) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
}

//两种情况下的文件处理
-(void)fileControl{
    //文件处理---如果没有点击这个按钮时候另外处理
//    if (oldAddresses.count > newAddresses.count) {
//        NSUInteger plus = oldAddresses.count-newAddresses.count;
//        for (int i = 0; i < plus; i++) {
//            [oldAddresses removeLastObject];
//        }
//
//    }
//    self.totalDictionary = [[NSMutableDictionary alloc]initWithObjects:oldAddresses forKeys:newAddresses];
//    [self.totalDictionary writeToFile:self.filePath atomically:YES];
//    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:self.filePath];
}

-(void)popMessage{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"Mesh内灯已满" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:3.f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

#pragma mark - lazy
- (NSMutableDictionary *)failsource {
    if (!_failsource) {
        _failsource = [NSMutableDictionary new];
    }
    return _failsource;
}

-(NSMutableArray *)dataArrs{
    if (_dataArrs == nil) {
        _dataArrs = [[NSMutableArray alloc]init];
    }
    return _dataArrs;
}

@end
