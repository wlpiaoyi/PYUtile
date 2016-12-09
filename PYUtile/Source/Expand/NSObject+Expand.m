//
//  NSObejct+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import "PYInvoke.h"
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>
const NSArray * NSObjectToDictionaryPaserClasses;
@implementation NSObject(toDictionary)
+(NSArray *) objectParseClasses{
    if (NSObjectToDictionaryPaserClasses == nil) {
        NSObjectToDictionaryPaserClasses = @[[NSNumber class],[NSString class],[NSDate class],[NSNumber class],[NSArray class],[NSValue class]];
    }
    return NSObjectToDictionaryPaserClasses;
}
+(BOOL) canParseClass:(Class) class{
    for (Class c in [self objectParseClasses]) {
        if (c == class) {
            return true;
        }
    }
    return false;
}
/**
 通过JSON初始化对象
 */
+(instancetype) objectWithDictionary:(NSDictionary*) dictionary{
    return [self objectWithDictionary:dictionary clazz:self];
}
/**
 通过JSON初始化对象
 */
+(id) objectWithDictionary:(NSDictionary*) dictionary clazz:(Class) clazz{
    id target = [[clazz alloc] init];
    if (target) {
        for (NSString *propertyName in [dictionary allKeys]) {
            NSString * _propertyName_ = propertyName;
            if ([propertyName isEqual:@"id"]) {
                _propertyName_ = @"keyId";
            }
            NSString *setMethodName = [NSString stringWithFormat:@"set%@%@:",[[_propertyName_ substringToIndex:1] uppercaseString],[_propertyName_ substringFromIndex:1]];
            SEL setSel = sel_getUid([setMethodName UTF8String]);
            if(![target respondsToSelector:setSel]){
                NSLog(@"has no set name with:%@ in %@",setMethodName, NSStringFromClass([target class]));
                continue;
            }
            
            id propertyValue = dictionary[propertyName];
            if (propertyValue == nil || propertyValue == [NSNull null]) {
                continue;
            }
            
            NSInvocation *invocaton = [PYInvoke startInvoke:target action:setSel];
            const char * encode = [invocaton.methodSignature getArgumentTypeAtIndex:2];
            
            if(strcasecmp(encode, @encode(int)) == 0){
                int v = [propertyValue intValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(long)) == 0){
                long v = [propertyValue longValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(long long)) == 0){
                long long v = [propertyValue longLongValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(bool)) == 0){
                bool v = [propertyValue boolValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(float)) == 0){
                float v = [propertyValue floatValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(double)) == 0){
                double v = [propertyValue doubleValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(short)) == 0){
                short v = [propertyValue shortValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(strcasecmp(encode, @encode(char)) == 0){
                char v = [propertyValue charValue];
                [PYInvoke setInvoke:&v index:2 invocation:invocaton];
            }else if(encode[0] == '{' && encode[strlen(encode) -1] == '}'){
//                NSValue * value = [NSValue valueWithBytes:((NSData*)propertyValue).bytes objCType:encode];
//                void * v;
//                [value getValue:v];
//                [PYInvoke setInvoke:v index:2 invocation:invocaton];
            }else{
                if (![propertyValue isKindOfClass:[NSNumber class]] &&
                    ![propertyValue isKindOfClass:[NSString class]] &&
                    ![propertyValue isKindOfClass:[NSDate class]] &&
                    ![propertyValue isKindOfClass:[NSNumber class]]) {
                    if ([propertyValue isKindOfClass:[NSArray class]]) {
                        NSMutableArray * objs = [NSMutableArray new];
                        NSString * _propertyName = [NSString stringWithFormat:@"property_%@",propertyName];
                        objc_property_t property = class_getProperty(self, _propertyName.UTF8String);
                        if (property) {
                            NSArray * classArgs = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@"\""];
                            Class clazz = NSClassFromString(classArgs[1]);
                            for (NSObject * obj in propertyValue) {
                                [objs addObject:[clazz objectWithDictionary:obj]];
                            }
                            propertyValue = objs;
                        }
                    }else{
                        objc_property_t property = class_getProperty(self, propertyName.UTF8String);
                        NSArray * classArgs = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@"\""];
                        Class clazz = NSClassFromString(classArgs[1]);
                        propertyValue = [clazz objectWithDictionary:propertyValue];
                    }
                }
                [PYInvoke setInvoke:&propertyValue index:2 invocation:invocaton];
                
            }
            [PYInvoke excuInvoke:nil returnType:nil invocation:invocaton];
        }
    }
    return target;
}
/**
 通过对象生成JSON
 */
