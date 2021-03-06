//
//  UIResponder+Hook.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
/**
 hook 转屏 delegate
 */
@protocol UIResponderHookBaseDelegate<NSObject>
@optional
-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target;
@end

@interface UIResponder(Hook)
+(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBaseHook;
/**
 hook Controller 的方法
 规则: method , exchangeMethod
 */
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames;
+(BOOL) hookMethodWithName:(nonnull NSString *) name;
@end
