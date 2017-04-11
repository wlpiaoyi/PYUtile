//
//  NSString+Convenience.h
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (Expand)
-(BOOL) hasChinese:(nullable BOOL *) isAll;
-(BOOL) hasASCII:(nullable BOOL *) isAll;
-(BOOL) hasUnkown:(nullable BOOL *) isAll;
-(NSComparisonResult) compareVersion:(nullable NSString *) version;
-(nullable NSString *)filterHTML;
/**
 将字符串转换成日期
 */
-(nullable NSDate *) dateFormateString:(nullable NSString *) formatePattern;
/**
 判断字符串是否有效 "",nil,NO,NSNull
 */
+(bool) isEnabled:(nullable id) target;
/**
 将64位的字符串装换成正常的Data数据
 */
-(nullable NSData *) toDataForBase64;
/**
 将字符串装换成Data数据
 */
-(nullable NSData *) toData;
/**
 整数
 */
-(BOOL) matchInteger;
/**
 小数
 */
-(BOOL) matchFloat;
/**
 手机号码
 */
-(BOOL) matchMobliePhone;
/**
 座机号码
 */
-(BOOL) matchHomePhone;
/**
 邮箱
 */
-(BOOL) matchEmail;
/**
 港澳通行证
 */
-(BOOL) matchHkMacCard;
/**
 台湾通行证
 */
-(BOOL) matchTWCard;
/**
 护照
 */
-(BOOL) matchPassport;
/**
 身份证
 */
-(BOOL) matchIdentifyNumber;

+(BOOL) matchArg:(nonnull NSString*) arg regex:(nonnull NSString*) regex;

@end
