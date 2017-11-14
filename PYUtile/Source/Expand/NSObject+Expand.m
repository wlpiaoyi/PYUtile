//
//  NSobject+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import "NSData+Expand.h"
#import "NSString+Expand.h"
#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "PYInvoke.h"
#import "PYUtile.h"
static char * PYObjectParsedictFailedKey = "pyobj_parsed_failed";
static NSArray * NSObjectToDictionaryPaserClasses;
static NSDictionary * NSObjectToDictionaryKeyPaseDict;
static id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding) = ^id (NSInvocation * _Nonnull invocatioin, const char * typeEncoding){
    return nil;
};

@implementation NSObject(toDictionary)
+(NSDictionary *) pyutile_objectKeyPaseDict{
    if (NSObjectToDictionaryKeyPaseDict == nil) {
        NSObjectToDictionaryKeyPaseDict = @{
                                            @"id":@"keyId",@"keyId":@"id",
                                            };
    }
    return NSObjectToDictionaryKeyPaseDict;
}
+(NSArray *) pyutile_objectParseClasses{
    if (NSObjectToDictionaryPaserClasses == nil) {
        NSObjectToDictionaryPaserClasses = @[[NSURL class]
                                             ,[NSNumber class]
                                             ,[NSString class]
                                             ,[NSDate class]
                                             ,[NSData class]];
    }
    return NSObjectToDictionaryPaserClasses;
}
+(BOOL) pyutile_canParseClass:(Class) clazz{
    for (Class c in [self pyutile_objectParseClasses]) {
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
+(const char *) pyutile_getTypeEncodingForProperty:(objc_property_t) property ivar:(Ivar) ivar{
    if(property){
        unsigned int count;
        objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
        return attribute[0].value;
    }else if(ivar){
        return ivar_getTypeEncoding(ivar);
    }
    return "";
}
+(Class) pyutile_getClassForTypeEncoding:(const char *) typeEncoding{
    size_t tedl = strlen(typeEncoding);
    if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
        if(strlen(typeEncoding)){
            NSArray * classArgs = [[NSString stringWithUTF8String:typeEncoding] componentsSeparatedByString:@"\""];
             return NSClassFromString(classArgs[1]);
        }
    }
    return nil;
}
/**
 通过JSON初始化对象
 */
+(id) objectWithDictionary:(NSObject*) dictionary clazz:(Class) clazz{
    
    id result = [self dictParset:dictionary clazz:clazz];
    if(result) return result;
    
    if(![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if([clazz isSubclassOfClass:[NSDictionary class]]) return dictionary;
    
    id target = [[clazz alloc] init];
    if (target) {
        for (NSString *key in [((NSDictionary *)dictionary) allKeys]) {
            NSString * _key_ = key;
            if ([NSObject pyutile_objectKeyPaseDict][key]) {
                _key_ = [NSObject pyutile_objectKeyPaseDict][key];
            }
            
            id value = ((NSDictionary *)dictionary)[key];
            if (value == nil || value == [NSNull null]) {
                continue;
            }
            __block const char * typeEncoding = "";
            bool (^blockExcute)(NSString * key) = ^bool(NSString * key){
                objc_property_t property = class_getProperty(clazz, key.UTF8String);
                Ivar ivar = class_getInstanceVariable(clazz, key.UTF8String);
                if(property || ivar){
                    typeEncoding = [NSObject pyutile_getTypeEncodingForProperty:property ivar:ivar];
                } else {
                    kPrintLogln("the class [%s] has no ivar [%s]", NSStringFromClass(clazz).UTF8String, key.UTF8String);
                    return false;
                }
                return true;
            };
            if(!blockExcute(_key_)){
                _key_ = [NSString stringWithFormat:@"_%@",_key_];
                if(!blockExcute(_key_)){
                    continue;
                }
            }
            
            if(strlen(typeEncoding) <= 0){
                kPrintExceptionln("the class [%s]'s ivar [%s] has not found typeEncoding", NSStringFromClass(clazz).UTF8String, _key_.UTF8String);
                continue;
            }
            
            size_t tedl = strlen(typeEncoding);
            if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
                Class cClazz = [NSObject pyutile_getClassForTypeEncoding:typeEncoding];
                if(cClazz == nil){
                    value = nil;
                    continue;
                }
                
                if ([cClazz isSubclassOfClass:[NSArray class]] || [cClazz isSubclassOfClass:[NSSet class]]) {
                    objc_property_t cproperty = class_getProperty(clazz, [NSString stringWithFormat:@"property_%@",_key_].UTF8String);
                    Ivar civar = class_getInstanceVariable(clazz, [NSString stringWithFormat:@"ivar_%@",_key_].UTF8String);
                    Class arrayClazz = nil;
                    if(cproperty || civar){
                        const char * teding = [NSObject pyutile_getTypeEncodingForProperty:cproperty ivar:civar];
                        arrayClazz = [NSObject pyutile_getClassForTypeEncoding:teding];
                    }
                    id objs = [cClazz isSubclassOfClass:[NSArray class]] ? [NSMutableArray new]: [NSMutableSet new];
                    for (NSObject * obj in value) {
                        id cvalue = nil;
                        if(arrayClazz){
                            cvalue = [arrayClazz objectWithDictionary:obj];
                        }else if([NSObject pyutile_canParseClass:[obj class]]){
                            cvalue = obj;
                        }
                        if(cvalue){
                            if([objs isKindOfClass:[NSArray class]]){
                                [((NSMutableArray *)objs) addObject:cvalue];
                            }else{
                                [((NSMutableSet *)objs) addObject:cvalue];
                            }
                        }
                    }
                    value = objs;
                }else if([NSObject pyutile_canParseClass:cClazz]){
                    value = [self dictParset:value clazz:cClazz];
                }else{
                    Class  cClazz = NSClassFromString([[[NSString stringWithUTF8String:typeEncoding] substringToIndex:tedl-1] substringFromIndex:2]);
                    value = [cClazz objectWithDictionary:value];
                }
            }else if((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}')){//结构体赋值
                NSData * tempData = [((NSString *) value) toData];
                tempData = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
                value = [NSValue valueWithBytes:tempData.bytes objCType:typeEncoding];
            }else if (strcasecmp(typeEncoding, @encode(SEL)) == 0){
                NSString * setActionName = [NSString stringWithFormat:@"set%@%@:", [[_key_ uppercaseString] substringToIndex:1], [_key_ substringFromIndex:1]];
                NSInvocation *invocation = [PYInvoke startInvoke:target action:sel_getUid(setActionName.UTF8String)];
                if (invocation
                    && [value isKindOfClass:[NSString class]]){
                    NSData * tempData = [((NSString *) value) toData];
                    value = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
                    value = [NSValue valueWithBytes:((NSData*)value).bytes objCType:typeEncoding];
                    SEL v;
                    [value getValue:&v];
                    [PYInvoke setInvoke:&v index:2 invocation:invocation];
                    [PYInvoke excuInvoke:nil returnType:nil invocation:invocation];
                }
                value = nil;
            }
            if(value){
                @try {
                    [target setValue:value forKey:_key_];
                } @catch (NSException *exception) {
                    kPrintExceptionln("%s:%s",exception.name.UTF8String, exception.reason.UTF8String);
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
    
    id result = [self objectParset:object];
    if(result) return result;
    
    result = [self objectCheck:object deep:deep hashStr:hashStr fliteries:fliteries];
    if(result) return result;
    
    if([object isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * tempDict = [NSMutableDictionary new];
        for (NSString * key in (NSDictionary *)object) {
            NSObject * value = ((NSDictionary *)object)[key];
            if(!value) continue;
            if ([NSObject pyutile_canParseClass:value.class]){
                value = [NSObject objectParset:value];
            }else{
                value = [NSObject objectToDictionaryWithObject:value deep:deep+1 hashStr:hashStr fliteries:fliteries];
            }
            if(!value) continue;
            tempDict[key] = value;
        }
        if(tempDict.count == 0){
            NSMutableString * key = [NSMutableString new];
            [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
            [key appendString:@"_nodictvalue"];
            return @{key : [object debugDescription]};
        }
        return tempDict;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    unsigned int outCount2;
    Ivar *ivars = class_copyIvarList([object class], &outCount2);
    @try {
        NSMutableString * removePName = [NSMutableString new];
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if(propertyName.length == 0) continue;
            const char * typeEncoding;
            bool flagCanExcute = true;
            unsigned int count;
            objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
            typeEncoding = attribute[0].value;
            char * ivarChars = "";
            for (int i = 0; i < count; i++) {
                if(strcasecmp("V", attribute[i].name) != 0) continue;
                ivarChars = (char *) attribute[i].value;
            }
            if(strcasecmp("", ivarChars) != 0){
                [removePName appendString:[NSString stringWithUTF8String:ivarChars]];
                [removePName appendString:@","];
            }
            unsigned long tedl = strlen(typeEncoding);
            if(strcasecmp(typeEncoding, @encode(id)) == 0
               || (tedl >= 4
                   && typeEncoding[0] == '@'
                   && typeEncoding[1] == '\"'
                   && typeEncoding[tedl - 1] == '\"')){
                   flagCanExcute = false;
                   for (int j = 0; j < count; j++) {//如果是弱连接则不会归档，因为指针值可能已经回收
                       if(strcasecmp(attribute[j].name, "&") == 0
                          || strcasecmp(attribute[j].name, "C") == 0){
                           flagCanExcute = true;
                           break;
                       }
                   }
               }
            if(flagCanExcute) [self PYObjectToDictionarySetkeyvalueWithDict:dict obj:object key:propertyName typeEncoding:typeEncoding deep:deep hashStr:hashStr fliteries:fliteries];
            else{
                kPrintLogln("the property '%s' type '%s' is assign, we can't archived it", propertyName.UTF8String, typeEncoding);
            }
        }
        
        for (int i = 0; i < outCount2; i++) {
            Ivar ivar = ivars[i];
            NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if([removePName containsString:ivarName]){
                continue;
            }
            if([dict valueForKey:ivarName] != nil) continue;
            const char * typeEncoding = ivar_getTypeEncoding(ivar);
            [self PYObjectToDictionarySetkeyvalueWithDict:dict obj:object key:ivarName typeEncoding:typeEncoding deep:deep hashStr:hashStr fliteries:fliteries];
        }
    }
    @finally {
        free(properties);
        free(ivars);
    }
    if(dict.count == 0){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_properyandivar"];
         return @{key : [object debugDescription]};
    }
    return dict;
}

#pragma mark 归档数据
+(void) PYObjectToDictionarySetkeyvalueWithDict:(NSMutableDictionary *) dict obj:(NSObject *) obj key:(NSString *) key typeEncoding:(const char *) typeEncoding
                                           deep:(int) deep hashStr:(nonnull NSMutableString *) hashStr fliteries:(nullable NSArray<Class> *) fliteries{
    static NSDictionary *PYObjectSuperPropertNameDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PYObjectSuperPropertNameDict = @{@"hash":@YES,@"superclass":@YES,@"description":@YES,@"debugDescription":@YES};
    });
    if(((NSNumber *)PYObjectSuperPropertNameDict[key]).boolValue)return;//过滤Obj特殊属性
    NSObject * returnValue = nil;
    size_t tedl = strlen(typeEncoding);
    if(tedl == 0) return;
    
    if(typeEncoding[0] == '@' && typeEncoding[1] == '?'){//如果是block则不取值
        kPrintExceptionln("%s","block archiving is not supported at this time");
        return;
    }else if(((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}'))){//如果是未知结构体则不取值
        NSInvocation *invocation = [PYInvoke startInvoke:obj action:sel_getUid(key.UTF8String)];
        if(invocation == nil) return;
        if(strcasecmp(typeEncoding, @encode(CGRect)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGRectEdge)) == 0){
            CGRectEdge ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGSize)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGPoint)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGVector)) == 0){
            CGVector ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(NSRange)) == 0){
            NSRange ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(UIEdgeInsets)) == 0){
            UIEdgeInsets ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(UIOffset)) == 0){
            UIOffset ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(PYBlocktodictParsetStruct){
            returnValue = PYBlocktodictParsetStruct(invocation,typeEncoding);
        }else return;
    }else if(strcasecmp(typeEncoding, @encode(SEL)) == 0){
        NSInvocation *invocation = [PYInvoke startInvoke:obj action:sel_getUid(key.UTF8String)];
        if(invocation == nil) return;
        SEL ptr;
        [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
        NSUInteger size = invocation.methodSignature.methodReturnLength;
        returnValue = [NSData dataWithBytes:&ptr length:size];
    }else{
        @try {
            returnValue = [obj valueForKey:key];
        } @catch (NSException *exception) {
            returnValue = nil;
            kPrintExceptionln("there has no value for propery or ivar that name is %s: [%s:%s]", key.UTF8String, exception.name.UTF8String, exception.reason.UTF8String);
        }
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
    }else if ([returnValue isKindOfClass:[NSDictionary class]]) {
        returnValue = [NSObject objectToDictionaryWithObject:returnValue deep:deep+1 hashStr:hashStr fliteries:fliteries];
    }else {
        id tempValue = [NSObject objectParset:returnValue];
        if(tempValue) returnValue = tempValue;
        else{
            returnValue = [NSObject objectToDictionaryWithObject:returnValue deep:deep+1 hashStr:hashStr fliteries:fliteries];
        }
    }
    if(!returnValue){
        return;
    }
    if([NSObject pyutile_canParseClass:returnValue.class]){
        returnValue = [NSObject objectParset:returnValue];
    }
    if([NSObject pyutile_objectKeyPaseDict][key])
        [dict setObject:returnValue forKey:[NSObject pyutile_objectKeyPaseDict][key]];
    else
        [dict setObject:returnValue forKey:key];
}
+(NSObject *) objectCheck:(NSObject *) object deep:(int) deep hashStr:(nonnull NSMutableString *) hashStr fliteries:(nullable NSArray<Class> *) fliteries{
    
    if(fliteries && fliteries.count > 0 && [fliteries containsObject:object.class]){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_fliteries"];
        return @{key : [object debugDescription]};
    }
    
    if(deep > 10){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_deep"];
        return @{key : [object debugDescription]};
    }
    
    if(hashStr){
        void * pointerValue = (__bridge void *)(object);
        NSString * hash = @((long) pointerValue).stringValue;
        if([hashStr containsString:hash]){
            NSMutableString * key = [NSMutableString new];
            [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
            [key appendString:@"_pointer"];
            return @{key : [object debugDescription]};
        }
        [hashStr appendString:hash];
        [hashStr appendString:@","];
    }
    return nil;
}
+(NSObject *) objectParset:(NSObject *) object{
    if ([NSObject pyutile_canParseClass:object.class]){
        NSObject * returnValue = nil;
        if([object isKindOfClass:[NSData class]]){
            returnValue = [((NSData *) object) toBase64String];
        }else if([object isKindOfClass:[NSDate class]]){
            returnValue = @([((NSDate *) object) timeIntervalSince1970]);
        }else if([object isKindOfClass:[NSURL class]]){
            returnValue = [((NSURL *) object) absoluteString];
        }else{
            returnValue = object;
        }
        if(!returnValue){
            NSMutableString * key = [NSMutableString new];
            [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
            [key appendString:@"_nobase"];
            returnValue = @{key : [object debugDescription]};
        }
        return returnValue;
    }
    return nil;
}
+(NSObject *) dictParset:(NSObject *) object clazz:(Class) clazz{
    NSObject * returnValue = nil;
    if ([NSObject pyutile_canParseClass:clazz]){
        if([clazz isSubclassOfClass:[NSData class]] && [object isKindOfClass:[NSString class]]){
            NSData * tempData = [((NSString *) object) toData];
            returnValue = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
        }else if([clazz isSubclassOfClass:[NSDate class]] && [object isKindOfClass:[NSNumber class]]){
            returnValue = [[NSDate alloc] initWithTimeIntervalSince1970:((NSNumber *)object).doubleValue];
        }else if([clazz isSubclassOfClass:[NSURL class]] && [object isKindOfClass:[NSString class]]){
            returnValue = [[NSURL alloc] initWithString:((NSString *) object)];
        }else{
            returnValue = object;
        }
    }
    return returnValue;
}

@end
