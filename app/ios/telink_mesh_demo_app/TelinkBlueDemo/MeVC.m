/********************************************************************************************************
 * @file     MeVC.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/11
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

#import "BTCentralManager.h"
#import "MeVC.h"
#import "UIWindow+ARShow.h"
#import "ParasEditVC.h"
#import "DemoDefine.h"

@interface MeVC () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray *datasource;
@property (assign, nonatomic) int index;
@property (strong, nonatomic) NSString *op;
@property (strong, nonatomic) NSString *vendorID;
@property (strong, nonatomic) NSMutableDictionary *localDic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *model;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
@end

@implementation MeVC


- (IBAction)Send:(UIButton *)sender {
    if (self.model.selectedSegmentIndex == 1) {
        ParasEditVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ParasEditVC"];
        vc.key = sender.titleLabel.text;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    NSDictionary *btndic = self.localDic[sender.titleLabel.text];
    Byte cmd[20] = {};
    Byte add[2] = {0xff, 0xff};
    memcpy(cmd + 5, add, sizeof(add));
    cmd[7] = strtoul([btndic[localOPStringKey] UTF8String], 0, 16);
    NSArray *v = [btndic[localVendorIDStringKey] componentsSeparatedByString:@" "];
    NSMutableArray *vs = [NSMutableArray arrayWithArray:v];
    for (int i = 0; i<v.count; i++) {
        if (!v[i]) {
            [vs removeObjectAtIndex:i];
        }
    }
    for (int i = 0; i<vs.count; i++) {
        cmd[i+8] = strtoul([vs[i] UTF8String], 0, 16);
    }
    
    NSArray *p = [btndic[localParasStringKey] componentsSeparatedByString:@" "];
    NSMutableArray *ps = [NSMutableArray arrayWithArray:p];
    for (int i = 0; i<p.count; i++) {
        if (!p[i]) {
            [ps removeObjectAtIndex:i];
        }
    }
    for (int j=0; j<ps.count; j++) {
        cmd[j+10] = strtoul([ps[j] UTF8String], 0, 16);
    }
    [[BTCentralManager shareBTCentralManager] sendCommand:cmd Len:20];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configUI];
}

- (void)configUI{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40 - self.tabBarController.tabBar.frame.size.height;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    for (UIButton *btn in self.btns) {
        btn.layer.cornerRadius = 43;
    }
}

- (NSMutableDictionary *)localDic {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:localCMDStringKey];
    if (!dic) {
        
        NSDictionary *paras = @{@"Auto" :        @"00 00 00 80 00 00 00 00 00 04",
                                @"Combo" :       @"00 00 00 70 00 00 00 00 00 04",
                                @"Steady" :      @"00 00 00 60 00 00 00 00 00 00",
                                @"Chasing" :     @"00 00 00 50 00 00 00 00 00 04",
                                @"Dual color" :  @"00 00 00 40 00 00 00 00 00 00",
                                @"Flash Whit" :  @"00 00 00 30 00 00 00 00 00 00",
                                @"Twinkling" :   @"00 00 00 20 00 00 00 00 00 00",
                                @"Fade" :        @"00 00 00 10 00 00 00 00 00 04",
                                @"ON/OFF" :      @"00 00 00 01 00 00 00 00 00 00",
                                };
        _localDic = [[NSMutableDictionary alloc] init];
        for (NSArray *key in paras.allKeys) {
            _localDic[key] = @{localOPStringKey : @"CA",
                               localVendorIDStringKey : @"11 02",
                               localParasStringKey : paras[key]
                               };
        }
        [[NSUserDefaults standardUserDefaults] setObject:_localDic forKey:localCMDStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        _localDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }
    return _localDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
