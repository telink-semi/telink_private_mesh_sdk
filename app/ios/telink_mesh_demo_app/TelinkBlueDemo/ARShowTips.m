/********************************************************************************************************
 * @file     ARShowTips.m 
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
//  ShowTips.m
//  Device-Blue-T
//
//  Created by Arvin on 2016/7/27.
//  Copyright © 2017年 Arvin. All rights reserved.
//

#import "ARShowTips.h"
#define SYSTEM_VERSION_VALUE ([[UIDevice currentDevice] systemVersion].floatValue)
#define SYSTEM_VERSION_BELOW_9 (SYSTEM_VERSION_VALUE < 9)
#define kEndTimer(timer) \
if (timer) { \
/*ARLog(@"%@挂掉",timer)*/\
[timer invalidate]; \
timer = nil; \
}
@interface ARShowTips ()
@property (nonatomic, strong) NSTimer *showTimer;
@property (nonatomic, weak) UIAlertView *alert;
@property (nonatomic, weak) UIAlertController *alertVC;
@end
@implementation ARShowTips
static ARShowTips *showTip = nil;
+ (instancetype)shareTips {
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        showTip = [[ARShowTips alloc] init];
    });
    return showTip;
}

- (void)alertShowTips:(NSString *)tips cancelBlock:(void (^)(void))cancelBlcok doBlcok:(void (^)(void))doBlock {
    if (!SYSTEM_VERSION_BELOW_9) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:tips preferredStyle:UIAlertControllerStyleAlert];
        self.alertVC = alertC;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
        UIAlertAction *cancleA = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            cancelBlcok();
        }];
        UIAlertAction *doA = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            doBlock();
        }];
        [alertC addAction:cancleA];
        [alertC addAction:doA];
    }
}
- (void (^)(NSString *tips))alertShow {
    return ^(NSString *tips) {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:tips delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alertV show];
        self.alert = alertV;
        [self performSelector:@selector(missTipsView:) withObject:alertV afterDelay:RemoveTipVDelay];
    };
}
- (void (^)(void))alertHidden {
    return ^() {
        if (self.alert) {
            [self.alert dismissWithClickedButtonIndex:0 animated:NO];
            self.alert = nil;
        }
    };
}
- (void (^)(void))alertVCHidden {
    return ^() {
        if (self.alertVC) {
            [self.alertVC dismissViewControllerAnimated:NO completion:nil];
            self.alertVC = nil;
        }
    };
}

- (void)missTipsView:(id)view {
    if ([view isKindOfClass:[UIAlertView class]]) {
        UIAlertView *alert = (UIAlertView *)view;
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }else if ([view isKindOfClass:[UIAlertController class]]) {
        UIAlertController *alert = (UIAlertController *)view;
        [alert dismissViewControllerAnimated:YES completion:nil];
    }
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window setNeedsDisplay];
}

- (instancetype (^)(NSString *tip))showTip {
    return ^(NSString *tip) {
        kEndTimer(self.showTimer);
        UIWindow *window = [UIApplication sharedApplication].windows[0];
        if (!self.showTipsView.activity.isAnimating) {
            ARShowTipsView *st = [[ARShowTipsView alloc] initFrame];
            st.bounds = CGRectMake(0, 0, 240, 240);
            st.center = window.center;
            self.showTipsView = st;
            self.showTipsView.center = window.center;
            [window addSubview:self.showTipsView];
            [self.showTipsView.activity startAnimating];
        }
        self.showTipsView.tipLab.text = tip;
        [self.showTipsView setNeedsDisplay];
//        self.delayHidden(1.5);
        return self;
    };
}
- (instancetype (^)(void))hidden {
    return ^() {
        [self performSelectorOnMainThread:@selector(removeOnMain) withObject:nil waitUntilDone:YES];
        return self;
    };
}
- (void)removeOnMain {
    [self.showTipsView removeFromSuperview];
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window setNeedsDisplay];
}
- (instancetype(^)(void))timeOut {
    return ^() {
        self.showTipsView.tipLab.text = @"Time out";
        [self.showTipsView.activity stopAnimating];
        [self.showTipsView setNeedsDisplay];
        self.delayHidden(1.);
        return self;
    };
}
- (instancetype (^)(NSTimeInterval t))delayHidden {
    return ^ ARShowTips * (NSTimeInterval t){
        self.showTimer = [NSTimer scheduledTimerWithTimeInterval:t target:self selector:@selector(hiddenOnMain) userInfo:nil repeats:NO];
        return self;
    };
}
- (void)hiddenOnMain {
    kEndTimer(self.showTimer);
    [self performSelectorOnMainThread:@selector(hiddenDo) withObject:nil waitUntilDone:YES];
}
- (void)hiddenDo {
    self.hidden();
    
}
@end
