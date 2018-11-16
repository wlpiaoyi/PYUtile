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
#import "PYUtile.h"
#import "NSString+Expand.h"
#import "NSNumber+Expand.h"
#import "NSDictionary+Expand.h"
#import "NSData+Expand.h"
#import "NSDate+Expand.h"

static char * PYObjectParsedictFailedKey = "pyobj_parsed_failed";
static NSArray * __PY_OBJ_TO_DICT_CLASS;
static NSDictionary * __PY_FIELD_KEY_NAME;
static NSDictionary * __PY_FIELD_HEAD_NAME;
static id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding) = ^id (NSInvocation * _Nonnull invocatioin, const char * typeEncoding){
    return nil;
};

@implementation NSObject(toDictionary)
/**
 是否是本地库的Class
 */
+(BOOL) isNativelibraryClass{
   return  [NSBundle bundleForClass:self] != NSBundle.mainBundle;
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
+(nullable id) objectWithDictionary:(NSObject*) dictionary clazz:(Class) clazz{
    
    if(dictionary == nil) return nil;
    
    id result = [self __PY_DICT_PASET:dictionary _CLAZZ:clazz];
    if(result) return result;
    
    if(![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if([clazz isKindOfClass:[NSDictionary class]] || [clazz isSubclassOfClass:[NSDictionary class]]) return dictionary;
    
    id target = [[clazz alloc] init];
    if (!target)  return nil;
    
    for (NSString *key in [((NSDictionary *)dictionary) allKeys]) {
        NSString * fieldKey = [NSObject __PY_OBJ_FIELD_KEY_CHECK:key];
        id value = ((NSDictionary *)dictionary)[key];
        if (value == nil || value == [NSNull null]) {
            continue;
        }
        __block const char * typeEncoding = "";
        bool (^blockExcute)(NSString * key) = ^bool(NSString * key){
            objc_property_t property = class_getProperty(clazz, key.UTF8String);
            Ivar ivar = class_getInstanceVariable(clazz, key.UTF8String);
            if(property || ivar){
                typeEncoding = [NSObject __PY_GET_TYPEENCODING_FOR_PROPERTY:property IVAR:ivar];
            } else {
                return false;
            }
            return true;
        };
        if(!blockExcute(fieldKey)){
            fieldKey = [NSString stringWithFormat:@"_%@",fieldKey];
            if(!blockExcute(fieldKey)){
                kPrintLogln("the class [%s] has no ivar [%s] type [%s]", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String, NSStringFromClass([value class]).UTF8String);
                continue;
            }
        }
        
        if(strlen(typeEncoding) <= 0){
            kPrintExceptionln("the class [%s]'s ivar [%s] has not found typeEncoding", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String);
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
                objc_property_t cproperty = class_getProperty(clazz, [NSString stringWithFormat:@"property_%@",fieldKey].UTF8String);
                Ivar civar = class_getInstanceVariable(clazz, [NSString stringWithFormat:@"ivar_%@",fieldKey].UTF8String);
                Class valuesClazz = nil;
                if(cproperty || civar){
                    const char * teding = [NSObject __PY_GET_TYPEENCODING_FOR_PROPERTY:cproperty IVAR:civar];
                    valuesClazz = [NSObject pyutile_getClassForTypeEncoding:teding];
                }
                if(valuesClazz){
                    value = [NSObject __PY_VALUE_FOREACH:value CLAZZ:valuesClazz];
                }else{
                    value = value;
                }
            }else if([NSObject __PY_CAN_PARSET_CLASS:cClazz]){
                value = [self __PY_DICT_PASET:value _CLAZZ:cClazz];
            }else{
                Class  cClazz = NSClassFromString([[[NSString stringWithUTF8String:typeEncoding] substringToIndex:tedl-1] substringFromIndex:2]);
                value = [cClazz objectWithDictionary:value];
            }
        }else if((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}')){//结构体赋值
            NSData * tempData = [((NSString *) value) toData];
            tempData = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
            value = [NSValue valueWithBytes:tempData.bytes objCType:typeEncoding];
        }else if (strcasecmp(typeEncoding, @encode(SEL)) == 0){
            NSString * setActionName = [NSString stringWithFormat:@"set%@%@:", [[fieldKey uppercaseString] substringToIndex:1], [fieldKey substringFromIndex:1]];
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
                [target setValue:value forKey:fieldKey];
            } @catch (NSException *exception) {
                kPrintExceptionln("%s:%s [key:%@ value:%@]",exception.name.UTF8String, exception.reason.UTF8String, fieldKey, value);
            }
        }
    }
    
    return target;
}

-(NSObject*) objectToDictionary{
    return [self objectToDictionaryWithFliteries:nil];
}
-(NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries{
    return [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:self CLAZZ:nil DEEP:0 FLITERIES:fliteries];
}

/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionaryWithDeepClass:(Class) deepClass{
    return [self objectToDictionaryWithFliteries:nil deepClass:deepClass];
}
/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries deepClass:(Class) deepClass{
    NSMutableDictionary *  result = [NSMutableDictionary new];
    Class clazz = [self class];
    while (true)  {
        if(clazz == [NSObject class]) break;
        NSDictionary * dict = (NSDictionary *)[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:self CLAZZ:clazz DEEP:0 FLITERIES:fliteries];
        if([dict isKindOfClass:[NSDictionary class]]){
            for (NSString * key in dict) {
                result[key] = dict[key];
            }
        }else if(result.count > 0){
            continue;
        }else{
            return dict;
        }
        if(clazz == deepClass) break;
        clazz = class_getSuperclass(clazz);
    }
    return result ;
}
/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix{
    return [NSObject __PY_FORM_WITH_SUFFIX:suffix OBJ:self CLAZZ:[self class] HASINDEX:NO];
}
/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 @param clazz 类型
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix clazz:(nullable Class) clazz{
    return [NSObject __PY_FORM_WITH_SUFFIX:suffix OBJ:self CLAZZ:clazz HASINDEX:NO];
}

/**
 通过dictionary解析出实体结构
 */
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary{
    NSMutableArray * otherStructs = [NSMutableArray new];
    [self __PY_DICT_ANALYSIS:dictionary KEY:nil CLASSNAME:@"BASE" otherStructs:otherStructs];
    NSMutableString * structStr = [NSMutableString new];
    for (NSString * oss in otherStructs) {
        [structStr appendString:oss];
    }
    return structStr;
}

+(nullable NSString *) __PY_FORM_WITH_SUFFIX:(nullable NSString *) suffix OBJ:(nonnull NSObject *) object CLAZZ:(nullable Class) clazz HASINDEX:(BOOL) hasIndex{
    if(suffix && suffix.length > 0){
        if([NSObject __PY_CAN_PARSET_CLASS:[object class]]){
            return kFORMAT(@"&%@=%@", suffix, [object objectToDictionary]);
        }else if([object isKindOfClass:[NSArray class]] && hasIndex){
            NSMutableString * form = [NSMutableString new];
            NSUInteger index = 0;
            for (NSObject * value in (NSArray *)object) {
                [form appendString:[self __PY_FORM_WITH_SUFFIX:kFORMAT(@"%@[%ld]", suffix, index) OBJ:value CLAZZ:nil HASINDEX:YES] ];
                index++;
            }
            return form;
        }else if([object isKindOfClass:[NSArray class]] && !hasIndex){
            NSMutableString * form = [NSMutableString new];
            for (NSObject * value in (NSArray *)object) {
                [form appendString:[self __PY_FORM_WITH_SUFFIX:kFORMAT(@"%@[]", suffix) OBJ:value CLAZZ:nil HASINDEX:NO]];
            }
            return form;
        }
    }
    
    if([NSObject __PY_CAN_PARSET_CLASS:[object class]]){
        kPrintErrorln("formWithSuffix[%s] erro!!\n", NSStringFromClass([object class]).UTF8String);
        return nil;
    }
    
    if(!clazz) clazz = [object class];
    NSMutableString * form = [NSMutableString new];
    NSArray<NSDictionary*>* properties = [PYInvoke getPropertyInfosWithClass:clazz];
    for (NSDictionary * property in properties) {
        NSString * name = property[@"name"];//
        NSObject * value = [object valueForKey:name];
        if(value == nil) continue;
        NSString * keySuffix = nil;
        if(suffix && suffix.length > 0){
            keySuffix = kFORMAT(@"%@[%@]", suffix, [NSObject __PY_OBJ_FIELD_KEY_CHECK:name]);
        }else keySuffix = [NSObject __PY_OBJ_FIELD_KEY_CHECK:name];
        BOOL __hasIndex = NO;
        if([value isKindOfClass:[NSArray class]]){
            __hasIndex = [PYInvoke getPropertyInfoWithClass:[object class] propertyName:kFORMAT(@"has_index_%@", name)] != nil;
        }
        [form appendString:[self __PY_FORM_WITH_SUFFIX:keySuffix OBJ:value CLAZZ:nil  HASINDEX:__hasIndex]];
    }
    
    return form;

}

+(nullable NSString *) __PY_DICT_ANALYSIS:(nonnull NSObject *) obj KEY:(nullable NSString *) key CLASSNAME:(nullable NSString *) className otherStructs:(nullable NSMutableArray *) otherStructs{
    if(!key && className){
        if([obj isKindOfClass:[NSDictionary class]]){
            NSMutableString * structStr = [NSMutableString new];
            [structStr appendFormat:@"@interface PYDA%@ : NSObject\n\n", className];
            for (NSString * k in (NSDictionary *)obj) {
                id value = ((NSDictionary *)obj)[k];
                [structStr appendString:[self __PY_DICT_ANALYSIS:value KEY:k CLASSNAME:nil otherStructs:otherStructs]];
            }
            [structStr appendString:@"\n@end\n\n\n"];
            [otherStructs addObject:structStr];
        }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSSet class]]){
            if(((NSArray *)obj).count > 0){
                [self __PY_DICT_ANALYSIS:((NSArray *)obj).firstObject KEY:nil CLASSNAME:className otherStructs:otherStructs];
            }
        }
    }else if (key){
        key = [NSObject __PY_OBJ_FIELD_KEY_CHECK:key];
        if([obj isKindOfClass:[NSString class]]){
            return kFORMAT(@"kPNSNA NSString * %@;//%@\n", key, [obj description]);
        }else if([obj isKindOfClass:[NSNumber class]]){
            if(((kInt64)(((NSNumber *)obj).doubleValue * 10)) % 10 != 0){
                return kFORMAT(@"kPNA CGFloat %@;//%@\n", key, [obj description]);
            }else{
                return kFORMAT(@"kPNA NSInteger %@;//%@\n", key, [obj description]);
            }
        }else if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSSet class]]){
            if(((NSArray *)obj).count > 0){
                [self __PY_DICT_ANALYSIS:((NSArray *)obj).firstObject KEY:nil CLASSNAME:key otherStructs:otherStructs];
            }
            return kFORMAT(@"kPNSNA NSArray * %@;\nkPNSNA PYDA%@ * property_%@;\n", key, key, key);
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [self __PY_DICT_ANALYSIS:obj KEY:nil CLASSNAME:key otherStructs:otherStructs];
            return kFORMAT(@"kPNSNA PYDA%@ * %@;\n", key, key);
        }
    }
    return nil;
}


