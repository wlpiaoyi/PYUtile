//
//  PYReflect.m
//  RunTime
//
//  Created by wlpiaoyi on 15/7/6.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "PYReflect.h"
#import <objc/runtime.h>

@implementation PYReflect{
}

//==>分布执行方法
+ (nullable id) startInvoke:(nonnull id) target action:(nonnull SEL)action{
    //初始化NSMethodSignature对象
    NSMethodSignature *methodSig = [[target class] instanceMethodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    if (invocation == nil) {
        return nil;
    }
    //设置被调用的消息
    [invocation setSelector:action];
    //设置调用者也就是AsynInvoked的实例对象
    [invocation setTarget:target];
    return invocation;
}
+ (void) setInvoke:(nullable void*) param index:(NSInteger) index invocation:(nonnull const id) invocation{
    if (![invocation isKindOfClass:[NSInvocation class]]) {
        return;
    }
    if (index < 2) return;
    if (!param) return;
    [invocation setArgument:param atIndex:index];
}

+ (void) excuInvoke:(nullable void*)returnValue returnType:(char * _Nullable * _Nullable) returnType invocation:(nonnull const id) invocation{
    if (![invocation isKindOfClass:[NSInvocation class]]) {
        return;
    }
    if(invocation == nil) return;
    //retain 所有参数，防止参数被释放dealloc
    [invocation retainArguments];
    //消息调用
    [invocation invoke];
    char *_returnType = (char*)((NSInvocation*)invocation).methodSignature.methodReturnType;
    //获得返回值类型
    if(!_returnType){
        return;
    }else{
        if(returnType){
            *returnType = _returnType;
        }
    }
    
    if(!returnValue){
        return;
    }
    
    if(strcmp(_returnType, @encode(void)) == 0){//如果没有返回值，也就是消息声明为void
        return;
    }
    [invocation getReturnValue:returnValue];
}
///<==
//单步执行反射方法
+ (void) invoke:(nonnull id) target action:(nonnull SEL)action returnValue:(nullable void*) returnValue params:(nullable void*) param,...NS_REQUIRES_NIL_TERMINATION{
    if (![target respondsToSelector:action]) {
        return;
    }
    NSInvocation *invaction = [self startInvoke:target action:action];
    //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
    if(param){
        int index = 2;
        [self setInvoke:param index:index invocation:invaction];
        va_list _list;
        va_start(_list, param);
        void* resource = nil;
        while ((resource = va_arg( _list, void*))) {
            index ++;
            [self setInvoke:resource index:index invocation:invaction];
        }
        va_end(_list);
    }
    [self excuInvoke:returnValue returnType:nil invocation:invaction];
}

/**
 获取指定成员属性描述
 */
+(nonnull NSDictionary*) getPropertyInfoWithClass:(nonnull Class) clazz propertyName:(nonnull NSString*) propertyName{
    objc_property_t property = class_getProperty(clazz, [propertyName UTF8String]);
    return [self getPropertyInfoWithProperty:property];
}

/**
 获取所有成员属性描述
 */
+(nonnull NSArray<NSDictionary*>*) getPropertyInfosWithClass:(nonnull Class) clazz{
    unsigned int outCount;
    objc_property_t * propertyList = class_copyPropertyList(clazz, &outCount);
    NSMutableArray<NSDictionary*> *propertyInfos = [NSMutableArray<NSDictionary*> new];
    for (unsigned int index = 0; index < outCount; index++) {
        objc_property_t property = propertyList[index];
        [propertyInfos addObject:[self getPropertyInfoWithProperty:property]];
    }
    return propertyInfos;
}

/**
 获取指定实例方法描述
 */
+(nonnull NSDictionary*) getInstanceMethodWithClass:(nonnull Class) clazz selUid:(nonnull SEL) selUid{
    Method method = class_getInstanceMethod(clazz, selUid);
    return [self getMethodInfoWithMethod:method];
}/**
  获取指定静态方法描述
  */
+(nonnull NSDictionary*) getClassMethodWithClass:(nonnull Class) clazz selUid:(nonnull SEL) selUid{
    Method method = class_getClassMethod(clazz, selUid);
    return [self getMethodInfoWithMethod:method];
}
/**
 获取所有的方法信息
 */
+(nonnull NSArray<NSDictionary*>*) getInstanceMethodInfosWithClass:(nonnull Class) clazz{
    unsigned int outCount;
    Method* methods = class_copyMethodList(clazz, &outCount);
    NSMutableArray<NSDictionary*> *methodDics = [[NSMutableArray<NSDictionary*> alloc] init];
    for (int i = 0; i<outCount; i++) {
        Method method = methods[i];
        [methodDics addObject:[self getMethodInfoWithMethod:method]];
    }
    free(methods);
    return methodDics;

}

+(NSDictionary*) getPropertyInfoWithProperty:(objc_property_t) property{
    
    static NSString *keyName;
    static NSString *keyType;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyName = @"name";
        keyType = @"type";
    });
    
    NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
    NSString *propertyType = [NSString stringWithUTF8String:property_getAttributes(property)];
    propertyType = [[propertyType componentsSeparatedByString:@","].firstObject substringFromIndex:1];
    propertyType = [NSString stringWithUTF8String:py_parse_encode_type(propertyType.UTF8String, nil)];
    
    return @{keyName:propertyName,keyType:propertyType};
    
}
+(NSDictionary*) getMethodInfoWithMethod:(Method) method{
    
    NSNumber *argumentNum = @(method_getNumberOfArguments(method)-2);
    char returnEncode[2];
    method_getReturnType(method, returnEncode, 2);
    NSString *returnType = [[NSString alloc] initWithUTF8String:py_parse_encode_type(returnEncode, nil)];
    static NSString *keyName;
    static NSString *keyArgumentNum;
    static NSString *keyArgumentTypes;
    static NSString *keyArgumentEncodes;
    static NSString *keyReturnType;
    static NSString *keyReturEncode;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyName = @"name";
        keyArgumentNum = @"argumentNum";
        keyArgumentTypes = @"argumentTypes";
        keyArgumentEncodes = @"argumentEncodes";
        keyReturnType = @"returnType";
        keyReturEncode = @"returEncode";
    });
    if (argumentNum.integerValue == 0) {
        return @{keyName :[NSString stringWithUTF8String:sel_getName(method_getName(method))],
                 keyArgumentNum:argumentNum,
                 keyReturnType:returnType,
                 keyReturEncode:[NSString stringWithUTF8String:returnEncode]};
    }else{
        NSMutableArray * argumentTypes = [NSMutableArray new];
        NSMutableArray * argumentEncodes = [NSMutableArray new];
        for (int index = 2; index < argumentNum.integerValue + 2; index ++) {
            char argumentEncode[2];
            method_getArgumentType(method, index, argumentEncode, 2);
            NSString *argumentType = [[NSString alloc] initWithUTF8String:py_parse_encode_type(argumentEncode, nil)];
            [argumentEncodes addObject:[NSString stringWithUTF8String:argumentEncode]];
            [argumentTypes addObject:argumentType];
        }
        NSString * methodName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        return @{keyName : methodName,
                 keyArgumentNum:argumentNum,
                 keyReturnType:returnType,
                 keyArgumentTypes:argumentTypes,
                 keyArgumentEncodes:argumentEncodes,
                 keyReturEncode:[NSString stringWithUTF8String:returnEncode]};
    }
}

@end
