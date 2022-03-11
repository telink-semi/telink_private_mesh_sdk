/********************************************************************************************************
 * @file     BTCentralManager.h 
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

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "DeviceModel.h"

//创建特定的ltkBuffer数组，[0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7,0xd8,0xd9,0xda,0xdb,0xdc,0xdd,0xde,0xf0,0x00,0x00,0x00,0x00]
#define GetLTKBuffer  \
Byte ltkBuffer[20]; \
memset(ltkBuffer, 0, 20); \
for (int j=0; j<16; j++) { \
if (j<8) { \
ltkBuffer[j] = 0xc0+j; \
}else{ \
ltkBuffer[j] = 0xd0+j; \
} \
}

//为了静默meshOTA新增通知
#define kOnConnectionDevFirmWareNotify            @"kOnConnectionDevFirmWareNotify"
#define kOnDevChangeNotify                                 @"kOnDevChangeNotify"
#define kOnDevNotifyNotify                                    @"kOnDevNotifyNotify"

//不采样的命令中，相邻命令的执行间隔大于等于0.32s
#define kCMDInterval 0.32
#define kTestLog YES

#define ScanTimeout (15.0)

#define kTelinkMeshVersion  @"2.6.2"

typedef enum {
    BTCommandCaiYang,
    BTCommandInterval
} BTCommand;

typedef enum {
    DevChangeFlag_Add=1,
    DevChangeFlag_Remove,//暂时不会用到
    DevChangeFlag_Connected,
    DevChangeFlag_DisConnected,
    DevChangeFlag_ConnecteFail,
    DevChangeFlag_Login
}DevChangeFlag;

typedef enum {
    DevOperaType_Normal=1,
    DevOperaType_Login,
    DevOperaType_Set,
    DevOperaType_Com,
    DevOperaType_AutoLogin
}DevOperaType;

typedef enum {
    DevOperaStatus_Normal=1,
    DevOperaStatus_ScanSrv_Finish,//完成扫描服务uuid
    DevOperaStatus_ScanChar_Finish,//完成扫描特征
    DevOperaStatus_Login_Start,
    DevOperaStatus_Login_Finish,
    DevOperaStatus_SetName_Start,
    DevOperaStatus_SetPassword_Start,
    DevOperaStatus_SetLtk_Start,
    DevOperaStatus_SetNetwork_Finish,
    DevOperaStatus_FireWareVersion
    //添加部分
}OperaStatus;

typedef enum {
    DisconectType_Normal = 1,
    DisconectType_SequrenceSetting,
}DisconectType;

typedef NS_ENUM(NSUInteger, TimeoutType) {
    TimeoutTypeScanDevice = 1<<0,
    TimeoutTypeConnectting = 1<<1,
    TimeoutTypeScanServices = 1<<2,
    TimeoutTypeScanCharacteritics = 1<<3,
    TimeoutTypeWritePairFeatureBack = 1<<4,
    TimeoutTypeReadPairFeatureBack = 1<<5,
    TimeoutTypeReadPairFeatureBackFailLogin = 1<<6
};

typedef NS_ENUM(NSUInteger, BTStateCode) {
    BTStateCode_Normal = 0,//不会上报
    BTStateCode_Scan = 1,
    BTStateCode_Connect = 2,
    BTStateCode_Login = 3
};

typedef NS_ENUM(NSUInteger, BTErrorCode) {
    BTErrorCode_UnKnow = 0,//不会上报
    BTErrorCode_NO_ADV = 101,
    BTErrorCode_BLE_Disable,
    BTErrorCode_NO_Device_Scaned,//can receive adv
    
    BTErrorCode_Cannot_CreatConnectRelation = 201,
    BTErrorCode_Cannot_ReceiveATTList,
    
    BTErrorCode_WriteLogin_NOResponse = 301,
    BTErrorCode_ReadLogin_NOResponse,
    BTErrorCode_ValueCheck_LoginFail
};

typedef enum : NSUInteger {
    MeshOTAState_normal = 0,//正常状态，可以开始OTA
    MeshOTAState_continue = 2,//异常后继续meshOTA状态，继续显示进度
    MeshOTAState_end = 4,//OTA结束状态，需要index清零
    MeshOTAState_error,//错误状态，OTA失败（需发送Mesh stop）
    MeshOTAState_no = 0xff,//非meshOTA状态
} MeshOTAState;

@class BTDevItem;

@protocol BTCentralManagerDelegate <NSObject>

@optional


- (void)loginTimeout:(TimeoutType)type;
//收集error code
- (void)exceptionReport:(int)stateCode errorCode:(int)errorCode deviceID:(int)deviceID;

- (void)scanedLoginCharacteristic;

///**
// mesh加灯模式，修改mesh名称、密码成功回调
// */
//- (void)setMeshInfoSuccessBack;

