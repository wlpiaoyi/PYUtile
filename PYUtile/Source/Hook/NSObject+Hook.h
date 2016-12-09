//
//  NSObject+Hook.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 hook 转屏 delegate
 */
@protocol NSObjectHookBaseDelegate<NSObject>
@optional
-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target;
@end

@interface NSObject(Hook)
+(nullable NSHashTable<id<NSObjectHookBaseDelegate>> *) delegateBase;
/**
 hook Controller 的方法
 规则: method , exchangeMethod
 */
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames;
+(BOOL) hookMethodWithName:(nonnull NSString *) name;
@end
