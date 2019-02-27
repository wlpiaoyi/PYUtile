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


static NSArray * __PY_OBJ_TO_DICT_CLASS;
static NSDictionary * __PY_VAR_KEY_NAME;
static NSDictionary * __PY_VAR_HEAD_NAME;


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
    if([value isKindOfClass:[NSDate class]]){
        return value;
    }else if([value isKindOfClass:[NSNumber class]]){
        NSTimeInterval timeInterval =  [((NSNumber *)value) doubleValue];
        if(timeInterval > 9999999999.0){
            return [NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0];
        }else{
            return [NSDate dateWithTimeIntervalSince1970:timeInterval];
        }
    }else if([value isKindOfClass:[NSString class]]){
        return [((NSString *)value) dateFormateString:nil];
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
                                   ];
        __PY_VAR_KEY_NAME = @{
                              @"id":@"keyId",@"keyId":@"id",
                              @"description":@"keyDescription", @"keyDescription":@"description"
                              };
        __PY_VAR_HEAD_NAME = @{
                               @"new":@"keyNew",@"keyNew":@"new"
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

+(nonnull NSString *) checkVarKey:(nonnull NSString *) name{
    
    NSString * pname = __PY_VAR_KEY_NAME[name];
    if(pname) return pname;
    
    return name;
    
}

//+(nullable Class) classFromTypeEncoding:(const char *) typeEncoding{
//    size_t tedl = strlen(typeEncoding);
//    if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
//        if(strlen(typeEncoding)){
//            NSArray * classArgs = [[NSString stringWithUTF8String:typeEncoding] componentsSeparatedByString:@"\""];
//            return NSClassFromString(classArgs[1]);
//        }
//    }
//    return nil;
//}
//
//+(nonnull NSString *) checkVarKey:(nonnull NSString *) name{
//
//    NSString * pname = __PY_VAR_KEY_NAME[name];
//    if(pname) return pname;
//
//    for (NSString * key in __PY_VAR_HEAD_NAME) {
//        NSRange range = [name rangeOfString:key];
//        if(range.length > 0 && range.location == 0){
//            pname = [name stringByReplacingCharactersInRange:range withString:__PY_VAR_HEAD_NAME[key]];
//            break;
//        }
//    }
//    if(pname) return pname;
//
//    return name;
//
//}


@end
