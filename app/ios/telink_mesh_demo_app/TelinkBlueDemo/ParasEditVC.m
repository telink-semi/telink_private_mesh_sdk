/********************************************************************************************************
 * @file     ParasEditVC.m 
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

#import "ParasEditVC.h"
#import "UIWindow+ARShow.h"
#import "MeVC.h"
@interface ParasEditVC ()
@property (weak, nonatomic) IBOutlet UITextField *optext;
@property (weak, nonatomic) IBOutlet UITextField *vendorIDText;
@property (weak, nonatomic) IBOutlet UITextField *parasText;
@property (weak, nonatomic) IBOutlet UILabel *modelText;

@end


@implementation ParasEditVC
- (void)clickV:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.modelText.text = self.key;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickV:)];

    [self.view addGestureRecognizer:g];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:localCMDStringKey];
    if (![dic.allKeys containsObject:self.key]){
        NSDictionary *cmds = @{@"Auto" :        @"00 00 00 80 00 00 00 00 00 04",
                               @"Combo" :       @"00 00 00 70 00 00 00 00 00 04",
                               @"Steady" :      @"00 00 00 60 00 00 00 00 00 00",
                               @"Chasing" :     @"00 00 00 50 00 00 00 00 00 04",
                               @"Dual color" :  @"00 00 00 40 00 00 00 00 00 00",
                               @"Flash Whit" :  @"00 00 00 30 00 00 00 00 00 00",
                               @"Twinkling" :   @"00 00 00 20 00 00 00 00 00 00",
                               @"Fade" :        @"00 00 00 10 00 00 00 00 00 04",
                               @"ON/OFF" :      @"00 00 00 01 00 00 00 00 00 00",
                               };
        NSDictionary *tempdic = @{localParasStringKey : cmds[self.key],
                                  localOPStringKey : @"CA",
                                  localVendorIDStringKey : @"11 02"
                                  };
        NSMutableDictionary *updic = [[NSMutableDictionary alloc] initWithDictionary:dic];
        updic[self.key] = tempdic;
        dic = updic;
        [[NSUserDefaults standardUserDefaults] setObject:updic forKey:localCMDStringKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.optext.text = dic[self.key][localOPStringKey];
    self.vendorIDText.text = dic[self.key][localVendorIDStringKey];
    self.parasText.text = dic[self.key][localParasStringKey];
}
- (IBAction)save:(id)sender {
    if ([self saveData]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (BOOL)saveData {
    if (![self verifyCMD]) {
        kWindowShow(@"输入不合法");
        return NO;
    }
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:localCMDStringKey];
    NSDictionary *currentdic = @{localParasStringKey : self.parasText.text,
                                 localOPStringKey : self.optext.text,
                                 localVendorIDStringKey : self.vendorIDText.text
                                 };
    NSMutableDictionary *mudic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    mudic[self.key] = currentdic;
    [[NSUserDefaults standardUserDefaults] setObject:mudic forKey:localCMDStringKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}
- (BOOL)verifyCMD {
    NSString *comps = @"1234567890abcdefABCDEF ";
    for (int i = 0; i < self.parasText.text.length; i++) {
        NSString *s = [self.parasText.text substringWithRange:NSMakeRange(i, 1)];
        if (![comps containsString:s]) {
            return NO;
        }
    }
    for (int i = 0; i < self.optext.text.length; i++) {
        NSString *s = [self.optext.text substringWithRange:NSMakeRange(i, 1)];
        if (![comps containsString:s]) {
            return NO;
        }
    }
    for (int i = 0; i < self.vendorIDText.text.length; i++) {
        NSString *s = [self.vendorIDText.text substringWithRange:NSMakeRange(i, 1)];
        if (![comps containsString:s]) {
            return NO;
        }
    }
    
    NSArray *p = [self.parasText.text componentsSeparatedByString:@" "];
    NSMutableArray *ps = [NSMutableArray arrayWithArray:p];
    for (int i = 0; i<p.count; i++) {
        if (!p[i]||[ps[i] isEqualToString:@""]) {
            [ps removeObjectAtIndex:i];
        }
        if ([ps[i] length] > 2) {
            return NO;
        }
    }
    if (ps.count > 10) {
        return NO;
    }else{
        for (NSUInteger i = (10 - ps.count); i>0; i--) {
            [ps addObject:@"0"];
        }
        self.parasText.text = [ps componentsJoinedByString:@" "];
    }
    NSArray *v = [self.vendorIDText.text componentsSeparatedByString:@" "];
    NSMutableArray *vs = [NSMutableArray arrayWithArray:v];
    for (int i = 0; i<v.count; i++) {
        if (!v[i]) {
            [vs removeObjectAtIndex:i];
        }
        if ([v[i] length] > 2) {
            return NO;
        }
    }
    if (vs.count > 2) {
        return NO;
    }
    if (self.optext.text.length > 2) {
        return NO;
    }
    
    return YES;
}
@end
