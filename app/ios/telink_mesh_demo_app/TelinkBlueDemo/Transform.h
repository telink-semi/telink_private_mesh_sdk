/********************************************************************************************************
 * @file     Transform.h 
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
//  Transform.h
//  Scale
//
//  Created by Xlink on 15/11/12.
//  Copyright © 2015年 YiLai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"

@interface Transform : NSObject


/*!
 * @brief 把object转换成格式化的JSON格式的字符串
 * @param object
 * @return 字符串
 */

+(NSString*)DataToJsonString:(id)object;


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/*!
 * @brief 把NSString转成可写入蓝牙设备的Hex Data
 * @param string
 * @return 返回data
 */

+(NSData*)nsstringToHex:(NSString*)string;


/*!
 * @brief 把token转成account_id
 * @param string
 * @return 返回
 */
+(NSString *)tokenToAccountId:(NSString*)token;


////////////base64解密和加密//////////////
+(NSString *)stringToBase64:(NSString *)string;

+(NSString *)base64ToString:(NSString *)base64Str;

+(NSString *)dataToBase64:(NSData *)data;

+(NSData *)base64ToData:(NSString *)base64Str;
////////////base64解密和加密//////////////

+(NSDate*)dateStrToDate:(NSString *)dateStr;

+(NSString *)dateToDateStr:(NSDate *)date;

+(NSString *)timeSPToTime:(NSNumber*)sp;


/**其它进制转10进制*/
+ (unsigned long)unsignedLongFrom:(NSString *)hexString scale:(int)scale;


+(NSString *)strTo16HexStr:(NSString *)str;



+(NSString *)covertGtoOz:(NSInteger)g isMinus:(BOOL)minus;//是否负数

+(NSString *)covertGtoLboz:(NSInteger)g isMinus:(BOOL)minus;

+(NSString *)covertGtoMl:(NSInteger)g isMinus:(BOOL)minus;

+(NSString *)covertGtoFloz:(NSInteger)g isMinus:(BOOL)minus;


@end
