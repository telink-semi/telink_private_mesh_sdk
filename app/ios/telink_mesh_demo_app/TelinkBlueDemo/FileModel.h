/********************************************************************************************************
 * @file     FileModel.h 
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
//  FileModel.h
//  TelinkBlueDemo
//
//  Created by telink on 16/1/21.
//  Copyright © 2016年 Green. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject

@property(nonatomic,strong)NSString *flleName;

@property(nonatomic,strong)NSString *flleType;



@end