//
//  NSobject+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "PYInvoke.h"
static NSArray * NSObjectToDictionaryPaserClasses;
static NSMutableArray * static_arry;
@implementation NSObject(toDictionary)
+(NSArray *) objectParseClasses{
    if (NSObjectToDictionaryPaserClasses == nil) {
        NSObjectToDictionaryPaserClasses = @[[NSNumber class],[NSString class],[NSDate class],[NSData class]];
    }
    return NSObjectToDictionaryPaserClasses;
}
+(BOOL) canParseClass:(Class) clazz{
    for (Class c in [self objectParseClasses]) {
        if (c == clazz ||  [clazz isSubclassOfClass:c]) {
            return true;
        }
    }
    return false;
}
/**
 通过JSON初始化对象
 */
+(instancetype) objectWithDictionary:(NSObject*) dictionary{
    return [self objectWithDictionary:dictionary clazz:self];
}
/**
 通过JSON初始化对象
 */
+(id) objectWithDictionary:(NSObject*) dictionary clazz:(Class) clazz{
    if([NSObject canParseClass:dictionary.class]) return dictionary;
    if(![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    id target = [[clazz alloc] init];
    if (target) {
        for (NSString *key in [((NSDictionary *)dictionary) allKeys]) {
            NSString * _key_ = key;
            if ([key isEqual:@"id"]) {
                _key_ = @"keyId";
            }
            
            id value = ((NSDictionary *)dictionary)[key];
            if (value == nil || value == [NSNull null]) {
                continue;
            }
            
            objc_property_t property = class_getProperty(clazz, _key_.UTF8String);
            Ivar ivar = class_getInstanceVariable(clazz, _key_.UTF8String);
            const char * typeEncoding;
            if(property){
                unsigned int count;
                objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
                typeEncoding = attribute[0].value;
            }else if(ivar){
                typeEncoding = ivar_getTypeEncoding(ivar);
            }else{
                printf("the class [%s] has no ivar [%s]\n", NSStringFromClass(clazz).UTF8String, _key_.UTF8String);
                continue;
            }
            
            if(strlen(typeEncoding) <= 0){
                printf("the class [%s]'s ivar [%s] has not found typeEncoding\n", NSStringFromClass(clazz).UTF8String, _key_.UTF8String);
                continue;
            }
            
            size_t tedl = strlen(typeEncoding);
            if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
                if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSSet class]]) {
                    const char * ctypeEncoding = NULL;
                    objc_property_t cproperty = class_getProperty(clazz, [NSString stringWithFormat:@"property_%@",_key_].UTF8String);
                    Ivar civar = class_getInstanceVariable(clazz, [NSString stringWithFormat:@"ivar_%@",_key_].UTF8String);
                    if(cproperty){
                        unsigned int count;
                        objc_property_attribute_t * attribute = property_copyAttributeList(cproperty, &count);
                        ctypeEncoding = attribute[0].value;
                    }else if(civar){
                        ctypeEncoding = ivar_getTypeEncoding(civar);
                    }else{
                        value = nil;
                        printf("the class has no pattern for property_%s or ivar_%s\n", _key_.UTF8String, _key_.UTF8String);
                        continue;
                    }
                    Class cClazz = nil;
                    if(ctypeEncoding != NULL && strlen(ctypeEncoding)){
                        NSArray * classArgs = [[NSString stringWithUTF8String:ctypeEncoding] componentsSeparatedByString:@"\""];
                        cClazz = NSClassFromString(classArgs[1]);
                    }
                    
                    if(cClazz == nil){
                        value = nil;
                        continue;
                    }else{
                        id objs = [value isKindOfClass:[NSArray class]] ? [NSMutableArray new]: [NSMutableSet new];
                        for (NSObject * obj in value) {
                            id cvalue = [cClazz objectWithDictionary:obj];
                            if(cvalue){
                                if([value isKindOfClass:[NSArray class]]){
                                    [((NSMutableArray *)objs) addObject:cvalue];
                                }else{
                                    [((NSMutableSet *)objs) addObject:cvalue];
                                }
                            };
                        }
                        value = objs;
                    }
                }else if(![NSObject canParseClass:clazz]){
                    value = [clazz objectWithDictionary:value];
                }
            }else if(typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}'){
                value = nil;
                continue;
//                NSInvocation *invocaton = [PYInvoke startInvoke:target action:sel_getUid(key.UTF8String)];
//                if(invocaton){
//                    value = [NSValue valueWithBytes:((NSData*)value).bytes objCType:typeEncoding];
//                    void * v = malloc(((NSData*)value).length);
//                    [value getValue:v];
//                    [PYInvoke setInvoke:v index:2 invocation:invocaton];
//                    free(v);
//                    value = nil;
//                    continue;
//                }
            }
            if(value){
                @try {
                    [target setValue:value forKey:_key_];
                } @catch (NSException *exception) {
                    printf("%s:%s\n",exception.name.UTF8String, exception.reason.UTF8String);
                }
            }
        }
    }
    return target;
}

