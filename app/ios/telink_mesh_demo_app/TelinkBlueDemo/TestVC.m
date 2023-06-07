/********************************************************************************************************
 * @file     TestVC.m
 *
 * @brief    A concise description.
 *
 * @author   Telink, 梁家誌
 * @date     2020/5/21
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
 *******************************************************************************************************///

#import "TestVC.h"
#import "BTCentralManager.h"
#import "DeviceModel.h"
#import "UIAlertView+Extension.h"
#import "Transform.h"

@interface TestVC ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Test";
}

- (void)showTip:(NSString *)tip {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:tip delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(delayHidden:) withObject:alert afterDelay:1.5];
}

- (void)delayHidden:(UIAlertView *)a {
    [a dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Add device";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"offline device";
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"Test - Add 50 devices";
    } else if (indexPath.row == 3) {
       cell.textLabel.text = @"Test - offline 50 devices";
   }
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 0) {
        [self clickAddDevice];
    } else if (indexPath.row == 1) {
        [self clickOutlineDevice];
    } else if (indexPath.row == 2) {
        [self clickTestAddDevices];
    } else if (indexPath.row == 3) {
       [self clickTestOutlineDevices];
   }
}

- (void)clickAddDevice {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hits" message:@"Please input parameters of command, eg: 050164FF060164FF0000" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *firstTextField = alertController.textFields.firstObject;
        firstTextField.text = [weakSelf handleStringByRemoveAllSapceAndNewlines:firstTextField.text];
        if (firstTextField.text.length == 0 || firstTextField.text.length % 2 != 0) {
            [weakSelf showTip:@"Please input right command!"];
            return;
        }
        NSString *commandString = [@"11111200000000dc1102" stringByAppendingString:firstTextField.text];
        NSData *commandData = [Transform nsstringToHex:commandString];
        uint8_t *cmd = (uint8_t *)commandData.bytes;
        [BTCentralManager.shareBTCentralManager sendCommandWithoutCMDInterval:cmd Len:(int)commandData.length];
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Hex's length is 1~10.";
        textField.text = @"050164FF060164FF0000";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)clickOutlineDevice {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hits" message:@"Please input parameters of command, eg: 050064FF060064FF0000" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *firstTextField = alertController.textFields.firstObject;
        firstTextField.text = [weakSelf handleStringByRemoveAllSapceAndNewlines:firstTextField.text];
        if (firstTextField.text.length == 0 || firstTextField.text.length % 2 != 0) {
            [weakSelf showTip:@"Please input right command!"];
            return;
        }
        NSString *commandString = [@"11111200000000dc1102" stringByAppendingString:firstTextField.text];
        NSData *commandData = [Transform nsstringToHex:commandString];
        uint8_t *cmd = (uint8_t *)commandData.bytes;
        [BTCentralManager.shareBTCentralManager sendCommandWithoutCMDInterval:cmd Len:(int)commandData.length];
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Hex's length is 1~10.";
        textField.text = @"050064FF060064FF0000";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)clickTestAddDevices {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Add 50 devices?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            DeviceModel *model = [[DeviceModel alloc] init];
            model.u_DevAdress = (0x80 + i) << 8;
            model.stata = LightStataTypeOn;
            model.brightness = 100;
            [array addObject:model];
        }
        [BTCentralManager.shareBTCentralManager addNewDeviceModelsToOnlineStatusTable:array];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)clickTestOutlineDevices {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Offline 50 devices?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < 50; i++) {
            DeviceModel *model = [[DeviceModel alloc] init];
            model.u_DevAdress = (0x80 + i) << 8;
            model.stata = LightStataTypeOutline;
            model.brightness = 100;
            [array addObject:model];
        }
        [BTCentralManager.shareBTCentralManager addNewDeviceModelsToOnlineStatusTable:array];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:true completion:nil];
}

//大写并去空格
- (NSString *)handleStringByRemoveAllSapceAndNewlines:(NSString *)str {
    NSString *tem = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    tem = [tem stringByReplacingOccurrencesOfString:@" " withString:@""];
    tem = tem.uppercaseString;
    return tem;
}


@end
