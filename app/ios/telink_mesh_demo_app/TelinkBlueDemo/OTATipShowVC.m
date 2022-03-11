/********************************************************************************************************
 * @file     OTATipShowVC.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/4/12
 *
 * @par     Copyright (c) [2017], Telink Semiconductor (Shanghai) Co., Ltd. ("TELINK")
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

#import "OTATipShowVC.h"
#import "ShowTipModel.h"
@interface OTATipShowVC () <UITableViewDelegate, UITableViewDataSource>


@end

@implementation OTATipShowVC
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}
- (NSMutableArray<BTDevItem *> *)otaDevices {
    if (!_otaDevices) {
        _otaDevices = [[NSMutableArray alloc] init];
    }
    return _otaDevices;
}
- (NSMutableArray<NSString *> *)hasOTADevices {
    if (!_hasOTADevices) {
        _hasOTADevices = [[NSMutableArray alloc] init];
    }
    return _hasOTADevices;
}

- (BOOL)hasOTA:(NSString *)uuidstr {
    BOOL contain = NO;
    for (int j=0; j<self.hasOTADevices.count; j++) {
        if ([self.hasOTADevices[j] isEqualToString:uuidstr]) {
            contain = YES;
            break;
        }
    }
    return contain;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.datasource removeAllObjects];
    [self.tableview reloadData];
}
- (void)showTip:(NSString *)tip {
    ShowTipModel *model = [[ShowTipModel alloc] init];
    model.tip = tip;
    model.showColor = [tip isEqualToString:@"Send_Single_Finished"];
    [self.datasource addObject:model];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.datasource.count-1 inSection:0];
    [self.tableview insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:NO];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    ShowTipModel *model = self.datasource[indexPath.row];
    cell.textLabel.text = model.tip;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 26;
}
@end
