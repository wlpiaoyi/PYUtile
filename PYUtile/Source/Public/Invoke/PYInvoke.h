//
//  PYInvoke.h
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 注意事项:
 如果void * returnValue是一个人对象切记要使用 (__bridge id _Nullable)(returnValue)，否则会出现内存泄露
 */
@interface PYInvoke : NSObject
//==>分布执行方法
+ (nullable id) startInvoke:(nonnull id) target action:(nonnull SEL)action;
+ (void) setInvoke:(nullable void *) param index:(NSInteger) index invocation:(nonnull const id) invocation;
+ (void) excuInvoke:(nullable void*)returnValue returnType:(char * _Nullable * _Nullable) returnType invocation:(nonnull const id) invocation;
+ (void) excuInvoke:(nullable void*)returnValue returnType:(char * _Nullable * _Nullable) returnType invocation:(nonnull const id) invocation isRetainArguments:(BOOL) isRetainArguments;
///<==
//单步执行反射方法
+ (void) invoke:(nonnull id) target action:(nonnull SEL)action returnValue:(nullable void*) returnValue params:(nullable void*) param,...NS_REQUIRES_NIL_TERMINATION;
/**
 获取指定成员属性描述
 */
+(nullable NSDictionary*) getPropertyInfoWithClass:(nonnull Class) clazz propertyName:(nonnull NSString*) propertyName;
/**
 获取所有成员属性描述
 */
+(nonnull NSArray<NSDictionary*>*) getPropertyInfosWithClass:(nonnull Class) clazz;
/**
 获取指定实例方法描述
 */
+(nonnull NSDictionary*) getInstanceMethodWithClass:(nonnull Class) clazz selUid:(nonnull SEL) selUid;
/**
 获取指定静态方法描述
 */
+(nonnull NSDictionary*) getClassMethodWithClass:(nonnull Class) clazz selUid:(nonnull SEL) selUid;
/**
 获取所有的方法信息
 */
+(nonnull NSArray<NSDictionary*>*) getInstanceMethodInfosWithClass:(nonnull Class) clazz;

+(SEL) parseFieldKeyToSetSel:(nonnull NSString *) fieldKey;

@end
