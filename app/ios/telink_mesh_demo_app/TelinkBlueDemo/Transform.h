/********************************************************************************************************
 * @file     Transform.h 
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
