/********************************************************************************************************
 * @file     LogVC.m 
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
//  LogVC.m
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/3/23.
//  Copyright © 2017年 Green. All rights reserved.
//

#import "LogVC.h"
#import "DemoDefine.h"
@interface LogVC ()
@property (nonatomic, strong) UITextView *logText;
@property (nonatomic, strong) UIButton *btn;
@end

@implementation LogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self normalSetting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 89;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    [self.logText scrollRangeToVisible:NSMakeRange(self.logText.text.length - 1, 1)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)normalSetting {
    [self.view addSubview:self.logText];
    [self.view addSubview:self.btn];
    self.tabBarController.tabBar.hidden = YES;
    [self updateContent];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)updateContent {
    dispatch_queue_t quene = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL);
    dispatch_async(quene, ^{
        NSData *data = [NSData dataWithContentsOfFile:kDocumentFilePath(@"content")];
        //日志文件可能比较大，只显示最新的20K的log信息。
        NSString *str = @"";
        NSInteger length = 1024 * 20;
        if (data.length > length) {
            str = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(data.length - length, length)] encoding:NSUTF8StringEncoding];
        } else {
            str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.logText.text = str;
            self.logText.scrollsToTop = NO;
            [self.view setNeedsDisplay];
        });
    });
}

- (void)clearLocal {
    NSString *contentS = @"";
    NSData *tempda = [contentS dataUsingEncoding:NSUTF8StringEncoding];
    [tempda writeToFile:kDocumentFilePath(@"content") atomically:YES];
    [self updateContent];
}

#pragma mark - lazy
- (UIButton *)btn {
    if (!_btn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"Clear" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithRed:(69./255) green:137./255 blue:148./255 alpha:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn addTarget:self action:@selector(clearLocal) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-49, [UIScreen mainScreen].bounds.size.width, 49);
        _btn = btn;
    }
    return _btn;
}

- (UITextView *)logText {
    if (!_logText) {
        UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-89)];
        text.editable = NO;
        _logText.layoutManager.allowsNonContiguousLayout = YES;
        _logText = text;
    }
    return _logText;
}

@end
