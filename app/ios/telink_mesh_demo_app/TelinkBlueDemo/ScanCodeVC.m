/********************************************************************************************************
 * @file     ScanCodeVC.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/19
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

#import "ScanCodeVC.h"
#import "ARScanView.h"
#import "DemoDefine.h"
@interface ScanCodeVC ()
@property (nonatomic, strong) ARScanView *scanView;
@end

@implementation ScanCodeVC
+ (instancetype)scanCodeVC {
    return [[self alloc] init];
}

- (void)scanDataViewControllerBackBlock:(void (^)(id content))block {
    self.scanCodeVCBlock = block;
}

- (ARScanView *)scanView {
    if (!_scanView) {
        __weak typeof(self) weakSelf = self;
        _scanView = [[ARScanView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.scanView scanDataViewBackBlock:^(id content) {
            if (weakSelf.scanCodeVCBlock) {
                weakSelf.scanCodeVCBlock(content);
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:SuccessScanQRCodeNotification
                                                                    object:weakSelf
                                                                  userInfo:@{ScanQRCodeMessageKey:content}];
            }
        }];
    }
    return _scanView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Scan";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.scanView];
    
}
- (void)backToMain{
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.scanView start];
    self.tabBarController.tabBar.hidden = true;
//    [[UIScreen mainScreen] setBrightness:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToMain) name:@"BackToMain" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    [self.scanView stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BackToMain" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.scanView stop];
}

@end
