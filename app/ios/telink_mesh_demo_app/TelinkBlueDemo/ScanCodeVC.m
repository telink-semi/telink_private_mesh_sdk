/********************************************************************************************************
 * @file     ScanCodeVC.m 
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
//  ScanCodeVC.m
//  telinkLight
//
//  Created by telink on 16/8/26.
//  Copyright © 2016年 xlink. All rights reserved.
//

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
