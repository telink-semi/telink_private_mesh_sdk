/********************************************************************************************************
 * @file     ChooseGroupViewController.m 
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
//  ChooseGroupViewController.m
//  TelinkBlueDemo
//
//  Created by Ken on 11/30/15.
//  Copyright © 2015 Green. All rights reserved.
//

#import "ChooseGroupViewController.h"
#import "SysSetting.h"
#import "DeviceModel.h"
#import "BTCentralManager.h"
#import "BTDevItem.h"
#import "DemoDefine.h"
static NSUInteger addIndex;
@interface ChooseGroupViewController () <BTCentralManagerDelegate>
{
    SysSetting *selSetting;
}
@property (nonatomic,strong) NSMutableArray *showArray;
@property (nonatomic,strong) NSMutableArray *selectArray;
@property (nonatomic,strong) UITableView *grpTableView;
@end

@implementation ChooseGroupViewController

- (NSMutableArray *)showArray {
    if (!_showArray) {
        _showArray = [[NSMutableArray alloc] init];
    }
    return _showArray;
}

- (NSMutableArray *)selectArray{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect tempRect=[self.view bounds];
    tempRect.origin.y=64;
    tempRect.size.height=CGRectGetHeight(tempRect)-64;
    self.grpTableView=self.tableView;
    self.navigationItem.title = @"Group management";
    
    selSetting=[SysSetting shareSetting];
    
//    if (self.isRemove) {
        kCentralManager.delegate = self;
        [kCentralManager getGroupAddressWithDeviceAddress:self.selData.u_DevAdress];
//    }
//    else {
        [self.showArray addObjectsFromArray:selSetting.grpArrs];
        //不显示All Devices
        [self.showArray removeObjectAtIndex:0];
//    }
}




- (void)OnDevNotify:(id)sender Byte:(uint8_t *)byte {
    if (byte[7]==0xd4) {
        for (int j=0; j<4; j++) {
            if (byte[10+j]==0xff) break;
            switch (byte[10+j]) {
                case 1:
                    [self.selectArray addObject:[GroupInfo ItemWith:@"Living Room" Adr:0x8001]];
                    break;
                case 2:
                    [self.selectArray addObject:[GroupInfo ItemWith:@"Family Room" Adr:0x8002]];
                    break;
                case 3:
                    [self.selectArray addObject:[GroupInfo ItemWith:@"Kitchen" Adr:0x8003]];
                    break;
                case 4:
                    [self.selectArray addObject:[GroupInfo ItemWith:@"Bedroom" Adr:0x8004]];
                    break;
                default:
                    break;
            }
        }
        
        [self.tableView reloadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addGroupLightWithAdr:(int)addAdr IsAdd:(BOOL)isAdd
{
    uint8_t cmd[13]={0x11,0x71,0x11,0x00,0x00,0x66,0x00,0xd7,0x11,0x02,0x01,0x01,0x80};
    cmd[5]=(_selData.u_DevAdress>>8) & 0xff;
    cmd[6]=_selData.u_DevAdress & 0xff;
    
    cmd[11]=addAdr;
    
    if (isAdd)
    {
        cmd[10]=0x01;
        cmd[2]=cmd[2]+addIndex;
        if (cmd[2]==250) {
            cmd[2]=4;
        }
        
        addIndex++;
    }
    else
    {
        cmd[10]=0x00;
        cmd[2]=cmd[2]+addIndex;
        if (cmd[2]==250) {
            cmd[2]=1;
        }
        
        addIndex++;
    }
    
    [[BTCentralManager shareBTCentralManager] sendCommand:cmd Len:13];
}

-(BOOL)checkGrpInData:(int)grpData
{
    BOOL result=NO;
    for (int i=0;i<8;i++)
    {
        if (_selData->grpAdress[i]==grpData)
        {
            result=YES;
            break;
        }
    }
    return result;
}

-(NSArray *)getGrpArrWithAdr
{
    NSMutableArray *tempArrs=[[NSMutableArray alloc] init];
    for (GroupInfo *tempData in selSetting.grpArrs)
    {
        if  ([self checkGrpInData:tempData.grpAdr & 0xff])
            [tempArrs addObject:tempData];
    }
    return tempArrs;
}

#pragma mark - tableView Dada source /Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isRemove ? self.selectArray.count : self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdStr=@"tableCell";
    
    UITableViewCell *tempCell=[tableView dequeueReusableCellWithIdentifier:cellIdStr];
    if (!tempCell)
        tempCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdStr];
    
    GroupInfo *tempData;
    if (self.isRemove) {
        tempData = [self.selectArray objectAtIndex:indexPath.row];
        tempCell.textLabel.textColor = [UIColor blueColor];
    } else {
        tempData = [self.showArray objectAtIndex:indexPath.row];
        if ([self containsGroupModel:tempData]) {
            tempCell.textLabel.textColor = [UIColor blueColor];
        }
    }
    tempCell.textLabel.text=tempData.grpName;
    
    return tempCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupInfo *tempData;
    if (self.isRemove) {
        tempData = [self.selectArray objectAtIndex:indexPath.row];
    } else {
        tempData = [self.showArray objectAtIndex:indexPath.row];
    }

    int tempAdr=tempData.grpAdr & 0xff;
    if (tempAdr==0xff)
        return;
    if (_isRemove)
    {
//        if ([self.selData removeGrpAddressPro:tempAdr])
            [self addGroupLightWithAdr:tempAdr IsAdd:NO];
    }
    else
//加组的时候
        
    {
//        if ([self.selData addGrpAddressPro:tempAdr])
            NSLog(@"组的地址－－－－%d",tempAdr);
            [self addGroupLightWithAdr:tempAdr IsAdd:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)containsGroupModel:(GroupInfo *)model{
    BOOL tem = NO;
    for (GroupInfo *group in self.selectArray) {
        if (group.grpAdr == model.grpAdr) {
            tem = YES;
            break;
        }
    }
    return tem;
}

@end
