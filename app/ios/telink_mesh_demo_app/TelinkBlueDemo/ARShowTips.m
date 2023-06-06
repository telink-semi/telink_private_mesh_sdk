/********************************************************************************************************
 * @file     ARShowTips.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2016/7/27
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
