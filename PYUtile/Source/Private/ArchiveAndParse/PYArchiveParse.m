//
//  PYArchiveParset.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYArchiveParse.h"
#import <objc/runtime.h>
#import "PYUtile.h"
#import "NSString+Expand.h"
#import "NSNumber+Expand.h"
#import "NSDictionary+Expand.h"
#import "NSData+Expand.h"
#import "NSDate+Expand.h"

#pragma 日期装换成秒
char * __PY_ARCHIVE_DATE_PARSE_NUMBERX1 = "_date_to_numberx1";
#pragma 日期装换成毫秒
char * __PY_ARCHIVE_DATE_PARSE_NUMBERX3 = "_date_to_numberx3";

static NSArray * __PY_OBJ_TO_DICT_CLASS;
static NSDictionary * __PY_PARSE_VAR_TO_KEY;
static NSDictionary * __PY_PARSE_VAR_HEAD_TO_KEY;
static NSDictionary * __PY_PARSE_KEY_TO_VAR;
static NSDictionary * __PY_PARSE_KEY_TO_VAR_HEAD;


@implementation NSData(__PY_ARC_PAR)
+(NSObject *) __PY_PARSE:(NSObject *) value{
    if(value == nil) return nil;
    if([value isKindOfClass:[NSData class]]){
        return value;
    }else if([value isKindOfClass:[NSNumber class]]){
        return [[((NSNumber *) value) stringValueWithPrecision:10] toData];
    }else if([value isKindOfClass:[NSString class]]){
        return [((NSString *) value)  toData];
    }
    kPrintExceptionln("value:%s can't parset to %s", [value description].UTF8String, NSStringFromClass(self).UTF8String);
    return nil;
}
@end

@implementation NSDate(__PY_ARC_PAR)
+(NSObject *) __PY_PARSE:(NSObject *) value{
    if(value == nil) return nil;
    if([value isKindOfClass:[NSString class]]){
        NSDate * date = [((NSString *)value) dateFormateString:nil];
        if(date) return date;
        if([NSString isEnabled:value]) value = @([(NSString *)value integerValue]);
        else return nil;
    }
    if([value isKindOfClass:[NSDate class]]){
        return [(NSDate *)value dateFormateDate:nil];
    }
    if([value isKindOfClass:[NSNumber class]]){
        NSTimeInterval timeInterval =  [((NSNumber *)value) doubleValue];
        if(timeInterval > 9999999999.0){
            return  [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
        }else{
            return [NSDate dateWithTimeIntervalSince1970:timeInterval];
        }
    }
    kPrintExceptionln("value:%s can't parset to %s", [value description].UTF8String, NSStringFromClass(self).UTF8String);
    return nil;
}
@end

@implementation NSString(__PY_ARC_PAR)
+(NSObject *) __PY_PARSE:(NSObject *) value{
    if(value == nil) return nil;
    if([value isKindOfClass:[NSString class]]){
        return value;
    }else if([value isKindOfClass:[NSNumber class]]){
        return [((NSNumber *)value) stringValueWithPrecision:10];
    }else if([value isKindOfClass:[NSData class]]){
        return [((NSData *)value) toString];
    }else if([value isKindOfClass:[NSDate class]]){
        return [((NSDate *)value) dateFormateDate:nil];
    }else if([value isKindOfClass:[NSURL class]]){
        return [((NSURL *)value) absoluteString];
    }
    kPrintExceptionln("value:%s can't parset to %s", [value description].UTF8String, NSStringFromClass(self).UTF8String);
    return nil;
}
@end

@implementation NSNumber(__PY_ARC_PAR)
+(NSObject *) __PY_PARSE:(NSObject *) value{
    if(value == nil) return nil;
    if([value isKindOfClass:[NSNumber class]]){
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        return @([((NSString *)value) doubleValue]);
    }else if([value isKindOfClass:[NSData class]]){
        return @([([((NSData *)value) toString]) doubleValue]);
    }else if([value isKindOfClass:[NSDate class]]){
        return @([((NSDate *)value) timeIntervalSince1970]);
    }
    kPrintExceptionln("value:%s can't parset to %s", [value description].UTF8String, NSStringFromClass(self).UTF8String);
    return nil;
}
@end

@implementation NSURL(__PY_ARC_PAR)
+(NSObject *) __PY_PARSE:(NSObject *) value{
    if(value == nil) return nil;
    if([value isKindOfClass:[NSURL class]]){
        return value;
    }else if([value isKindOfClass:[NSString class]]){
        return [NSURL URLWithString:(NSString *)value];
    }else if([value isKindOfClass:[NSData class]]){
        return [NSURL URLWithString:[((NSData *)value) toString]];
    }
    kPrintExceptionln("value:%s can't parset to %s", [value description].UTF8String, NSStringFromClass(self).UTF8String);
    return nil;
}
@end

@implementation PYArchiveParse
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        __PY_OBJ_TO_DICT_CLASS = @[
                                   [NSString class]
                                   ,[NSNumber class]
                                   ,[NSDate class]
                                   ,[NSData class]
                                   ,[NSURL class]
                                   ,[NSValue class]
                                   ];
        __PY_PARSE_VAR_TO_KEY = @{
                                  @"keyId":@"id",
                                  @"keyDescription":@"description"
                                  };
        __PY_PARSE_VAR_HEAD_TO_KEY= @{
                                       @"keyNew":@"new"
                                       };
        __PY_PARSE_KEY_TO_VAR= @{
                                  @"id":@"keyId",
                                  @"description":@"keyDescription"
                                  };
        __PY_PARSE_KEY_TO_VAR_HEAD = @{
                                       @"new":@"keyNew"
                                       };
    });
}
+(BOOL) canParset:(Class) clazz{
    for (Class c in __PY_OBJ_TO_DICT_CLASS) {
        if (c == clazz ||  [clazz isSubclassOfClass:c]) {
            return true;
        }
    }
    return false;
}

