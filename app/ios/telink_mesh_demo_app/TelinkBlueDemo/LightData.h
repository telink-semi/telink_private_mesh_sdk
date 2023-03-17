/********************************************************************************************************
 * @file     LightData.h 
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
//  LightData.h
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LightData : NSObject
{
    uint32_t macAdress;
    uint32_t devAress;//地址
    uint32_t devAressPer;//一个字节地址
    int lightStatus;//0-离线  1-灯灭  2-灯亮
    int comStartAdress;
    int bright;
    int colorTel;//色温
    UIColor *color;
    NSString *music;
    id devItem;
    BOOL isGetStatus;
    
@public
    int grpAdress[8];
}
@property (nonatomic, assign) uint32_t devAress;
@property (nonatomic, assign) int comStartAdress;
@property (nonatomic, assign) uint32_t devAressPer;
@property (nonatomic, assign) uint32_t macAdress;
@property (nonatomic, assign) int lightStatus;
@property (nonatomic, assign) int bright;
@property (nonatomic, assign) int colorTel;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *music;
@property (nonatomic, strong) id devItem;
@property (nonatomic, assign, getter=isGetStatus) BOOL isGetStatus;

@property(nonatomic,strong)NSString *addressName;


-(BOOL)addGrpAddressPro:(int)addAdr;
-(BOOL)removeGrpAddressPro:(int)addAdr;

@end
