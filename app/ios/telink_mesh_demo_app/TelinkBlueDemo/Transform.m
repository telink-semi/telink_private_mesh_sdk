/********************************************************************************************************
 * @file     Transform.m 
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
//  Transform.m
//  Scale
//
//  Created by Xlink on 15/11/12.
//  Copyright © 2015年 YiLai. All rights reserved.
//

#import "Transform.h"
#import "TranslateTool.h"

@implementation Transform

/*
 
 js
 
 gotDeviceInfo(var jsonData){
    dfdsfadfdsf;
 }
 
 window.load("ios/android://getXDeviceInfo?deviceid?gotDeviceInfo");
 window.load("www.baidu.com");
 
 
 
 */

+(NSString*)DataToJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
//                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
//                                                         error:&error];
    
    //option为0时，输出的json不换行
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:0 // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    }
    
    return jsonString;

}


/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


+(NSString *)tokenToAccountId:(NSString *)token{
    
    NSString *str=[[NSString alloc] initWithData:[GTMBase64 decodeString:token]
                                        encoding:NSUTF8StringEncoding];
    
    NSArray *arr = [str componentsSeparatedByString:@"|"];
    
    return [arr objectAtIndex:0];
}



////////////base64解密和加密//////////////
+(NSString *)stringToBase64:(NSString *)string{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString* encoded = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    
    return encoded;
}

+(NSString *)base64ToString:(NSString *)base64Str{

    
//     NSString* decoded = [[NSString alloc] initWithData:[GTMBase64 decodeString:base64Str] encoding:NSUTF8StringEncoding];
//    NSString* decoded = [NSString stringWithFormat:@"%@",[GTMBase64 decodeString:base64Str] ];
    NSString* decoded = [TranslateTool convertDataToHexStr:[GTMBase64 decodeString:base64Str]];
    return decoded;
}


+(NSString *)dataToBase64:(NSData *)data{
    NSString* encoded = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];

    return encoded;
}

+(NSData *)base64ToData:(NSString *)base64Str{
    
    return [GTMBase64 decodeString:base64Str];
}
////////////base64解密和加密//////////////

+(NSDate*)dateStrToDate:(NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    formatter.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    
    return [formatter dateFromString:dateStr];
}

+(NSString *)dateToDateStr:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     formatter.timeZone = [NSTimeZone systemTimeZone];//系统所在时区
    
    return [formatter stringFromDate:date];
}

+(NSString *)timeSPToTime:(NSNumber *)sp{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sp.floatValue/1000.0];

    
//   NSDate *date = [formatter dateFromString:@"1415574344"];
    
    return [formatter stringFromDate:date];
}

//其它进制转10进制
+ (unsigned long)unsignedLongFrom:(NSString *)hexString scale:(int)scale {
    return strtoul([hexString UTF8String], 0, scale);
}

+(NSString *)strTo16HexStr:(NSString *)str{
    return  [NSString stringWithFormat:@"%lu",strtoul([str UTF8String],0,16)];
}

+(NSData*)nsstringToHex:(NSString*)string{
    
    const char *buf = [string UTF8String];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        unsigned long len = strlen(buf);
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i])  )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp)length:1];
            }
            else
            {
                break;
            }
        }
    }
    
    
    return data;
}

+(NSString *)covertGtoOz:(NSInteger)g isMinus:(BOOL)minus{
    if (minus)
        return [NSString stringWithFormat:@"-%.1f",(g*3.5273962/100)];
    
    return [NSString stringWithFormat:@"%.1f",(g*3.5273962/100)];
}

+(NSString *)covertGtoLboz:(NSInteger)g isMinus:(BOOL)minus{
    float ozUnitWeight = g*3.5273962/100.f;
    int resultIntPart = (int)(ozUnitWeight/16);
    float resultModPart = ozUnitWeight-resultIntPart*16.0;
    NSString *tempModStr = [NSString stringWithFormat:@"%.1f",resultModPart*1.0];
    
    if (minus)
        return [NSString stringWithFormat:@"-%d:%@",resultIntPart,tempModStr];
    
    return [NSString stringWithFormat:@"%d:%@",resultIntPart,tempModStr];

}

+(NSString *)covertGtoMl:(NSInteger)g isMinus:(BOOL)minus{
    
    if (minus)
        return [NSString stringWithFormat:@"-%ld",(long)g];
        
    return [NSString stringWithFormat:@"%ld",(long)g];
}

+(NSString *)covertGtoFloz:(NSInteger)g isMinus:(BOOL)minus{
    if (minus)
       return [NSString stringWithFormat:@"-%.1f",g*3.519508/100*1.0];
          
    return [NSString stringWithFormat:@"%.1f",g*3.519508/100*1.0];
}




@end
