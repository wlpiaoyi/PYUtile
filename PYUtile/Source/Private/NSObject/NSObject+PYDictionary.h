//
//  NSObject+PYDictionary.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/3.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding);

@protocol PYObjectParseProtocol <NSObject>

@optional
-(nullable NSArray *) pyObjectGetKeysForParseValue;

@end

@interface NSObject(PYDictionary)

#pragma 数据对象化=========================================>
/**
 通过JSON初始化对象
 */
+(nullable instancetype) objectWithDictionary:(nonnull NSObject*) dictionary;
/**
 通过JSON初始化对象
 */
+(nullable id) objectWithDictionary:(nonnull NSObject*) dictionary clazz:(nonnull Class) clazz;
#pragma 数据对象化=========================================<


#pragma 归档对象=========================================>
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
 通过对象生成JSON
 #param fliteries 过滤标识
 #param deepClass 遍历深度标识
 */
-(nullable NSObject*) objectToDictionaryWithFliteries:(nullable NSArray<Class> *) fliteries deepClass:(nullable Class) deepClass;
#pragma 归档对象=========================================<
/**
 通过dictionary解析出实体结构
 参考
 */
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary;

@end

