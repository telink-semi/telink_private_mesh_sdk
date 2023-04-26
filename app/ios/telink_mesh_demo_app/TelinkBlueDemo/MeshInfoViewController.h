/********************************************************************************************************
 * @file     MeshInfoViewController.h 
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
//  MeshInfoViewController.h
//  TelinkBlueDemo
//
//  Created by Ken on 11/25/15.
//  Copyright © 2015 Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeshInfoViewController : UIViewController

@property (nonatomic,strong) IBOutlet UITextField *oNameTxt;
@property (nonatomic,strong) IBOutlet UITextField *oPasswordTxt;

@property (nonatomic,strong) IBOutlet UITextField *curNameTxt;
@property (nonatomic,strong) IBOutlet UITextField *curPasswordTxt;

//平常情况为80



-(IBAction)saveBtnClick:(id)sender;

@property (nonatomic, copy) void(^UpdateMeshInfo)(NSString *name, NSString *pwd);

@end
