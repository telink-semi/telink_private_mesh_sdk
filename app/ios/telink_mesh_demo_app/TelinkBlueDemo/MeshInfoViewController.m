/********************************************************************************************************
 * @file     MeshInfoViewController.m
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
//  MeshInfoViewController.m
//  TelinkBlueDemo
//
//  Created by Ken on 11/25/15.
//  Copyright © 2015 Green. All rights reserved.
//

#import "MeshInfoViewController.h"
#import "BTCentralManager.h"
#import "SysSetting.h"
#import "AppDelegate.h"
#import "ARMainVC.h"
#import "DemoDefine.h"
#import "ShareListViewController.h"
#import "MeshItemCell.h"
#import "UIButton+extension.h"

@interface MeshInfoViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *datasource;
@end

@implementation MeshInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 16;
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.oNameTxt.delegate = self;
    self.oPasswordTxt.delegate = self;
    [self.curNameTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.curPasswordTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.oNameTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.oPasswordTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self fillData];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MeshItemCell" bundle:nil] forCellReuseIdentifier:@"MeshItemCell"];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[BTCentralManager shareBTCentralManager] stopScan];
    self.tabBarController.tabBar.hidden = YES;
    CGRect rect = kDelegate.logBtn.frame;
    CGFloat h = SCREEN_HEIGHT - 40;
    kDelegate.logBtn.frame = CGRectMake(rect.origin.x, h, rect.size.width, rect.size.height);
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] initWithArray:[[SysSetting shareSetting] localData].allKeys];
    }
    return _datasource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeshItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeshItemCell"];
    NSString *curMeshKey = self.datasource[indexPath.row];
    NSString *oldMeshKey = [NSString stringWithFormat:@"%@+%@",[SysSetting shareSetting].currentUserName,[SysSetting shareSetting].currentUserPassword];
    NSString *tip = [NSString stringWithFormat:@"本地网络 %ld: %@",(long)indexPath.row,curMeshKey];
    cell.titleLabel.text = tip;
    cell.frashButton.hidden = [curMeshKey isEqualToString:oldMeshKey];
    __weak typeof(self) weakSelf = self;
    [cell.frashButton addAction:^(UIButton *button) {
        NSArray *info = [curMeshKey componentsSeparatedByString:@"+"];
        [weakSelf.datasource removeObjectAtIndex:indexPath.row];
        [[SysSetting shareSetting] addMesh:NO Name:info.firstObject pwd:info.lastObject];
        [weakSelf.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
        NSString *showOldMeshKey = [NSString stringWithFormat:@"%@+%@",weakSelf.oNameTxt.text,weakSelf.oPasswordTxt.text];
        if ([showOldMeshKey isEqualToString:curMeshKey]) {
            [weakSelf updateOMeshInfo:oldMeshKey];
        }
        if (weakSelf.UpdateMeshInfo) {
            weakSelf.UpdateMeshInfo(weakSelf.oNameTxt.text, weakSelf.oPasswordTxt.text);
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self updateOMeshInfo:self.datasource[indexPath.row]];
    [self.tableView reloadData];
}

- (void)updateOMeshInfo:(NSString *)meshinfo {
    NSLog(@"updateOMeshInfo = %@",meshinfo);
    NSArray *info = [meshinfo componentsSeparatedByString:@"+"];
    self.curNameTxt.text = info.firstObject;
    self.curPasswordTxt.text = info.lastObject;
}

- (IBAction)clearLocalData:(UIButton *)sender {
    if ([SysSetting shareSetting].currentUserName.length > 0 &&
        [SysSetting shareSetting].currentUserPassword.length > 0) {
        [[SysSetting shareSetting] addMesh:NO Name:[SysSetting shareSetting].currentUserName pwd:[SysSetting shareSetting].currentUserPassword];
        if ([SysSetting shareSetting].localData.allKeys.count<1) {
            [[SysSetting shareSetting] saveMeshInfoWithName:@"telink_mesh1" password:@"123" isCurrent:YES];
            [[SysSetting shareSetting] saveMeshInfoWithName:@"" password:@"" isCurrent:NO];
            [[SysSetting shareSetting] addMesh:YES Name:@"telink_mesh1" pwd:@"123"];
            self.oNameTxt.text = @"";
            self.oPasswordTxt.text = @"";
        }

        _datasource = nil;
        [self datasource];
        
        NSString *meshinfo = self.datasource.firstObject;
        NSArray *info = [meshinfo componentsSeparatedByString:@"+"];
        [SysSetting shareSetting].currentUserName = info.firstObject;
        [SysSetting shareSetting].currentUserPassword = info.lastObject;
        [[SysSetting shareSetting] saveMeshInfoWithName:info.firstObject password:info.lastObject isCurrent:YES];

        [self updateOMeshInfo:meshinfo];
        _datasource = nil;
        [self datasource];
        [self.tableView reloadData];
        
        if (self.UpdateMeshInfo) {
            self.UpdateMeshInfo(self.oNameTxt.text, self.oPasswordTxt.text);
        }
    }
}

- (IBAction)shareLocalData:(UIButton *)sender {
    ShareListViewController *tempCon= [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ShareListViewController"];
    tempCon.UpdateMeshInfo = self.UpdateMeshInfo;
    [self.navigationController pushViewController:tempCon animated:true];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

-(NSString *)getNonullStr:(NSString *)getStr
{
    if (!getStr || getStr.length<1)
        return @"";
    
    return getStr;
}

-(void)fillData {
    [self.curNameTxt setText:[SysSetting shareSetting].currentUserName];
    [self.curPasswordTxt setText:[SysSetting shareSetting].currentUserPassword];
    [self.oNameTxt setText:[SysSetting shareSetting].oldUserName];
    [self.oPasswordTxt setText:[SysSetting shareSetting].oldUserPassword];
}

-(void)saveData {
    SysSetting *selSeting=[SysSetting shareSetting];
    selSeting.oldUserName=[self.oNameTxt text];
    selSeting.oldUserPassword=[self.oPasswordTxt text];
    selSeting.currentUserName=[self.curNameTxt text];
    selSeting.currentUserPassword=[self.curPasswordTxt text];
//    if (self.oNameTxt.text.length && self.oPasswordTxt.text.length) {
//        [[SysSetting shareSetting] addMesh:true Name:self.oNameTxt.text pwd:self.oPasswordTxt.text];
//    }
    if (self.curNameTxt.text.length && self.curPasswordTxt.text.length) {
        [[SysSetting shareSetting] addMesh:true Name:self.curNameTxt.text pwd:self.curPasswordTxt.text];
    }
    [[SysSetting shareSetting] saveMeshInfoWithName:self.oNameTxt.text password:self.oPasswordTxt.text isCurrent:NO];
    [[SysSetting shareSetting] saveMeshInfoWithName:self.curNameTxt.text password:self.curPasswordTxt.text isCurrent:YES];
}

- (BOOL)verifyIputVaild {
    if (self.curNameTxt.text.length > 0 && self.curPasswordTxt.text.length > 0) {
        NSData *nnameData = [self.curNameTxt.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *npasswordData = [self.curPasswordTxt.text dataUsingEncoding:NSUTF8StringEncoding];
        
        if (nnameData.length > 16) {
            [self showTip:@"输入不合法：当前meshName长度大于16字节."];
            return NO;
        }
        if (npasswordData.length > 16) {
            [self showTip:@"输入不合法：当前meshPassword长度大于16字节."];
            return NO;
        }
    }
    if (self.oNameTxt.text.length > 0 && self.oPasswordTxt.text.length > 0) {
        NSData *onameData = [self.oNameTxt.text dataUsingEncoding:NSUTF8StringEncoding];
        NSData *opasswordData = [self.oPasswordTxt.text dataUsingEncoding:NSUTF8StringEncoding];
        if (onameData.length > 16) {
            [self showTip:@"输入不合法：添加设备meshName长度大于16字节."];
            return NO;
        }
        if (opasswordData.length > 16) {
            [self showTip:@"输入不合法：添加设备meshPassword长度大于16字节."];
            return NO;
        }
    }
    //mesh信息不完整判断
    if ((self.curNameTxt.text.length > 0) ^ (self.curPasswordTxt.text.length > 0)) {
        [self showTip:@"输入不合法：当前mesh信息输入不完整。"];
        return NO;
    }
    if ((self.oNameTxt.text.length > 0) ^ (self.oPasswordTxt.text.length > 0)) {
        [self showTip:@"输入不合法：添加设备的mesh信息输入不完整。"];
        return NO;
    }
    if ([self.oNameTxt.text isEqualToString:self.curNameTxt.text]) {
        [self showTip:@"输入不合法：前后meshName不能相同。"];
        return NO;
    }
    if ([self.curNameTxt.text isEqualToString:self.curPasswordTxt.text] && self.curNameTxt.text.length > 0) {
        [self showTip:@"输入不合法：meshName与meshPassword不能相同。"];
        return NO;
    }
    if (self.curNameTxt.text.length < 1||
        self.curPasswordTxt.text.length < 1 ||
        [self.oPasswordTxt.text containsString:@"+"] ||
        [self.oNameTxt.text containsString:@"+"] ||
        [self.curNameTxt.text containsString:@"+"] ||
        [self.curPasswordTxt.text containsString:@"+"] ||
        [self.oPasswordTxt.text containsString:@" "] ||
        [self.oNameTxt.text containsString:@" "] ||
        [self.curNameTxt.text containsString:@" "] ||
        [self.curPasswordTxt.text containsString:@" "]){
        [self showTip:@"输入不合法：不能包含+、空格特殊字符"];
        return NO;
    }
    return YES;
}

- (void)showTip:(NSString *)tip {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tip delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(delayHidden:) withObject:alert afterDelay:1.5];
}

- (void)delayHidden:(UIAlertView *)a {
    [a dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)saveBtnClick:(id)sender {
    if (![self verifyIputVaild]) {
//        [self showTip:@"输入不合法：不能包含+、空格特殊字符,名字和密码不能一致"];
        return;
    }
    [self saveData];
    if (self.UpdateMeshInfo) {
        self.UpdateMeshInfo(self.oNameTxt.text, self.oPasswordTxt.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextField限制字符串长度 字符数

#define MAXLENGTH (16)// MAXLENGTH为最大字数
- (void)textFieldDidChange:(id)sender {
    if ([self unicodeLengthOfString:self.curNameTxt.text] > MAXLENGTH) {
        //超出限制字数时所要做的事
        self.curNameTxt.text = [self cutDownString:self.curNameTxt.text byUnicodeLength:MAXLENGTH];
        [self.curNameTxt resignFirstResponder];
        [self showTip:@"输入不合法：当前meshName长度大于16字节."];
    }
    if ([self unicodeLengthOfString:self.curPasswordTxt.text] > MAXLENGTH) {
        //超出限制字数时所要做的事
        self.curPasswordTxt.text = [self cutDownString:self.curPasswordTxt.text byUnicodeLength:MAXLENGTH];
        [self.curPasswordTxt resignFirstResponder];
        [self showTip:@"输入不合法：当前meshPassword长度大于16字节."];
    }
    if ([self unicodeLengthOfString:self.oNameTxt.text] > MAXLENGTH) {
        //超出限制字数时所要做的事
        self.oNameTxt.text = [self cutDownString:self.oNameTxt.text byUnicodeLength:MAXLENGTH];
        [self.oNameTxt resignFirstResponder];
        [self showTip:@"输入不合法：添加设备的meshName长度大于16字节."];
    }
    if ([self unicodeLengthOfString:self.oPasswordTxt.text] > MAXLENGTH) {
        //超出限制字数时所要做的事
        self.oPasswordTxt.text = [self cutDownString:self.oPasswordTxt.text byUnicodeLength:MAXLENGTH];
        [self.oPasswordTxt resignFirstResponder];
        [self showTip:@"输入不合法：添加设备的meshPassword长度大于16字节."];
    }
}

//按照中文两个字符，英文数字一个字符计算字符数
- (NSUInteger)unicodeLengthOfString:(NSString *)text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (NSString *)cutDownString:(NSString *)text byUnicodeLength:(NSInteger)unicodeLength {
    NSUInteger asciiLength = 0;
    NSString *tem = @"";
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        int length = isascii(uc) ? 1 : 2;
        asciiLength += length;
        if (asciiLength > unicodeLength) {
            break;
        } else {
            tem = [text substringWithRange:NSMakeRange(0, i+1)];
        }
    }
    return tem;
}

@end
