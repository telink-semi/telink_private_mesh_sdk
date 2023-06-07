/********************************************************************************************************
 * @file     ShareListViewController.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/22
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

#import "zipAndUnzip+zipString.h"
#import "zipAndUnzip.h"
#import "ShareListViewController.h"
#import "AppDelegate.h"
#import "ShareListCell.h"
#import "Transform.h"
#import "ShareListCell.h"
#import "ARScanView.h"
#import "ScanCodeVC.h"
#import "DemoDefine.h"
#import "UIImage+Extension.h"
#import "UIColor+Telink.h"

static NSString *simpleTableIdentifier = @"ShareListCell";

@interface ShareListViewController () 
{
    IBOutlet UIButton *leftBtn;
    IBOutlet UIButton *rightBtn;
    IBOutlet UILabel *shareTipsLbl;
    IBOutlet UIImageView *qrCodeImageV;
    
    __weak IBOutlet UILabel *shareLbl;
    UIView *bbackView;
    BOOL showSaoYiSao;
    CGFloat _oldBrightness;
}
@property (strong, nonatomic) ScanCodeVC *scanCodeVC;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ShareListViewController
- (instancetype)init {
    if (self =  [super init]) {
        showSaoYiSao = NO;
    }
    return self;
}

- (ScanCodeVC *)scanCodeVC {
    if (!_scanCodeVC) {
//        __weak typeof(self) weakSelf = self;
        _scanCodeVC = [ScanCodeVC scanCodeVC];
        __weak typeof(self) weakSelf = self;
        [_scanCodeVC scanDataViewControllerBackBlock:^(id content) {
            //AnalysisShareDataVC
            NSString *temps = content;
            
            unsigned long count = temps.length / 2;
            Byte byte[count];
            memset(byte, 0, count);
            for (int i = 0; i<count; i++) {
                NSString *bs = [temps substringWithRange:NSMakeRange(i*2, 2)];
                byte[i] = strtoul([bs UTF8String], 0, 16);
            }
            NSData *resultData = [NSData dataWithBytes:byte length:count];
            NSData *data = [zipAndUnzip gzipInflate:resultData];
            
            NSDictionary *dic;
            if ([data length]) {
                NSError *error = nil;
                dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            }else{
                //没有数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToMain" object:nil];
                return;
            }
            if (!([dic.allKeys containsObject:MeshName]&&
                  [dic.allKeys containsObject:DevicesInfo]&&
                  [dic.allKeys containsObject:MeshPassword])) {
                //信息不完整
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToMain" object:nil];
                return;
            }
            [[SysSetting shareSetting] addDevice:true
                                            Name:dic[MeshName]
                                             pwd:dic[MeshPassword]
                                         devices:dic[DevicesInfo]];
            [[SysSetting shareSetting] saveMeshInfoWithName:dic[MeshName] password:dic[MeshPassword] isCurrent:YES];
            weakSelf.UpdateMeshInfo(dic[MeshName], dic[MeshPassword]);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToMain" object:nil];
        }];
    }
    return _scanCodeVC;
}
- (void)showTips:(NSString *)content {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle: @"waring" message:content delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alertView show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _oldBrightness = UIScreen.mainScreen.brightness;
    [self configNavigation];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = true;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    [self clickMe:leftBtn];
    [[UIScreen mainScreen] setBrightness:1.0];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIScreen mainScreen] setBrightness:_oldBrightness];
}

- (void)configNavigation{
    
    [leftBtn setTitle:@"QR_Code" forState:UIControlStateNormal];
    [rightBtn setTitle:@"Scan" forState:UIControlStateNormal];
//    rightBtn.layer.cornerRadius = 4;
//    rightBtn.layer.masksToBounds = true;
    
    if ([[SysSetting shareSetting] currentMeshData]) {
        shareTipsLbl.text= @"扫一扫上面的二维码，可分享智能设备";
    }else{
        shareLbl.text = @"您还没有将设备分享给其他人";
    }
    
    self.title = @"分享控制";
    
}

- (IBAction)clickMe:(UIButton *)sender {
    showSaoYiSao = sender == leftBtn ? NO : YES;
    UIButton *temp = sender==leftBtn ? rightBtn : leftBtn;
    [sender setBackgroundColor:UIColor.telinkButtonBlue];
    [temp setBackgroundColor:[UIColor clearColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [temp setTitleColor:UIColor.telinkButtonBlue forState:UIControlStateNormal];
  [self updateUI];
}

-(void)updateUI {
    if (showSaoYiSao) {
        [self.navigationController pushViewController:self.scanCodeVC animated:YES];
        qrCodeImageV.hidden = YES;
    }else{
        //检索当前网络是否有数据
        if ([[SysSetting shareSetting] currentMeshData]) {
            //生成数据
            qrCodeImageV.image = [UIImage createQRImageWithData:[[SysSetting shareSetting] currentMeshData] rate:2];
            shareTipsLbl.hidden = YES;
            qrCodeImageV.hidden = NO;
        }else{
            qrCodeImageV.hidden = YES;
            shareTipsLbl.hidden = NO;
        }
    }
    shareLbl.hidden = qrCodeImageV.hidden;
    [qrCodeImageV setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)cancelToBack{
    [self.navigationController popToRootViewControllerAnimated:true];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
