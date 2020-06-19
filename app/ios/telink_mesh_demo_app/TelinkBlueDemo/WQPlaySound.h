/********************************************************************************************************
 * @file     WQPlaySound.h 
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
//  WQPlaySound.h
//  TelinkBlueDemo
//
//  Created by telink on 16/1/4.
//  Copyright © 2016年 Green. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface WQPlaySound : NSObject
{
    SystemSoundID soundID;
}

/**
 *  @brief  为播放震动效果初始化
 *
 *  @return self
 */
-(id)initForPlayingVibrate;

/**
 *  @brief  为播放系统音效初始化(无需提供音频文件)
 *
 *  @param resourceName 系统音效名称
 *  @param type 系统音效类型
 *
 *  @return self
 */
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;

/**
 *  @brief  为播放特定的音频文件初始化（需提供音频文件）
 *
 *  @param filename 音频文件名（加在工程中）
 *
 *  @return self
 */
-(id)initForPlayingSoundEffectWith:(NSString *)filename;

/**
 *  @brief  播放音效
 */
-(void)play;

@end
