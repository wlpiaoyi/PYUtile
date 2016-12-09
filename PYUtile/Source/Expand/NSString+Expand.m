//
//  NSString+Convenience.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NSString+Expand.h"


NSString * REGEX_HOMEHONE = @"^((\\d{2,4}\\-){0,1}\\d{7,9})$";
NSString * REGEX_MOBILEPHONE = @"^(\\+(\\d{2})){0,1}((13)|(14)|(15)|(18)|(19)|(17))\\d{9}$";
NSString * REGEX_INTEGER = @"^\\d{1,}$";
NSString * REGEX_FLOAT = @"^\\d{1,}\\.{1}\\d{1,}$";
NSString * REGEX_EMAIL = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
//港澳通行证
NSString * REGEX_HKMACCARD = @"^([a-zA-Z]\\d{8})$";
//台湾通行证
NSString * REGEX_TWCARD = @"^[a-zA-Z0-9]{1,20}$";
//护照
NSString * REGEX_PASSPORT = @"^[A-Z\\d]{5,30}$";

@implementation NSString (Expand)
-(BOOL) hasChinese:(nullable BOOL *) isAll{
    BOOL hasChinese = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            hasChinese = true;
            if(!isAll)break;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasChinese;
}
-(BOOL) hasASCII:(nullable BOOL *) isAll{
    BOOL hasASCll = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x0 && a < 0xFF){
            hasASCll = true;
            if (!isAll) break;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasASCll;
}
-(BOOL) hasUnkown:(nullable BOOL *) isAll{
    BOOL hasUnkown = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0xFF && (a < 0x4e00 || a > 0x9fff)){
            hasUnkown = true;
            if(isAll)break;;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasUnkown;
}
-(NSComparisonResult) compareVersion:(nullable NSString *) version{
    if (![NSString isEnabled:version]) {
        return true;
    }
    NSInteger currentValue = 0;
    NSInteger targetValue = 0;
    NSArray<NSString *> * currentArray = [self componentsSeparatedByString:@"."];
    NSArray<NSString *> * targetArray = [version componentsSeparatedByString:@"."];
    static const NSInteger value = 100;
    NSInteger count = MAX(currentArray.count, targetArray.count);
    for (NSString * _v_ in currentArray) {
        --count;
        currentValue += _v_.integerValue * pow(value, count);
    }
    
    count = MAX(currentArray.count, targetArray.count);
    for (NSString * _v_ in targetArray) {
        --count;
        targetValue += _v_.integerValue * pow(value, count);
    }
    if (targetValue > currentValue) {
        return NSOrderedDescending;
    }
    if (targetValue < currentValue) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}
-(NSDate*) dateFormateString:(NSString*) formatePattern{
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:formatePattern==nil?@"yyyy-MM-dd HH:mm:ss":formatePattern];
    return [dft dateFromString:self];
}
+(bool) isEnabled:(nullable id) target{
    if(!target||target==nil||target==[NSNull null]||[@"" isEqual:target])return NO;
    else return YES;
}
-(NSString *)filterHTML
{
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//    NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
+ (nullable NSString*)base64forData:(nullable NSData *)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

/**
 整数
 */
-(BOOL) matchInteger{
    return [NSString matchArg:self regex:REGEX_INTEGER];
}
/**
 小数
 */
-(BOOL) matchFloat{
    return [NSString matchArg:self regex:REGEX_FLOAT];
}
/**
 手机号码
 */
-(BOOL) matchMobliePhone{
    return [NSString matchArg:self regex:REGEX_MOBILEPHONE];
}
/**
 座机号码
 */
-(BOOL) matchHomePhone{
    return [NSString matchArg:self regex:REGEX_HOMEHONE];
}
/**
 邮箱
 */
-(BOOL) matchEmail{
    return [NSString matchArg:self regex:REGEX_EMAIL];
}
/**
 港澳通行证
 */
-(BOOL) matchHkMacCard{
    return [NSString matchArg:self regex:REGEX_HKMACCARD];
}
/**
 台湾通行证
 */
-(BOOL) matchTWCard{
    return [NSString matchArg:self regex:REGEX_TWCARD];
}
/**
 护照
 */
-(BOOL) matchPassport{
    return [NSString matchArg:self regex:REGEX_PASSPORT];
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

+(BOOL) matchArg:(NSString*) arg regex:(NSString*) regex{
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:arg];
}
@end
