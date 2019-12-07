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
#pragma hook method originalSel:当前action exchangeSel:交换action
//=======================================================>
+(BOOL) hookInstanceOriginalSel:(nonnull SEL) originalSel exchangeSel:(nonnull SEL) exchangeSel;
+(BOOL) hookStaticOriginalSel:(nonnull SEL) originalSel exchangeSel:(nonnull SEL) exchangeSel;
///<=======================================================

//=======================================================>
#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数
+(BOOL) hookInstanceMethodName:(nonnull NSString *) methodName;
+(BOOL) hookStaticMethodName:(nonnull NSString *) methodName;
///<=======================================================

+(BOOL) addInstanceMethod:(nonnull Method) method;

/**
 void(^demoBlock)(id target) =^(id) { NSLog(@"demo");};
 int(^addBlock)(id target, int) =^(id target,int x, int y) { return x +y;};
 */
//=======================================================>
#pragma hook实例方法，使用block替换原方法，使用invoke执行原方法 自动添加一个exchange{methodName}首字母大写的函数
 +(BOOL) hookInstanceMethodWithSel:(nonnull SEL) originalSel block:(nonnull id) exchangeBlock;
 -(void) invokeOrginalWithSel:(nonnull SEL) originalSel returnValue:(nullable void*) returnValue params:(nullable void*) param,...NS_REQUIRES_NIL_TERMINATION;
 ///<=======================================================
@end
