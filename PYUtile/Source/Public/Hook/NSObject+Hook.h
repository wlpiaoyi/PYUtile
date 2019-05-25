//
//  NSObject+Hook.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/15.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface NSObject(Hook)
#pragma hook method originalAction:当前action exchangeAction:交换action ========>
+(BOOL) hookInstanceOriginalAction:(nonnull SEL) originalAction exchangeAction:(nonnull SEL) exchangeAction;
+(BOOL) hookStaticOriginalAction:(nonnull SEL) originalAction exchangeAction:(nonnull SEL) exchangeAction;
#pragma hook method originalAction:当前action exchangeAction:交换action <========

#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数====>
+(BOOL) hookInstanceMethodName:(nonnull NSString *) methodName;
+(BOOL) hookStaticMethodName:(nonnull NSString *) methodName;
#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数<====

+(BOOL) addInstanceMethod:(nonnull Method) method;
@end
