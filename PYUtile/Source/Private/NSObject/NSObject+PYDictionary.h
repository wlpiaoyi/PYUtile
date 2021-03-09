//
//  NSObject+PYDictionary.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/3.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

//extern id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding);

//@protocol PYObjectParseProtocol <NSObject>
//
//@optional
//-(nullable NSArray *) pyObjectGetKeysForParseValue;
//
//@end

@interface NSObject(PYDictionary)

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

@end

