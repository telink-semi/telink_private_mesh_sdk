/********************************************************************************************************
 * @file     MyCollectionViewCell.m 
 *
 * @brief    for TLSR chips
 *
 * @author   Telink, 梁家誌
 * @date     2017/12/19
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
