/********************************************************************************************************
 * @file     GroupVC.m 
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
//  GroupVC.m
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/4/11.
//  Copyright © 2017年 Green. All rights reserved.
//

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
