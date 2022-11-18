/********************************************************************************************************
 * @file     SingleSettingViewController.m 
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

#import "SingleSettingViewController.h"
#import "DTColorPickerImageView.h"
#import "SingleSettingViewController.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "LightData.h"
#import "ChooseGroupViewController.h"
#import "DemoDefine.h"
#import "ARMainVC.h"
#import "SingleOTAViewController.h"

@interface SingleSettingViewController () <DTColorPickerImageViewDelegate>

@property (atomic, assign) int lastBright;
@property (atomic, strong) UIColor *lastColor;
@property (atomic, assign) int lastTemp;
@property (nonatomic, strong) NSTimer *sendCmdTimer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ctH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cbH;

@property (weak, nonatomic) IBOutlet UIImageView *currentColorView;

@end

@implementation SingleSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self normalSetting];
}
- (void)normalSetting {
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.lastBright=-1;
    self.lastTemp=-1;
    
    self.currentColorView.backgroundColor = [UIColor yellowColor];
    self.currentColorView.layer.cornerRadius = 8;
    self.currentColorView.layer.borderWidth = 1;
    self.currentColorView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (self.isGroup) {
        self.navigationItem.title = self.groupName;
        self.addButton.hidden = YES;
        self.removeButton.hidden = YES;
        self.kickOutButton.hidden = YES;
    }else{
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(10, 10, 70, 28);
        [rightBtn setTitle:@"OTA" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(oTAClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

        self.navigationItem.rightBarButtonItem=rightButton;
        self.navigationItem.title = [NSString stringWithFormat:@"%02X",self.selData.u_DevAdress >> 8];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    if (kMScreenH<667) {
        self.addH.constant = 36;
        self.ctH.constant = 32;
        self.cbH.constant = 32;
    }else{
        self.addH.constant = 50;
        self.ctH.constant = 50;
        self.cbH.constant = 50;
    }
    [self.view setNeedsLayout];
    if (!self.isGroup) {
        self.brightSlider.value = self.selData.brightness;
        self.brightnessLabel.text = [NSString stringWithFormat:@"Brightness:%d",(int)self.brightSlider.value];
    }
}

-(void)backClick:(id)sender {
    [self.sendCmdTimer invalidate];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)logByte:(uint8_t *)bytes Len:(int)len Str:(NSString *)str
{
    NSMutableString *tempMStr=[[NSMutableString alloc] init];
    for (int i=0;i<len;i++)
        [tempMStr appendFormat:@"%0x  ",bytes[i]];
    NSLog(@"%@ == %@",str,tempMStr);
}

- (void)imageView:(DTColorPickerImageView *)imageView didPickColorWithColor:(UIColor *)color {
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:NULL];
    self.currentColorView.backgroundColor = color;
    
    if (self.isGroup) {
        if (self.groupAdr==0)
            return;
        [kCentralManager setLightOrGroupRGBWithDestinateAddress:self.groupAdr WithColorR:red WithColorG:green WithB:blue];
    }
    else
    {
        if (!self.selData)
            return;
        [kCentralManager setLightOrGroupRGBWithDestinateAddress:self.selData.u_DevAdress >> 8 WithColorR:red WithColorG:green WithB:blue];
    }
}

-(IBAction)brightValueChange:(UISlider *)sender {
    self.brightnessLabel.text = [NSString stringWithFormat:@"Brightness:%d",(int)sender.value];
    //    //应用层不做采样操作，SDK内部会根据OPCode进行采样，0.32秒发送一次数据，并且最后一个数据不会丢弃
    if (self.selData.stata==LightStataTypeOff&&sender.value>0) {
        [kCentralManager turnOnCertainLightWithAddress:self.selData.u_DevAdress];
    }
    if (self.isGroup) {
        if (self.groupAdr==0) return;
        uint32_t tem = 0;
        tem = ((self.groupAdr & 0xff) << 8)|((self.groupAdr >> 8) & 0xff);
        [kCentralManager setLightOrGroupLumWithDestinateAddress:tem WithLum:sender.value];
    } else {
        if (!self.selData) return;
        [kCentralManager setLightOrGroupLumWithDestinateAddress:self.selData.u_DevAdress WithLum:sender.value];
    }
}

-(IBAction)tempValueChange:(UISlider *)sender
{
    //应用层不做采样操作，SDK内部会根据OPCode进行采样，0.32秒发送一次数据，并且最后一个数据不会丢弃
    if (self.isGroup) {
        if (self.groupAdr==0) return;
        
        uint32_t tem = 0;
        tem = ((self.groupAdr & 0xff) << 8)|((self.groupAdr >> 8) & 0xff);
        [kCentralManager setCTOfLightWithDestinationAddress:tem AndCT:sender.value];
    } else {
        if (!self.selData)  return;
        [kCentralManager setCTOfLightWithDestinationAddress:self.selData.u_DevAdress AndCT:sender.value];
    }
}
- (IBAction)quit:(UIButton *)sender {
    NSLog(@"click kickout");
    [[BTCentralManager shareBTCentralManager]kickoutLightFromMeshWithDestinateAddress:self.selData.u_DevAdress];
    [[NSNotificationCenter defaultCenter] postNotificationName:RemoveDeviceKey object:nil userInfo:@{@"add": @(self.selData.u_DevAdress)}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}


-(IBAction)addToGroupClick:(id)sender
{
    ChooseGroupViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChooseGroupViewController"];
    vc.isRemove=NO;
    vc.selData=self.selData;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)removeFromGroupClick:(id)sender
{
    ChooseGroupViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChooseGroupViewController"];
    vc.isRemove=YES;
    vc.selData=self.selData;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)oTAClick:(id)sender{
    SingleOTAViewController *vc = [[SingleOTAViewController alloc] init];
    vc.u_address = self.selData.u_DevAdress;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end
