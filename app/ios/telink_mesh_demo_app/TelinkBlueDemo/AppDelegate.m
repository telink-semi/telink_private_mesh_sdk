/********************************************************************************************************
 * @file     AppDelegate.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/3/19
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

#import "AppDelegate.h"

@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor=[UIColor whiteColor];
    self.window.rootViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootVC"];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma log信息控制按钮
- (UIButton *)logBtn {
    if (!kTestLog) return nil;
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logBtn setTitle:@"Log" forState:UIControlStateNormal];
        _logBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-89, [UIScreen mainScreen].bounds.size.width, 40);
        
        _logBtn.backgroundColor = [UIColor colorWithRed:(178./255) green:200./255 blue:187./255 alpha:1];
        _logBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [[UIApplication sharedApplication].windows[0] addSubview:_logBtn];
        
        [_logBtn addTarget:self action:@selector(showLogHH) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        [[BTCentralManager shareBTCentralManager] setPrintBlock:^(NSString *tip) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.logBtn setTitle:tip forState:UIControlStateNormal];
                [weakSelf.logBtn setNeedsDisplay];
            });
        }];
    }
    return _logBtn;
}

#pragma log按钮点击事件
- (void)showLogHH {
    _logBtn.selected = !_logBtn.selected;
    _logBtn.enabled = NO;
    if (_logBtn.selected) {
        self.logVC = [[LogVC alloc] init];
        UITabBarController *navi  = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [navi.selectedViewController pushViewController:self.logVC animated:YES];
    }else{
        [self.logVC.navigationController popViewControllerAnimated:YES];
    }
    //防止用户短时间多次点击按钮
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.logBtn.enabled = YES;
    });
}

@end