/**
 *手机蓝牙状态变化
 
 */
-(void)OnCenterStatusChange:(id)sender;
/**
 *扫描设备变化
 */
-(void)OnDevChange:(id)sender Item:(BTDevItem *)item Flag:(DevChangeFlag)flag;

/**
 *收到设备上传信息,一般byte为20字节
 */
- (void)OnDevNotify:(id)sender Byte:(uint8_t *)byte;

/**
 *接收到设备的firewareVersion－－
 对应Service_Device_Information(UUID.fromString("0000180a-0000-1000-8000-00805f9b34fb"), "Device Information Service"),
 Characteristic_Firmware(UUID.fromString("00002a26-0000-1000-8000-00805f9b34fb"), "Firmware Version"),
 */
-(void)OnConnectionDevFirmWare:(NSData *)data;


-(void)OnConnectionDevFirmWare:(NSData *)data Item:(BTDevItem *)item;

/**
 *Command口上传信息
 */
- (void)OnDevCommandReport:(id)sender Byte:(uint8_t *)byte;

/**
 *操作状态变化
 */
- (void)OnDevOperaStatusChange:(id)sender Status:(OperaStatus)status;

///**
// *扫描到一个设备
// */
//- (void)scanResult:(BTDevItem *)item;

/**
 *因为断开连接导致逐个加灯失败情况处理
 */
-(void)settingForDisconnect:(BTDevItem *)item WithDisconectType:(DisconectType)type;

/**
 *直连灯被拔除或者换了直连灯的时候调用
 */
-(void)RevokeOfSelconnectItemChange:(BTDevItem *)item;

/**
 调用情形1-－扫描没有发现可以直连的设备的时候调用－－可在.m文件内部设置超时时间
 调用情形2-－直连灯被拔掉的时候短暂性的重新设置灯的显示状态为离线
 */
-(void)resetStatusOfAllLight;
/**
 *修改设备地址之后的notify解析
 */
-(void)resultOfReplaceAddress:(uint32_t )resultAddress;
/**
 *接收存储状态的对象－－－使用时候需要导入模型类DeviceModel－－－－必须要实现的部分
 */
-(void)getFirstStataFromNotify:(DeviceModel *)firstDevice NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "deprecated, use notifyBackWithDevice instead") ;
-(void)getSecondStataFromNotify:(DeviceModel *)secondDevice NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "deprecated, use notifyBackWithDevice instead") ;
//代替掉上面两个方法
- (void)notifyBackWithDevice:(DeviceModel *)model;

@end

@interface BTCentralManager : NSObject<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    BTDevItem *selConnectedItem;//当前连接的设备
    BOOL isAutoLogin;//扫描到设备后自动连接登录、断开后自动连接登录
}
@property (nonatomic, strong,readonly) NSArray *devArrs;
@property (nonatomic, assign,readonly) CBCentralManagerState centerState;//手机蓝牙状态
@property (nonatomic, assign,readonly) DevOperaType operaType;
@property (nonatomic, assign,readonly) OperaStatus operaStatus;
@property (nonatomic, strong,readonly) BTDevItem *selConnectedItem;//当前连接的设备
@property (nonatomic, assign, getter=isLogin,readonly) BOOL isLogin;
@property (nonatomic, assign, readonly) BOOL isConnected;
@property (nonatomic, assign, getter=isAutoLogin) BOOL isAutoLogin;//扫描到设备后自动连接登录、断开后自动连接登录

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL isDebugLog;

