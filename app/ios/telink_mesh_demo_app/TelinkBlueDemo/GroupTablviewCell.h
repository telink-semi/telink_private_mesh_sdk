/********************************************************************************************************
 * @file     GroupTablviewCell.h 
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
//  GroupTablviewCell.h
//  TelinkBlueDemo
//
//  Created by Ken on 11/27/15.
//  Copyright © 2015 Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupTablviewCellDelegate <NSObject>
-(void)onGroupCellOnEvent:(id)sender;
-(void)onGroupCellOffEvent:(id)sender;
@end


@interface GroupTablviewCell : UITableViewCell

@property (nonatomic, assign) id<GroupTablviewCellDelegate> delegate;
@property(nonatomic,strong)  UILabel *titleLab;
@property(nonatomic,strong)  UIButton *onBtn;
@property(nonatomic,strong)  UIButton *offBtn;

@end
