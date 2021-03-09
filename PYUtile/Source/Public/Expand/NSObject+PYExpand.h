//
//  NSObejct+PYExpand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol PYObjectParseProtocol <NSObject>

@optional
-(nullable NSArray *) pyObjectGetKeysForParseValue;

@end

extern id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding);

/**
 归档实体数据
 由于Object-c的反射不支持泛型所以如果对数组进行归档和解析时必须使用(property_??/ivar_??)进行泛型的指定
 */
@interface NSObject(PYExpand)
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

@end

#pragma 以下是私有库实现

@interface NSObject(PYCopyObject)
#pragma 复制对象=========================================>
/**
 复制对象
 */
-(nullable instancetype) deepCopyObject;
/**
 (同一类型)复制对象值到另一个对象
 */
+(nullable NSObject *) copyValueFromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj;
#pragma 复制对象=========================================<
@end

/**
 归档实体数据
 由于Object-c的反射不支持泛型所以如果对数组进行归档和解析时必须使用(property_??/ivar_??)进行泛型的指定
 */
@interface NSObject(PYParseToDictionary)

#pragma 数据对象化=========================================>
/**
 @param dictionary
 */
#pragma mark 通过JSON初始化对象
+(nullable instancetype) objectWithDictionary:(nonnull NSObject *) dictionary;

/**
 支持的property类型有:Object对象 ,CGSize,CGPoint,CGRect,NSRange,UIEdgeInsets,CGVector,UIOffset,CLLocationCoordinate2D
 @param dictionary
 @param clazz
 */
#pragma mark 通过JSON初始化对象
+(nullable id) objectWithDictionary:(nonnull NSObject*) dictionary clazz:(nullable Class) clazz;
#pragma 数据对象化=========================================<


#pragma 归档对象=========================================>

#pragma mark 通过对象生成JSON
-(nullable NSObject*) objectToDictionary;
/**
 支持的property类型有:Object对象 ,CGSize,CGPoint,CGRect,NSRange,UIEdgeInsets,CGVector,UIOffset,CLLocationCoordinate2D
 @param fliteries 过滤标识
 @param deepClass 遍历深度标识
 */
#pragma mark 通过对象生成JSON
-(nullable NSObject*) objectToDictionaryWithClass:(nullable Class) clazz;


#pragma 归档对象=========================================<

/**
 @param dictionary
 */
#pragma mark 通过dictionary解析出实体结构
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary;


#pragma 对象转化成表单==========================================>
/**
 将当前对象装换成form表单
 如果数组需要index, 这要使用has_index_{propertyname}标记
 */
-(nullable NSString *) objectToFormWithSuffix;
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
-(nullable NSString *) objectToFormWithSuffix:(nullable NSString *) suffix deepClass:(nullable Class) clazz;
#pragma 对象转化成表单==========================================<

/**
 通过dictionary解析出实体结构
 参考
 */
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary;
@end