@property(nonatomic,assign)NSUInteger timeOut;                    //特别指明，此处是一个一个设置全部设备mesh 从scan到默认已经全部设置完成的时间－－－具体数值根据项目调试－－－默认全部扫描并且设置完成在ScanAndSetAllDeviceFinished中通知
@property(nonatomic,assign)BOOL scanSetting;
@property(nonatomic,assign)DisconectType disconnectType;
@property(nonatomic,assign)BOOL scanWithOut_Of_Mesh;

@property (nonatomic, assign) BTCommand btCMDType;
@property (nonatomic, copy) void(^PrintBlock)(NSString *con);

/**
 *停止链接的外接
 */
-(void)stopConnected;

/**
 *第一次扫描name 和 password 可以填nil
 */
-(void)startScanWithName:(NSString *)nStr Pwd:(NSString *)pwd AutoLogin:(BOOL)autoLogin;
////停止连接、清空数据、等待下一次扫描
//
//-(void)startScanForOtaUpDate:(NSString *)scanName Pwd:(NSString*)scanPwd AutoLoginItem:(BTDevItem *)item;


-(void)stopScan;

/**
 *当cItem为nil时默认连接devArr数组最后一个设备。注意：需要在非自动登录的扫描后才可以调用该方法，否则可能造成cItem.blDevInfo为nil。
 */
-(void)connectWithItem:(BTDevItem *)cItem;

-(void)loginWithPwd:(NSString *)pStr;

/**
 *发送命令，有采样或者发送间隔。
 */
-(void)sendCommand:(uint8_t *)cmd Len:(int)len;

/**
*发送命令，无采样与发送间隔。
*/
- (void)sendCommandWithoutCMDInterval:(uint8_t *)cmd Len:(int)len;

/**
 *设置所有灯的meshname
 **************注意： 此处的ltk的buffer为方便没有设定默认值，传nil为设置为
 uint8_t tlkBuffer[20]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
 0x00,0x0,0x0,0x0,0x0};
 原来版本的默认值为    uint8_t tlkBuffer[20]={0xc0,0xc1,0xc2,0xc3,0xc4,0xc5,0xc6,0xc7,0xd8,
 0xd9,0xda,0xdb,0xdc,0xdd,0xde,0xdf,0x0,0x0,0x0,0x0};
 
 传入的参数buffer只需要填写：tlkBuffer
 */
-(void)setNewNetworkName:(NSString *)nName Pwd:(NSString *)nPwd ltkBuffer:(uint8_t *)buffer;

/**
 *此方法暂时专用与解决修改out_of_mesh的name  password 和ltk
 */
-(void)setOut_Of_MeshWithName:(NSString *)addName PassWord:(NSString *)addPassWord NewNetWorkName:(NSString *)nName Pwd:(NSString *)nPwd ltkBuffer:(uint8_t *)buffer ForCertainItem:(BTDevItem *)item;

/**
 mesh模式加灯使用，修改完所有的短地址后，修改mesh网络的name、password
 */
- (void)updateMeshInfo:(NSString *)nname password:(NSString *)npasword;

/**
 *设置某一个灯的meshname-------长按cell修改时候－－－demo设置为name：tling   －－npwd：123
 */
-(void)setNewNetworkName:(NSString *)nName Pwd:(NSString *)nPwd WithItem:(BTDevItem *)item ltkBuffer:(uint8_t *)buffer;


+ (BTCentralManager*) shareBTCentralManager;

/**
 *获取灯的状态
 */
-(void)setNotifyOpenPro;

/**
 *全开接口
 */

-(void)turnOnAllLight;


