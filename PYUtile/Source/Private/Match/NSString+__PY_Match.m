//
//  NSString+__PY_Match.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/21.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSString+__PY_Match.h"

NSString * __PY_REGEX_HOMEHONE = @"^((\\d{2,4}\\-){0,1}\\d{7,9})$";
NSString * __PY_REGEX_MOBILEPHONE = @"^(\\+(\\d{1,3})){0,1}((12)|(13)|(14)|(15)|(16)|(17)|(18)|(19))\\d{9}$";
NSString * __PY_REGEX_INTEGER = @"^\\d{1,}$";
NSString * __PY_REGEX_FLOAT = @"^\\d{1,}\\.{1}\\d{1,}$";
NSString * __PY_REGEX_EMAIL = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
//港澳通行证
NSString * __PY_REGEX_HKMACCARD = @"^([a-zA-Z]\\d{8})$";
//台湾通行证
NSString * __PY_REGEX_TWCARD = @"^[a-zA-Z0-9]{1,20}$";
//护照
NSString * __PY_REGEX_PASSPORT = @"^[A-Z\\d]{5,30}$";
NSString * __PY_REGEX_MONEYCN = @"^(￥\\d{0,}\\.{0,1}\\d{1,})|(\\d{0,}\\.{0,1}\\d{1,}元)$";

@implementation NSString(__PY_Match)

/**
 整数
 */
-(BOOL) matchInteger{
    return [NSString matchArg:self regex:__PY_REGEX_INTEGER];
}
/**
 小数
 */
-(BOOL) matchFloat{
    return [NSString matchArg:self regex:__PY_REGEX_FLOAT];
}
/**
 手机号码
 */
-(BOOL) matchMobliePhone{
    return [NSString matchArg:self regex:__PY_REGEX_MOBILEPHONE];
}
/**
 座机号码
 */
-(BOOL) matchHomePhone{
    return [NSString matchArg:self regex:__PY_REGEX_HOMEHONE];
}
/**
 邮箱
 */
-(BOOL) matchEmail{
    return [NSString matchArg:self regex:__PY_REGEX_EMAIL];
}
/**
 港澳通行证
 */
-(BOOL) matchHkMacCard{
    return [NSString matchArg:self regex:__PY_REGEX_HKMACCARD];
}
/**
 台湾通行证
 */
-(BOOL) matchTWCard{
    return [NSString matchArg:self regex:__PY_REGEX_TWCARD];
}
/**
 护照
 */
-(BOOL) matchPassport{
    return [NSString matchArg:self regex:__PY_REGEX_PASSPORT];
}

/**
 身份证
 */
-(BOOL) matchIdentifyNumber{
    if(self.length == 18)
    {
        const char* pszSrc = self.uppercaseString.UTF8String;
        int iS = 0;
        int iW[]={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
        char szVerCode[]="10X98765432";
        int i;
        for(i=0;i<17;i++)
        {
            iS += (int)(pszSrc[i]-'0') * iW[i];
        }
        int iY = iS%11;
        return pszSrc[17] == szVerCode[iY];
    }
    return NO;
}

/**
 * 银行卡验证
 */
-(BOOL) matchBankNumber{
    if(self.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < self.length; i++)
    {
        c = [self characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}

/**
 通过正则表达式找出所以匹配的String
 */
-(nullable NSArray<NSString *> *) stringsForRegex:(nonnull NSString *) regexstr{
    
    NSArray<NSTextCheckingResult *> * matches = [self matchesForRegex:regexstr];
    
    //match: 所有匹配到的字符,根据() 包含级
    NSMutableArray<NSString *> * array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        if([match numberOfRanges] < 1) continue;
        //以正则中的(),划分成不同的匹配部分
        NSRange range = [match rangeAtIndex:0];
        NSString *component = [self substringWithRange:range];
        [array addObject:component];
    }
    
    return array;
}

/**
 通过正则表达式找出所以匹配的Ranges
 */
-(nullable NSArray<NSTextCheckingResult *> *) matchesForRegex:(nonnull NSString *) regexstr{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexstr options:NSRegularExpressionCaseInsensitive error:nil];
    
    return [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
}


+(BOOL) matchArg:(NSString*) arg regex:(NSString*) regex{
    @try {
        NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        return [pred evaluateWithObject:arg];
    } @catch (NSException *exception) {
        return NO;
    }
}

#warning 待定的功能
-(BOOL) mathMoneyCN{
    return [NSString matchArg:self regex:__PY_REGEX_MONEYCN];
}

@end
