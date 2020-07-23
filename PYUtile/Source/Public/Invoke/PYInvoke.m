//
//  PYInvoke.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYInvoke.h"
#import <objc/runtime.h>
#import "py_hook_encode_type.h"

@implementation PYInvoke

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
    [self excuInvoke:returnValue returnType:returnType invocation:invocation isRetainArguments:YES];
}

+ (void) excuInvoke:(nullable void*)returnValue returnType:(char * _Nullable * _Nullable) returnType invocation:(nonnull const id) invocation isRetainArguments:(BOOL) isRetainArguments{
    if (![invocation isKindOfClass:[NSInvocation class]]) {
        return;
    }
    if(invocation == nil) return;
    //retain 所有参数，防止参数被释放dealloc
    if(isRetainArguments) [invocation retainArguments];
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
+(nullable NSDictionary *) getPropertyInfoWithClass:(nonnull Class) clazz propertyName:(nonnull NSString*) propertyName{
    objc_property_t property = class_getProperty(clazz, [propertyName UTF8String]);
    if(property == nil) return nil;
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
    propertyType = [NSString stringWithUTF8String:[PYInvoke pyParseEncodeTpe:propertyType.UTF8String isBaseType:nil]];
    
    return @{keyName:propertyName,keyType:propertyType};
    
}
+(NSDictionary*) getMethodInfoWithMethod:(Method) method{
    
    NSNumber *argumentNum = @(method_getNumberOfArguments(method)-2);
    char returnEncode[100];
    method_getReturnType(method, returnEncode, 100);
    NSString *returnType = [[NSString alloc] initWithUTF8String:[PYInvoke pyParseEncodeTpe:returnEncode isBaseType:nil]];
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
        NSString * methodName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        for (int index = 2; index < argumentNum.integerValue + 2; index ++) {
            char argumentEncode[2];
            method_getArgumentType(method, index, argumentEncode, 2);
            NSString *argumentType = [[NSString alloc] initWithUTF8String:[PYInvoke pyParseEncodeTpe:argumentEncode isBaseType:nil]];
            [argumentEncodes addObject:[NSString stringWithUTF8String:argumentEncode] ? : @"?"];
            [argumentTypes addObject:argumentType];
        }
        return @{keyName : methodName,
                 keyArgumentNum:argumentNum,
                 keyReturnType:returnType,
                 keyArgumentTypes:argumentTypes,
                 keyArgumentEncodes:argumentEncodes,
                 keyReturEncode:[NSString stringWithUTF8String:returnEncode]};
    }
}
+(char*) pyParseEncodeTpe:(const char *) encodeType isBaseType:(bool*) isBaseType{
    char *type = "";
    bool flagBaseType = true;
    int index = 0;
    char *_encodeType;
    while (index < strlen(encodeType)) {
        if(encodeType[index] != '^'){
            break;
        }
        index++;
    }
    if(index > 0){
        _encodeType = py_copy_chars_m(encodeType, index, strlen(encodeType));
    }else{
        _encodeType = py_copy_chars_m(encodeType, -1, -1);
    }
    if(strcasecmp(_encodeType, @encode(void)) == 0){
        type = "Void";
    }else if(strcasecmp(_encodeType, @encode(char)) == 0){
        type = "Int8";
    }else if(strcasecmp(_encodeType, @encode(short)) == 0){
        type = "Int16";
    }else if(strcasecmp(_encodeType, @encode(int)) == 0){
        type = "Int32";
    }else if(strcasecmp(_encodeType, @encode(long)) == 0 || strcasecmp(_encodeType, @encode(long long)) == 0 || strcasecmp(_encodeType, @encode(long long int)) == 0){
        type = "Int64";
    }else if(strcasecmp(_encodeType, @encode(bool)) == 0){
        type = "Bool";
    }else if(strcasecmp(_encodeType, @encode(float)) == 0){
        type = "Float";
    }else if(strcasecmp(_encodeType, @encode(double)) == 0){
        type = "Double";
    }else if(strcasecmp(_encodeType, @encode(SEL)) == 0){
        flagBaseType = false;
        type = "Sel";
    }else if(strcasecmp(_encodeType, @encode(id)) == 0){
        flagBaseType = false;
        type = "Object";
    }else{
        flagBaseType = false;
        
        size_t typeLength = strlen(_encodeType);
        
        if(_encodeType[0] == '@' && _encodeType[1] == '"' && _encodeType[typeLength - 1] == '"'){
            NSString *strEncodeType = [NSString stringWithUTF8String:_encodeType];
            strEncodeType = [strEncodeType stringByReplacingOccurrencesOfString:@"@\"" withString:@""];
            strEncodeType = [strEncodeType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            type = (char *)[strEncodeType UTF8String];
        }
    }
    if (index > 0) {
        char * tempChars = calloc(index, sizeof(char));
        while (index > 0) {
            index--;
            tempChars[index] = '*';
        }
        type = (char *)[[NSString stringWithFormat:@"%s%s",tempChars,type] UTF8String];
        free(tempChars);
    }
    free(_encodeType);
    if(isBaseType)*isBaseType = flagBaseType;
    return type;
}

@end
