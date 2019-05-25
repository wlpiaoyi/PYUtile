//
//  NSString+__PY_Match.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/21.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString(__PY_Match)
#pragma 字符串验证=================================>
/**
 整数验证
 */
-(BOOL) matchInteger;
/**
 小数验证
 */
-(BOOL) matchFloat;
/**
 手机号码验证
 */
-(BOOL) matchMobliePhone;
/**
 座机号码验证
 */
-(BOOL) matchHomePhone;
/**
 邮箱验证
 */
-(BOOL) matchEmail;
/**
 港澳通行证验证
 */
-(BOOL) matchHkMacCard;
/**
 台湾通行证验证
 */
-(BOOL) matchTWCard;
/**
 护照验证
 */
-(BOOL) matchPassport;
/**
 身份证验证
 */
-(BOOL) matchIdentifyNumber;
/**
 银行卡验证
 */
-(BOOL) matchBankNumber;

/**
 通过正则表达式找出所以匹配的String
 */
-(nullable NSArray<NSString *> *) stringsForRegex:(nonnull NSString *) regexstr;

/**
 通过正则表达式找出所以匹配的Ranges
 */
-(nullable NSArray<NSTextCheckingResult *> *) matchesForRegex:(nonnull NSString *) regexstr;

+(BOOL) matchArg:(nonnull NSString*) arg regex:(nonnull NSString*) regex;
#pragma 字符串验证<=================================
@end

