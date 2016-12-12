//
//  NSObejct+Expand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 归档实体数据
 由于Object-c的反射不支持泛型所以如果对数组进行归档和解析时必须使用(property_??)进行泛型的指定
 */
@interface NSObject(toDictionary)
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

@end
