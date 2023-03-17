/********************************************************************************************************
 * @file     GroupVC.m 
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

#import "GroupVC.h"
#import "DemoDefine.h"
#import "GroupCell.h"
#import "SingleSettingViewController.h"

@interface GroupVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation GroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Group";
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
    
    //collectionView添加长按手势，进入设备详情
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableview addGestureRecognizer:longPress];
}

#pragma mark 长按进入设备详情手势
- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress {
    if (!kCentralManager.isLogin) return;
    if (longPress.state==UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:[longPress locationInView:self.tableview]];
        if (!self.tableview||!indexPath)  return;
        GroupInfo *info = [SysSetting shareSetting].grpArrs[indexPath.row];
        SingleSettingViewController *nextVC = [[SingleSettingViewController alloc] init];
        nextVC.isGroup = YES;
        nextVC.groupAdr = info.grpAdr;
        nextVC.groupName = info.grpName;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SysSetting shareSetting].grpArrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell"];
    GroupInfo *info = [SysSetting shareSetting].grpArrs[indexPath.row];
    cell.groupID = info.grpAdr;
    cell.textLabel.text = info.grpName;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
@end
