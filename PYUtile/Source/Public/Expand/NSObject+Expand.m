//
//  NSobject+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "PYInvoke.h"
#import "PYUtile.h"
#import "PYArchiveObject.h"
#import "PYArchiveParse.h"
#import "PYParseDictionary.h"
#import "NSString+Expand.h"
#import "PYObjectCopy.h"

id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding) = nil;

@implementation NSObject(toDictionary)
/**
 当前Class是否是指定的class
 0：不是
 1：同类型
 2：子类
 */
+(int) isMemberForClazz:(nonnull Class) memberForClazz{
    return [PYArchiveParse clazz:self isMemberForClazz:memberForClazz];
}
/**
 是否是本地库的Class
 */
+(BOOL) isNativelibraryClass{
   return  [NSBundle bundleForClass:self] != NSBundle.mainBundle;
}

/**
 复制对象
 */
-(nullable instancetype) deepCopyObject;{
    id objCopy = [self.class new];
    objCopy = [self.class copyValueFromObj:self toObj:objCopy];
    return objCopy;
}

/**
 复制同一类型 对象值到另一个对象
 */
+(nullable NSObject *) copyValueFromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj;{
    return [PYObjectCopy copyValueWithClass:self fromObj:fromObj toObj:toObj];
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
    return [PYParseDictionary instanceClazz:clazz dictionary:dictionary];
}

-(NSObject*) objectToDictionary{
    return [self objectToDictionaryWithFliteries:nil];
}
-(NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries{
    return [PYArchiveObject archvie:self clazz:self.class deep:0 fliteries:fliteries];
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
        NSDictionary * dict = (NSDictionary *)[PYArchiveObject archvie:self clazz:clazz deep:0 fliteries:fliteries];
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
        if([PYArchiveParse canParset:[object class]]){
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
    
    if([PYArchiveParse canParset:[object class]]){
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
            keySuffix = kFORMAT(@"%@[%@]", suffix, [PYArchiveParse parseVarToKey:name]);
        }else keySuffix = [PYArchiveParse parseVarToKey:name];
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
        key = [PYArchiveParse parseKeyToVar:key];
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
        }else{
            return kFORMAT(@"kPNSNA id %@;\n", key);
        }
    }
    return nil;
}

@end
