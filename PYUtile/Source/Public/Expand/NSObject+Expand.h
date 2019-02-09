//
//  NSObejct+Expand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//


#import <Foundation/Foundation.h>

extern id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding);

/**
 归档实体数据
 由于Object-c的反射不支持泛型所以如果对数组进行归档和解析时必须使用(property_??/ivar_??)进行泛型的指定
 */
@interface NSObject(toDictionary)
/**
 当前Class是否是指定的class
 0：不是
 1：同类型
 2：子类
 */
+(int) isMemberForClazz:(nonnull Class) memberForClazz;
/**
 是否是本地库的Class
 */
+(BOOL) isNativelibraryClass;
/**
 通过JSON初始化对象
 */
+(nullable instancetype) objectWithDictionary:(nonnull NSObject*) dictionary;
/**
 通过JSON初始化对象
 */
+(nullable id) objectWithDictionary:(nonnull NSObject*) dictionary clazz:(nonnull Class) clazz;
/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionary;
/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries;
/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionaryWithDeepClass:(nullable Class) deepClass;

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
/**
 通过对象生成JSON
 #param fliteries 过滤标识
 #param deepClass 遍历深度标识
 */
-(nullable NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries deepClass:(nullable Class) deepClass;

/**
 通过dictionary解析出实体结构
 参考
 */
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary;

@end