-(NSObject*) objectToDictionary{
    return [NSObject objectToDictionaryWithObject:self deep:0 hashStr:[NSMutableString new] fliteries:nil];
}
-(NSObject*) objectToDictionaryWithFliteries:(nonnull NSArray<Class> *) fliteries{
    return [NSObject objectToDictionaryWithObject:self deep:0 hashStr:[NSMutableString new] fliteries:fliteries];
}
+(NSObject*) objectToDictionaryWithObject:(nonnull NSObject *) object deep:(int) deep hashStr:(nonnull NSMutableString *) hashStr fliteries:(nullable NSArray<Class> *) fliteries{
    if ([NSObject canParseClass:object.class]){
        return object;
    }
    NSString * hash = @(object.hash).stringValue;
    if(fliteries && fliteries.count > 0 && [fliteries containsObject:object.class]){
        return  [object description];
    }
    if(deep > 5 || [hashStr containsString:hash]){
        return nil;
    }
    [hashStr appendString:hash];
    [hashStr appendString:@","];
    
    static NSDictionary *PYObjectSuperPropertNameDic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PYObjectSuperPropertNameDic = @{@"hash":@YES,@"superclass":@YES,@"description":@YES,@"debugDescription":@YES};
    });
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    unsigned int outCount2;
    Ivar *ivars = class_copyIvarList([object class], &outCount2);
    @try {
        void (^block) (NSMutableDictionary * dict, NSObject * obj, NSString * key, const char * typeEncoding) = ^(NSMutableDictionary * dict, NSObject * obj,NSString * key, const char * typeEncoding){
            if(((NSNumber *)PYObjectSuperPropertNameDic[key]).boolValue){
                return;
            }
            NSObject * returnValue = nil;
            size_t tedl = strlen(typeEncoding);
            if(tedl > 1){
                if(typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}'){
//                    NSInvocation *invocaton = [PYInvoke startInvoke:obj action:sel_getUid(key.UTF8String)];
//                    if(invocaton == nil) return;
//                    __block void * ptr;
//                    [PYInvoke excuInvoke:ptr returnType:nil invocation:invocaton];
//                    NSUInteger size = invocaton.methodSignature.methodReturnLength;
//                    returnValue = [NSData dataWithBytes:ptr length:size];
                    return;
                }else if(typeEncoding[0] == '@' && typeEncoding[1] == '?'){
                    return;
                }
            }
            @try {
                returnValue = [obj valueForKey:key];
            } @catch (NSException *exception) {
                returnValue = nil;
                printf("%s:%s\n",exception.name.UTF8String, exception.reason.UTF8String);
            }
            if(!returnValue){
                return;
            }
            if ([returnValue isKindOfClass:[NSArray class]]) {
                NSMutableArray * objs = [NSMutableArray new];
                for (id obj in (NSArray*)returnValue) {
                    id value = [NSObject objectToDictionaryWithObject:obj deep:deep+1 hashStr:hashStr fliteries:fliteries];
                    if(value)[objs addObject:value];
                }
                returnValue = objs;
            }else if ([returnValue isKindOfClass:[NSSet class]]) {
                NSMutableArray * objs = [NSMutableArray new];
                for (NSObject * obj in (NSSet*)returnValue) {
                    NSObject * value =  [NSObject objectToDictionaryWithObject:obj deep:deep+1 hashStr:hashStr fliteries:fliteries];
                    if(value)[objs addObject:value];
                }
                returnValue = objs;
            }else if(typeEncoding[0] == '@' && ![NSObject canParseClass:[returnValue class]]) {
                returnValue = [NSObject objectToDictionaryWithObject:returnValue deep:deep+1 hashStr:hashStr fliteries:fliteries];
            }else if([returnValue isKindOfClass:[UIResponder class]]) {
                returnValue = [returnValue description];
            }
            if(!returnValue){
                return;
            }
            [dict setObject:returnValue forKey:key];
        };
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            const char * typeEncoding;
            if(property){
                unsigned int count;
                objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
                typeEncoding = attribute[0].value;
            }
            block(dict, object, propertyName, typeEncoding);
        }
        
        for (int i = 0; i < outCount2; i++) {
            Ivar ivar = ivars[i];
            NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if([[ivarName substringToIndex:1] isEqual:@"_"]){
                ivarName =  [ivarName substringFromIndex:1];
            }
            if([dict valueForKey:ivarName] != nil) continue;
            const char * typeEncoding = ivar_getTypeEncoding(ivar);
            block(dict, object, ivarName, typeEncoding);
        }
    }
    @finally {
        free(properties);
        free(ivars);
    }
    
    return dict;
}

@end
