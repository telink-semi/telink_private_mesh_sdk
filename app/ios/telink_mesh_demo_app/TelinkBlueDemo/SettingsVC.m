/********************************************************************************************************
 * @file     SettingsVC.m
 *
 * @brief    A concise description.
 *
 * @author   Telink, 梁家誌
 * @date     2022/10/19
 *
 * @par     Copyright (c) [2022], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#import "SettingsVC.h"
#import <StoreKit/StoreKit.h>
#import "UIStoryboard+extension.h"

@interface SettingsVC ()<SKStoreProductViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray <NSString *>*source;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Settings";
    self.source = [NSMutableArray arrayWithArray:@[@"How to import bin file?", @"Get More Telink Apps"]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self configUIBarButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configUIBarButtonItem {
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"v%@", appVersion] style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)pushToTipsVC {
    UIViewController *vc = [UIStoryboard initVC:@"TipsVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToTelinkApps {
    //实现代理SKStoreProductViewControllerDelegate
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters: @{SKStoreProductParameterITunesItemIdentifier : @"1637594591"} completionBlock:^(BOOL result, NSError *error) {
        //回调
        if(error){
//            NSLog(@"错误%@",error);
//            [self showTips:@"Push to `Telink Apps` of App Store fail, please check the network!"];
            if (error.localizedDescription) {
                [self showTips:error.localizedDescription];
            } else {
                [self showTips:[NSString stringWithFormat:@"%@", error]];
            }
        }else{
            //AS应用界面
            if (@available(iOS 10.0, *)) {
            } else {
                [[UINavigationBar appearance] setTintColor:[UIColor blueColor]];
            }
            [self presentViewController:storeProductViewContorller animated:YES completion:nil];
        }
    }];
}

- (void)showTips:(NSString *)tips{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hits" message:tips preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击确认");
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.source[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 0) {
        [self pushToTipsVC];
    } else if (indexPath.row == 1) {
        [self pushToTelinkApps];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}

#pragma mark - SKStoreProductViewControllerDelegate

//取消按钮监听
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    if (@available(iOS 10.0, *)) {
    } else {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
