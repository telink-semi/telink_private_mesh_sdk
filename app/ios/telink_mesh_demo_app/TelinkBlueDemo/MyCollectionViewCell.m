/********************************************************************************************************
 * @file     MyCollectionViewCell.m 
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
//  MyCollectionViewCell.m
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

#import "MyCollectionViewCell.h"


@interface MyCollectionViewCell()
@end


@implementation MyCollectionViewCell
@synthesize imgView;
@synthesize titleLab;

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self != nil) {
        CGRect tempRect = CGRectMake(30, frame.size.height-15, frame.size.height-5, 20);
        self.titleLab=[[UILabel alloc] initWithFrame:tempRect];
        self.titleLab.tintColor = [UIColor grayColor];
        self.titleLab.textAlignment=NSTextAlignmentLeft;

        [self addSubview:self.titleLab];
        
        CGRect tempRect1 = CGRectMake(5, 0, frame.size.height-20, frame.size.height - 20);
        self.imgView=[[UIImageView alloc] initWithFrame:tempRect1];
        self.imgView.userInteractionEnabled = YES;
        [self addSubview:self.imgView];


    }
  
    return self;
}




@end
