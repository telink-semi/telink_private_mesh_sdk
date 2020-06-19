/********************************************************************************************************
 * @file     AppDelegate.m 
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
//  AppDelegate.m
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

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