-(NSDictionary*) objectToDictionary{
    
    if ([self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSString class]] ||
        [self isKindOfClass:[NSDate class]] ||
        [self isKindOfClass:[NSNumber class]]){
        return self;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    __weak id obejct = self;
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    @try {
        static NSDictionary *PYObjectSuperPropertNameDic = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            PYObjectSuperPropertNameDic = @{@"hash":@YES,@"superclass":@YES,@"description":@YES,@"debugDescription":@YES};
        });
        for (int i = 0; i < outCount; i++) {
            
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            if (PYObjectSuperPropertNameDic[propertyName]) {
                continue;
            }
            
            SEL getSel = sel_getUid([propertyName UTF8String]);
            if(![obejct respondsToSelector:getSel]){
                NSLog(@"has no get name with:%@ in %@",propertyName, NSStringFromClass([obejct class]));
                continue;
            }
            NSInvocation *invocaton = [PYInvoke startInvoke:obejct action:getSel];
            const char * encode = invocaton.methodSignature.methodReturnType;
            const char * a = property_getAttributes(property);
            id returnValue;
            if(strcasecmp(encode, @encode(int)) == 0){
                int v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithInt:v];
            }else if(strcasecmp(encode, @encode(long)) == 0){
                long v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithLong:v];
            }else if(strcasecmp(encode, @encode(long long)) == 0){
                long long v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithLongLong:v];
            }else if(strcasecmp(encode, @encode(bool)) == 0){
                bool v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithBool:v];
            }else if(strcasecmp(encode, @encode(float)) == 0){
                float v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithFloat:v];
            }else if(strcasecmp(encode, @encode(double)) == 0){
                double v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithDouble:v];
            }else if(strcasecmp(encode, @encode(short)) == 0){
                short v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithShort:v];
            }else if(strcasecmp(encode, @encode(char)) == 0){
                char v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = [NSNumber numberWithChar:v];
            }else if(encode[0] == '{' && encode[strlen(encode) -1] == '}'){
//                if (strcasecmp(encode, "{?=i{?=dd}ddddddddidi{?=dd}diIi}") != 0) {
//                    void * v;
//                    [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
//                    NSValue * value = [NSValue valueWithBytes:&v objCType:encode];
//                    NSUInteger size;
//                    const char* encoding = [value objCType];
//                    NSGetSizeAndAlignment(encoding, &size, NULL);
//                    void* ptr = malloc(size);
//                    [value getValue:ptr];
//                    returnValue = [NSData dataWithBytes:ptr length:size];
//                    free(ptr);
//                }
            } else{
                void * v;
                [PYInvoke excuInvoke:&v returnType:nil invocation:invocaton];
                returnValue = (__bridge id)v;
            }
            if(!returnValue){
                continue;
            }
            if (returnValue) {
                if (![returnValue isKindOfClass:[NSNumber class]] &&
                    ![returnValue isKindOfClass:[NSString class]] &&
                    ![returnValue isKindOfClass:[NSDate class]] &&
                    ![returnValue isKindOfClass:[NSData class]] &&
                    ![returnValue isKindOfClass:[NSNumber class]]) {
                    if ([returnValue isKindOfClass:[NSArray class]]) {
                        NSMutableArray * objs = [NSMutableArray new];
                        for (id obj in returnValue) {
                            [objs addObject:[obj objectToDictionary]];
                        }
                        returnValue = objs;
                    }else{
                        returnValue = [returnValue objectToDictionary];
                    }
                }
                if ([propertyName isEqual:@"keyId"]) {
                    propertyName = @"id";
                }
                [dict setObject:returnValue forKey:propertyName];
            }
        }
    }
    @finally {
        free(properties);
    }
    return dict;
}

@end