+(int) clazz:(nonnull Class) clazz isMemberForClazz:(nonnull Class) memberForClazz{
    if(clazz == memberForClazz)  return 1;
    if([clazz isSubclassOfClass:memberForClazz]) return 2;
    return 0;
}

+(nullable NSObject *) parseValue:(nonnull id) value clazz:(nonnull Class) clazz{
    if(value == nil) return nil;
    if (![self canParset:clazz]) return nil;
    
    NSObject * returnValue = nil;
    if([value isKindOfClass:clazz]){
        returnValue = value;
    }else if([self clazz:clazz isMemberForClazz:[NSString class]]){
        returnValue = [NSString __PY_PARSE:value];
    }else if([self clazz:clazz isMemberForClazz:[NSNumber class]]){
        returnValue = [NSNumber __PY_PARSE:value];
    }else if([self clazz:clazz isMemberForClazz:[NSDate class]]){
        returnValue = [NSDate __PY_PARSE:value];
    }else if([self clazz:clazz isMemberForClazz:[NSData class]]){
        returnValue = [NSData __PY_PARSE:value];
    }else if([self clazz:clazz isMemberForClazz:[NSURL class]]){
        returnValue = [NSURL __PY_PARSE:value];
    }else{
        kPrintExceptionln("value:%s type:%s exception", [value description].UTF8String, NSStringFromClass([value class]).UTF8String);
    }
    return returnValue;
}

+(nullable NSObject *) valueArchive:(nonnull NSObject *) value clazz:(nullable Class) clazz{
    if(value == nil) return nil;
    if (![PYArchiveParse canParset:value.class]) return nil;
    NSObject * returnValue = nil;
    if(clazz == nil){
        if([value isKindOfClass:[NSURL class]]
        || [value isKindOfClass:[NSDate class]])
            returnValue = [NSString __PY_PARSE:value];
        else
            returnValue = value;
    }else{
        if (![PYArchiveParse canParset:clazz]) return nil;
        if([self clazz:clazz isMemberForClazz:[NSString class]]){
            returnValue = [NSString __PY_PARSE:value];
        }else if([self clazz:clazz isMemberForClazz:[NSNumber class]]){
            returnValue = [NSNumber __PY_PARSE:value];
        }else if([self clazz:clazz isMemberForClazz:[NSDate class]]){
            returnValue = [NSDate __PY_PARSE:value];
        }else if([self clazz:clazz isMemberForClazz:[NSData class]]){
            returnValue = [NSData __PY_PARSE:value];
        }else if([self clazz:clazz isMemberForClazz:[NSURL class]]){
            returnValue = [NSURL __PY_PARSE:value];
        }
    }
    return returnValue;
}

+(nullable Class) classFromTypeEncoding:(const char *) typeEncoding{
    size_t tedl = strlen(typeEncoding);
    if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
        return NSClassFromString([[NSString stringWithUTF8String:typeEncoding] substringWithRange:NSMakeRange(2, tedl-3)]);
    }
    return nil;
}

+(nonnull NSString *) parseVarToKey:(nonnull NSString *) name{
    NSString * pname = __PY_PARSE_VAR_TO_KEY[name];
    if(pname) return pname;
    NSEnumerator<NSString *> *objectEnumerator = __PY_PARSE_VAR_HEAD_TO_KEY.objectEnumerator;
    NSEnumerator<NSString *> *keyEnumerator = __PY_PARSE_VAR_HEAD_TO_KEY.keyEnumerator;
    NSString * keyValue;
    NSString * objectValue;
    while ((keyValue = keyEnumerator.nextObject) && (objectValue = objectEnumerator.nextObject)) {
        if(keyValue.length > name.length) continue;
        if(![keyValue isEqual:[name substringToIndex:keyValue.length]]) continue;
        NSRange range = NSMakeRange(0, keyValue.length);
        name = [name stringByReplacingCharactersInRange:range withString:objectValue];
        break;
    }
    return name;
}

+(nonnull NSString *) parseKeyToVar:(nonnull NSString *) name{
    NSString * pname = __PY_PARSE_KEY_TO_VAR[name];
    if(pname) return pname;
    NSEnumerator<NSString *> *objectEnumerator = __PY_PARSE_KEY_TO_VAR_HEAD.objectEnumerator;
    NSEnumerator<NSString *> *keyEnumerator = __PY_PARSE_KEY_TO_VAR_HEAD.keyEnumerator;
    NSString * keyValue;
    NSString * objectValue;
    while ((keyValue = keyEnumerator.nextObject) && (objectValue = objectEnumerator.nextObject)) {
        if(keyValue.length > name.length) continue;
        if(![keyValue isEqual:[name substringToIndex:keyValue.length]]) continue;
        NSRange range = NSMakeRange(0, keyValue.length);
        name = [name stringByReplacingCharactersInRange:range withString:objectValue];
        break;
    }
    return name;
}


@end
