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

@implementation NSObject(PYForm)
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

@end
