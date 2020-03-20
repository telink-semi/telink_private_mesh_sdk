/********************************************************************************************************
 * @file     OTATipShowVC.h 
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
//  OTATipShowVC.h
//  TelinkBlueDemo
//
//  Created by Arvin on 2017/4/12.
//  Copyright © 2017年 Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoDefine.h"
@interface OTATipShowVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *datasource;
@property (strong, nonatomic) NSMutableArray <BTDevItem *> *otaDevices;
@property (strong, nonatomic) NSMutableArray <NSString *> *hasOTADevices;
@property (weak, nonatomic) IBOutlet UILabel *progressL;
@property (strong, nonatomic) BTDevItem *otaItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;
- (void)showTip:(NSString *)tip;
- (BOOL)hasOTA:(NSString *)uuidstr;
@end