/**
 *全开接口
 */

- (void)turnOffAllLight;

/**
 *单灯的开灯－－－传入设备地址
 */

- (void)turnOnCertainLightWithAddress:(uint32_t )u_DevAddress;


/**
 *单灯的关灯－－－传入设备地址
 */
-(void)turnOffCertainLightWithAddress:(uint32_t )u_DevAddress;


/**
 *组的开灯－－－传入组地址
 */
-(void)turnOnCertainGroupWithAddress:(uint32_t )u_GroupAddress;

/**
 *组的关灯－－－传入组地址
 */
-(void)turnOffCertainGroupWithAddress:(uint32_t )u_GroupAddress;


/**
 *重新设置设备的u_DevAdress－－传入目的地址和新地址
 */

-(void)replaceDeviceAddress:(uint32_t)presentDevAddress WithNewDevAddress:(NSUInteger)newDevAddress;

/**
 *设置亮度值lum－－传入目的地址和亮度值---可以是单灯或者组的地址
 */
-(void)setLightOrGroupLumWithDestinateAddress:(uint32_t)destinateAddress WithLum:(NSInteger)lum;

/**
 *设置RGB－－－传入目的地址和R.G.B值－－-可以是单灯或者组的地址
 */

-(void)setLightOrGroupRGBWithDestinateAddress:(uint32_t)destinateAddress WithColorR:(float)R WithColorG:(float)G WithB:(float)B;

/**
 *加组－－－传入待加灯的地址，和 待加入的组的地址
 */

-(void)addDevice:(uint32_t)targetDeviceAddress ToDestinateGroupAddress:(uint32_t)groupAddress;

/**
 *删组－－－传入待加灯的地址，和 待加入的组的地址
 */

-(void)deleteDevice:(uint32_t)targetDeviceAddress ToDestinateGroupAddress:(uint32_t)groupAddress;


/**
 *kick-out---传入待处置的灯的地址－－－地址目前建议只针对组；；；
 */
-(void)kickoutLightFromMeshWithDestinateAddress:(uint32_t)destinateAddress;


/**
 *设置CT－－－传入设备的地址和CT值--CT的传入取值为0---1的浮点值；
 */
-(void)setCTOfLightWithDestinationAddress:(uint32_t)destinationAddress AndCT:(float)CT;
//获取所在组信息
- (void)getGroupAddressWithDeviceAddress:(uint32_t)destinationAddress;

/**
 *OTA数据包发送－－－data为分配之后的包
 */
-(void)sendPack:(NSData *)data;
- (void)sendOTAData:(NSData *)data index:(int)index;
- (void)sendOTAEndDataWithIndex:(int)index;

/**
 *读取当前直连灯属性值
 */
- (void)readFeatureOfselConnectedItem;

-(void)readFirmwareVersionOfselConnectedItem;

-(void)connectPro;

- (NSString *)currentName;
- (NSString *)currentPwd;

#pragma mark - MeshOTA相关
/**
 读取MeshOTA状态
 */
- (void)readMeshOTAState;

/**
 app告诉直连节点进入MeshOTA状态
 @param deviceType 需要MeshOTA的设备类型，如：1、2、3、4
 */
- (void)changeMeshStateToMeshOTAWithDeviceType:(NSInteger )deviceType;

/**
 读取所有设备版本号
 */
- (void)readFirmwareVersion;

/**
 meshOTA停止操作
 */
- (void)meshOTAStop;

///开始OTA前需要先清零Index，主要是meshOTA需要
- (void)resetOTAPackIndex;

///判断是否可以发送OTA发包(发送非OTA包后，一秒内不可发送OTA包，主要是meshOTA需要)
- (BOOL)canSendPack;

///保存log信息，供APP显示
- (void)printContentWithString:(NSString *)content;

///设置时间
- (void)setTime;

#pragma mark - online status相关

- (void)addNewDeviceModelsToOnlineStatusTable:(NSArray <DeviceModel *>*)deviceModels;

@end
