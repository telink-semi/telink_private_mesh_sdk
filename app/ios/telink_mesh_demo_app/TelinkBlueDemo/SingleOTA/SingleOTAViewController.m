/********************************************************************************************************
 * @file     SingleOTAViewController.m
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2018/7/31
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

#import "SingleOTAViewController.h"
#import "OTAFileSource.h"
#import "UIViewController+Message.h"
#import "ChooseBinCell.h"
#import "BTCentralManager.h"
#import "OTAManager.h"
#import "DemoDefine.h"

//app通用蓝色
#define kDefultColor [UIColor colorWithRed:0x4A/255.0 green:0x87/255.0 blue:0xEE/255.0 alpha:1]
#define CellIdentifiers_ChooseBinCellID  @"ChooseBinCell"

@interface SingleOTAViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *otaButton;
@property (weak, nonatomic) IBOutlet UILabel *otaTipsLabel;
@property (nonatomic,strong) NSMutableArray <NSString *>*source;
@property (nonatomic, assign) int selectIndex;
@property (nonatomic, assign) BOOL OTAing;
@property (nonatomic, strong) NSData *localData;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *unableColor;

@end

@implementation SingleOTAViewController

- (IBAction)clickStartOTA:(UIButton *)sender {
    if (self.OTAing) {
        return;
    }
    if (self.selectIndex == -1) {
        [self showTips:@"Please choose Bin file."];
        return;
    }else{
        self.localData = [OTAFileSource.share getDataWithBinName:self.source[self.selectIndex]];
    }
    
    [BTCentralManager.shareBTCentralManager printContentWithString:@"clickStartOTA"];
    self.OTAing = YES;
    self.otaButton.backgroundColor = self.unableColor;
    self.tableView.userInteractionEnabled = NO;
    [self showOTATips:@"start connect and read fireWare..."];
    
    __weak typeof(self) weakSelf = self;
    BOOL result = [OTAManager.share startOTAWithOtaData:self.localData addressNumbers:@[@(self.u_address)] singleSuccessAction:^(NSNumber * _Nonnull address) {
        [weakSelf otaSuccessAction];
    } singleFailAction:^(NSNumber * _Nonnull address) {
        [weakSelf otaFailAction];
    } singleProgressAction:^(float progress) {
        [weakSelf showOTAProgress:progress];
    } finishAction:^(NSArray<NSNumber *> * _Nonnull successNumbers, NSArray<NSNumber *> * _Nonnull fileNumbers) {
        NSLog(@"");
    }];
    NSLog(@"result = %d",result);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = -1;
    self.OTAing = NO;
    self.normalColor = kDefultColor;
    self.unableColor = [UIColor colorWithRed:185.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1.0];
    self.title = @"OTA";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifiers_ChooseBinCellID bundle:nil] forCellReuseIdentifier:CellIdentifiers_ChooseBinCellID];
    self.source = [[NSMutableArray alloc] initWithArray:OTAFileSource.share.getAllBinFile];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [OTAManager.share stopOTA];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configLogButton];
}

- (void)configLogButton{
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
    [self.view setNeedsLayout];
}


- (void)showOTAProgress:(float)progress{
    NSString *tips = [NSString stringWithFormat:@"OTA:%.1f%%", progress];
    if (progress == 100) {
        tips = [tips stringByAppendingString:@",reboot..."];
    }
    [self showOTATips:tips];
}

- (void)showTips:(NSString *)message{
    [self showAlertSureWithTitle:@"Hits" message:message sure:^(UIAlertAction *action) {
        
    }];
}

- (void)showOTATips:(NSString *)message{
    self.otaTipsLabel.text = message;
}

- (void)otaSuccessAction{
    self.OTAing = NO;
    [self showTips:@"OTA success"];
    self.otaButton.backgroundColor = self.normalColor;
    self.tableView.userInteractionEnabled = YES;
    [self showOTATips:@"OTA success"];
    //    [self.ble setNormalState];
    [BTCentralManager.shareBTCentralManager printContentWithString:@"otaSuccess"];
}

- (void)otaFailAction{
    self.OTAing = NO;
    [self showTips:@"OTA fail"];
    self.otaButton.backgroundColor = self.normalColor;
    self.tableView.userInteractionEnabled = YES;
    [self showOTATips:@"OTA fail"];
    //    [self.ble setNormalState];
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    [BTCentralManager.shareBTCentralManager printContentWithString:@"otaFail"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseBinCell *cell = (ChooseBinCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifiers_ChooseBinCellID forIndexPath:indexPath];
    NSString *binString = self.source[indexPath.row];
    cell.nameLabel.text = binString;
    cell.selectButton.selected = indexPath.row == self.selectIndex;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.source.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.selectIndex) {
        self.selectIndex = -1;
    } else {
        self.selectIndex = (int)indexPath.row;
    }
    [self.tableView reloadData];
}

-(void)dealloc{
    NSLog(@"");
}

@end