+(NSObject*) __PY_OBJ_TO_DICT_WITH_OBJ:(nonnull NSObject *) object CLAZZ:(Class) clazz DEEP:(int) deep FLITERIES:(nullable NSArray<Class> *) fliteries{
    id result = [self __PY_OBJECT_PARSET:object];
    if(result) return result;
    
    result = [self __PY_OBJ_CHECK:object DEEP:deep FILTERIRES:fliteries];
    if(result) return result;
    if(!clazz) clazz = [object class];
    
    if([object isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * tempDict = [NSMutableDictionary new];
        for (NSString * key in (NSDictionary *)object) {
            NSObject * value = ((NSDictionary *)object)[key];
            if(!value) continue;
            if ([NSObject __PY_CAN_PARSET_CLASS:value.class]){
                value = [NSObject __PY_OBJECT_PARSET:value];
            }else{
                value = [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:value CLAZZ:clazz DEEP:deep+1 FLITERIES:fliteries];
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
    }else if([object isKindOfClass:[NSArray class]]){
        NSMutableArray * tempArray = [NSMutableArray new];
        for (id obj in (NSArray *)object) {
            [tempArray addObject:[obj objectToDictionary]];
        }
        return tempArray;
    }else if([object isKindOfClass:[NSSet class]]){
        NSMutableSet * tempSet = [NSMutableSet new];
        for (id obj in (NSSet *)object) {
            [tempSet addObject:[obj objectToDictionary]];
        }
        return tempSet;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    unsigned int outCount2;
    Ivar *ivars = class_copyIvarList(clazz, &outCount2);
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
            if(flagCanExcute) [self __PY_OBJ_TO_DICT_KEYVALUE_WITH_DICT:dict CLAZZ:clazz OBJ:object KEY:propertyName TYPE_ENCODING:typeEncoding deep:deep  fliteries:fliteries];
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
            [self __PY_OBJ_TO_DICT_KEYVALUE_WITH_DICT:dict CLAZZ:clazz OBJ:object KEY:ivarName TYPE_ENCODING:typeEncoding deep:deep fliteries:fliteries];
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
+(void) __PY_OBJ_TO_DICT_KEYVALUE_WITH_DICT:(NSMutableDictionary *) dict CLAZZ:(Class) clazz OBJ:(NSObject *) obj KEY:(NSString *) key TYPE_ENCODING:(const char *) typeEncoding
                                           deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries{
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
            id value = [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
            if(value)[objs addObject:value];
        }
        returnValue = objs;
    }else if ([returnValue isKindOfClass:[NSSet class]]) {
        NSMutableArray * objs = [NSMutableArray new];
        for (NSObject * obj in (NSSet*)returnValue) {
            NSObject * value =  [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
            if(value)[objs addObject:value];
        }
        returnValue = objs;
    }else if ([returnValue isKindOfClass:[NSDictionary class]]) {
        returnValue = [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1 FLITERIES:fliteries];
    }else {
        id tempValue = [NSObject __PY_OBJECT_PARSET:returnValue];
        if(tempValue) returnValue = tempValue;
        else{
            returnValue = [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1  FLITERIES:fliteries];
        }
    }
    if(!returnValue){
        return;
    }
    if([NSObject __PY_CAN_PARSET_CLASS:returnValue.class]){
        returnValue = [NSObject __PY_OBJECT_PARSET:returnValue];
    }
    [dict setObject:returnValue forKey:[NSObject __PY_OBJ_FIELD_KEY_CHECK:key]];
}

+(const char *) __PY_GET_TYPEENCODING_FOR_PROPERTY:(objc_property_t) property IVAR:(Ivar) ivar{
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

+(NSObject *) __PY_OBJ_CHECK:(NSObject *) object DEEP:(int) deep FILTERIRES:(nullable NSArray<Class> *) fliteries{
    
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
    return nil;
}
+(NSObject *) __PY_OBJECT_PARSET:(NSObject *) object{
    if ([NSObject __PY_CAN_PARSET_CLASS:object.class]){
        NSObject * returnValue = nil;
        if([object isKindOfClass:[NSData class]]){
            returnValue = [((NSData *) object) toString];
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
+(NSObject *) __PY_DICT_PASET:(NSObject *) object _CLAZZ:(Class) clazz{
    NSObject * returnValue = nil;
    if ([NSObject __PY_CAN_PARSET_CLASS:clazz]){
        if([clazz isSubclassOfClass:[NSData class]] && [object isKindOfClass:[NSString class]]){
            NSData * tempData = [((NSString *) object) toData];
            returnValue = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
        }else if([clazz isSubclassOfClass:[NSDate class]] && [object isKindOfClass:[NSNumber class]]){
            if(((NSNumber *)object).doubleValue > [NSDate date].timeIntervalSince1970 * 100.){
                returnValue = [[NSDate alloc] initWithTimeIntervalSince1970:((NSNumber *)object).doubleValue / 1000.];
            }else{
                returnValue = [[NSDate alloc] initWithTimeIntervalSince1970:((NSNumber *)object).doubleValue];
            }
        }else if([clazz isSubclassOfClass:[NSURL class]] && [object isKindOfClass:[NSString class]]){
            returnValue = [[NSURL alloc] initWithString:((NSString *) object)];
        }else{
            returnValue = object;
        }
    }
    return returnValue;
}

+(nonnull NSString *) __PY_OBJ_FIELD_KEY_CHECK:(nonnull NSString *) name{
    if (__PY_FIELD_KEY_NAME == nil) {
        __PY_FIELD_KEY_NAME = @{
                              @"id":@"keyId",@"keyId":@"id",
                              @"description":@"keyDescription", @"keyDescription":@"description"
                                            };
    }
    if(__PY_FIELD_HEAD_NAME == nil){
        __PY_FIELD_HEAD_NAME = @{
                               @"new":@"keyNew",@"keyNew":@"new"
                               };
    }
    
    NSString * pname = __PY_FIELD_KEY_NAME[name];
    if(pname) return pname;
    
    for (NSString * key in __PY_FIELD_HEAD_NAME) {
        NSRange range = [name rangeOfString:key];
        if(range.length > 0 && range.location == 0){
            pname = [name stringByReplacingCharactersInRange:range withString:__PY_FIELD_HEAD_NAME[key]];
            break;
        }
    }
    if(pname) return pname;
    
    return name;
    
}
+(NSArray *) __PY_OBJ_PARSET_CLASSES{
    if (__PY_OBJ_TO_DICT_CLASS == nil) {
        __PY_OBJ_TO_DICT_CLASS = @[[NSURL class]
                                             ,[NSNumber class]
                                             ,[NSString class]
                                             ,[NSDate class]
                                             ,[NSData class]];
    }
    return __PY_OBJ_TO_DICT_CLASS;
}
+(BOOL) __PY_CAN_PARSET_CLASS:(Class) clazz{
    for (Class c in [self __PY_OBJ_PARSET_CLASSES]) {
        if (c == clazz ||  [clazz isSubclassOfClass:c]) {
            return true;
        }
    }
    return false;
}

+(NSObject *) __PY_VALUE_FOREACH:(NSObject *) value CLAZZ:(Class) clazz{
    
    if(value == nil) return nil;
    
    if([value isKindOfClass:[NSArray class]]){
        NSMutableArray * result = [NSMutableArray new];
        for (NSObject * obj in (NSArray *)value) {
            id addObj = [NSObject __PY_VALUE_FOREACH:obj CLAZZ:clazz];
            if(addObj)[result addObject: addObj];
            else kPrintExceptionln("the add value is null obj:[%@] class:[%@]", obj, NSStringFromClass(clazz));
        }
        return result;
    }else if([value isKindOfClass:[NSSet class]]){
        NSMutableSet * result = [NSMutableSet new];
        for (NSObject * obj in (NSSet *)value) {
            id addObj = [NSObject __PY_VALUE_FOREACH:obj CLAZZ:clazz];
            if(addObj)[result addObject: addObj];
            else kPrintExceptionln("the add value is null obj:[%@] class:[%@]", obj, NSStringFromClass(clazz));
        }
        return result;
    }else{
        return [NSObject objectWithDictionary:value clazz:clazz];
    }
    
}

@end
