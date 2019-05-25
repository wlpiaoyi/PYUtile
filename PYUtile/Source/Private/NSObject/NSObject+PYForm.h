//
//  NSObject+PYForm.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/5.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject(PYForm)

#pragma 对象转化成表单==========================================>
/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix;
/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 @param suffix 表单前缀
 @param clazz 类型
 */
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix clazz:(nullable Class) clazz;
#pragma 对象转化成表单==========================================<

@end

