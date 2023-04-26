/********************************************************************************************************
 * @file     LightData.m 
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
//  LightData.m
//  TelinkBlueDemo
//
//  Created by Green on 11/22/15.
//  Copyright (c) 2015 Green. All rights reserved.
//

#import "LightData.h"

@implementation LightData
@synthesize lightStatus;
@synthesize bright;
@synthesize colorTel;
@synthesize color;
@synthesize music;
@synthesize devItem;
@synthesize macAdress;
@synthesize devAressPer;
@synthesize devAress;
@synthesize comStartAdress;
@synthesize isGetStatus;

-(id)init
{
    self=[super init];
    self.color=[UIColor whiteColor];
    self.devItem=nil;
    memset(grpAdress, 0xff, 8);
    return self;
}

-(BOOL)addGrpAddressPro:(int)addAdr
{
    BOOL result=NO;
    for (int i=0; i<8; i++)
    {
        if (grpAdress[i]==0xff)
        {
            grpAdress[i]=addAdr;
            result=YES;
            break;
        }
    }
    return result;
}

-(BOOL)removeGrpAddressPro:(int)addAdr
{
    BOOL result=NO;
    for (int i=0; i<8; i++)
    {
        if (grpAdress[i]==addAdr)
        {
            grpAdress[i]=0xff;
            result=YES;
        }
    }
    return result;
}
@end
