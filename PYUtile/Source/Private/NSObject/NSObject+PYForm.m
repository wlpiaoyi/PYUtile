//
//  NSObject+PYForm.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/5.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+PYForm.h"
#import "PYUtile.h"
#import "PYInvoke.h"
#import "PYArchiveParse.h"
#import "NSObject+PYDictionary.h"

#import <objc/runtime.h>

int printf(const char * __restrict, ...) __printflike(1, 2);

@implementation NSObject(PYForm)

/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 */
-(nullable NSString *) objectToFormWithSuffix{
    return [NSObject objectToFormWithSuffix:nil];
}

/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix{
    return [NSObject __PY_FORM_WITH_SUFFIX:suffix OBJ:self CLAZZ:nil DEEP_CLAZZ:nil];
}

/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 @param deepClazz 类型
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix deepClass:(nullable Class) deepClazz{
    return [NSObject __PY_FORM_WITH_SUFFIX:suffix OBJ:self CLAZZ:nil DEEP_CLAZZ:deepClazz];
}

+(nullable NSString *) __PY_FORM_WITH_SUFFIX:(nullable NSString *) suffix OBJ:(nonnull NSObject *) object CLAZZ:(nullable Class) clazz DEEP_CLAZZ:(nullable Class) deepClazz{
    
    if(suffix && suffix.length > 0){
        if([PYArchiveParse canParset:[object class]]){
            return kFORMAT(@"&%@=%@", suffix, [object objectToDictionary]);
        }else if([object isKindOfClass:[NSArray class]]){
            NSMutableString * form = [NSMutableString new];
            NSUInteger index = 0;
            for (NSObject * value in (NSArray *)object) {
                [form appendString:[self __PY_FORM_WITH_SUFFIX:kFORMAT(@"%@[%ld]", suffix, index) OBJ:value CLAZZ:clazz DEEP_CLAZZ:deepClazz]];
                index++;
            }
            return form;
        }else if([object isKindOfClass:[NSArray class]]){
            NSMutableString * form = [NSMutableString new];
            for (NSObject * value in (NSArray *)object) {
                [form appendString:[self __PY_FORM_WITH_SUFFIX:kFORMAT(@"%@[]", suffix) OBJ:value CLAZZ:clazz DEEP_CLAZZ:deepClazz]];
            }
            return form;
        }
    }
    
    if([object class] == [NSObject class]){;
        return nil;
    }
    
    if([PYArchiveParse canParset:[object class]]){;
        return nil;
    }
    
    if(deepClazz == nil) deepClazz = [object class];
    if(clazz == nil) clazz = [object class];
    
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
        BOOL hasIndex = NO;
        if([value isKindOfClass:[NSArray class]]){
            hasIndex = [PYInvoke getPropertyInfoWithClass:[object class] propertyName:kFORMAT(@"has_index_%@", name)] != nil;
        }
        [form appendString:[self __PY_FORM_WITH_SUFFIX:keySuffix OBJ:value CLAZZ:clazz DEEP_CLAZZ:deepClazz]];
    }
    
    if(clazz == deepClazz) return form;
    clazz = class_getSuperclass(clazz);
    
    [form appendString:[self __PY_FORM_WITH_SUFFIX:suffix OBJ:object CLAZZ:clazz DEEP_CLAZZ:deepClazz]];
    
    return form;
}

@end
