//
//  NSObject+Hook.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/15.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+Hook.h"
#import "PYUtile.h"
#import "PYInvoke.h"
#import <objc/runtime.h>

void * UIResponderHookParamDictPointer = &UIResponderHookParamDictPointer;
static NSMutableDictionary<NSString *, id> * RETAIN_OBJS;


@implementation NSObject(Hook)

#pragma hook method originalSel:当前action exchangeSel:交换action ========>
+(BOOL) hookStaticOriginalSel:(nonnull SEL) originalSel exchangeSel:(nonnull SEL) exchangeSel{
    Method oM = class_getClassMethod(self, originalSel);
    Method eM = class_getClassMethod(self, exchangeSel);
    IMP exchangeIMP = method_getImplementation(eM);
    IMP originalIMP = method_getImplementation(oM);
    IMP gmf = (IMP)_objc_msgForward;
    if(!originalIMP){
        kPrintErrorln("hook class(%s) has no static original IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalSel));
        return false;
    }
    if(originalIMP == gmf){
        kPrintErrorln("hook class(%s) has static original forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalSel));
        return false;
    }
    if(!exchangeIMP){
        kPrintErrorln("hook class(%s) has no static exchange IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeSel));
        return false;
    }
    if(exchangeIMP == gmf){
        kPrintErrorln("hook class(%s) has static exchange forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeSel));
        return false;
    }
    method_exchangeImplementations(eM, oM);
    return true;
}

+(BOOL) hookInstanceOriginalSel:(nonnull SEL) originalSel exchangeSel:(nonnull SEL) exchangeSel{	
    IMP exchangeIMP = class_getMethodImplementation(self, exchangeSel);
    IMP originalIMP = class_getMethodImplementation(self, originalSel);
    IMP gmf = (IMP)_objc_msgForward;
    if(!originalIMP){
        kPrintErrorln("hook class(%s) has no instance original IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalSel));
        return false;
    }
    if(originalIMP == gmf){
        kPrintErrorln("hook class(%s) has instance original forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalSel));
        return false;
    }
    if(!exchangeIMP){
        kPrintErrorln("hook class(%s) has no instance exchange IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeSel));
        return false;
    }
    if(exchangeIMP == gmf){
        kPrintErrorln("hook class(%s) has instance exchange forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeSel));
        return false;
    }
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeSel);
    method_exchangeImplementations(exchangeMethod, originalMethod);
    return true;
}
#pragma hook method originalSel:当前action exchangeSel:交换action <========

#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数====>
+(BOOL) hookInstanceMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel = sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookInstanceOriginalSel:originalSel exchangeSel:exchangeSel];
}

+(BOOL) hookStaticMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel = sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookStaticOriginalSel:originalSel exchangeSel:exchangeSel];
}

+(BOOL) hookInstancePrivateMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel = sel_getUid([NSString stringWithFormat:@"exchange%@%@%@", NSStringFromClass(self), [[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookInstanceOriginalSel:originalSel exchangeSel:exchangeSel];
}

+(BOOL) hookStaticPrivateMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel = sel_getUid([NSString stringWithFormat:@"exchange%@%@", NSStringFromClass(self), [[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookStaticOriginalSel:originalSel exchangeSel:exchangeSel];
}
#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数<====

+(BOOL) addInstanceMethod:(nonnull Method) method{
    SEL sel = method_getName(method);
    if([self respondsToSelector:sel]){
        kPrintErrorln("(%s) contains method (%s)", NSStringFromClass(self).UTF8String, sel_getName(sel));
        return NO;
    }
    IMP imp = method_getImplementation(method);
    const char * types = method_getTypeEncoding(method);
    if(class_addMethod(self, sel, imp, types)){
        return YES;
    }else{
        kPrintErrorln("(%s) add method (%s) failed", NSStringFromClass(self).UTF8String, sel_getName(sel));
        return NO;
    }
}

#pragma hook实例方法，使用block替换原方法，使用invoke执行原方法====>
+(BOOL) hookInstanceMethodWithSel:(nonnull SEL) originalSel block:(nonnull id) exchangeBlock{
    NSString * key = kFORMAT(@"%@,%@", NSStringFromClass([self class]), NSStringFromSelector(originalSel));
    if(RETAIN_OBJS == nil){
        @synchronized ([UISlider class]) {
            if(RETAIN_OBJS == nil){
                RETAIN_OBJS = [NSMutableDictionary dictionary];
            }
        }
    }
    [RETAIN_OBJS removeObjectForKey:key];
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    IMP exchangeImp = imp_implementationWithBlock(exchangeBlock);
    const char * types = method_getTypeEncoding(originalMethod);
    NSString * methodName = NSStringFromSelector(originalSel);
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    if([self respondsToSelector:exchangeSel]){
        kPrintErrorln("(%s) contains method (%s)", NSStringFromClass(self).UTF8String, sel_getName(exchangeSel));
        return NO;
    }
    if(!class_addMethod(self, exchangeSel, exchangeImp, types)){
        kPrintErrorln("(%s) add method (%s) failed", NSStringFromClass(self).UTF8String, sel_getName(exchangeSel));
        return NO;
    }
    if([self hookInstanceOriginalSel:originalSel exchangeSel:exchangeSel]){
        [RETAIN_OBJS setValue:exchangeBlock forKey:key];
        return true;
    }else return false;
}


- (void) invokeOrginalWithSel:(nonnull SEL) originalSel returnValue:(nullable void*) returnValue params:(nullable void*) param,...NS_REQUIRES_NIL_TERMINATION{
    id target = self;
    NSString * methodOriginalName = NSStringFromSelector(originalSel);
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodOriginalName substringToIndex:1] uppercaseString], [methodOriginalName substringFromIndex:1]].UTF8String);
    
    if (![target respondsToSelector:exchangeSel]) {
        return;
    }
    NSInvocation *invaction = [PYInvoke startInvoke:target action:exchangeSel];
    //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
    if(param){
        int index = 2;
        [PYInvoke setInvoke:param index:index invocation:invaction];
        va_list _list;
        va_start(_list, param);
        void* resource = nil;
        while ((resource = va_arg( _list, void*))) {
            index ++;
            [PYInvoke setInvoke:resource index:index invocation:invaction];
        }
        va_end(_list);
    }
    [PYInvoke excuInvoke:returnValue returnType:nil invocation:invaction];
}

#pragma hook实例方法，使用block替换原方法，使用invoke执行原方法<====


#pragma hookDealloc方法，对象回收时会自动清理数据和执行回调监听====>

+(void) removehookDeallocByClazz:(Class) clazz{
    NSMutableDictionary * paramDict = [clazz __paramsDictForHookStatic:false];
    if(paramDict == nil){
        return;
    }
    NSString * deallocBlockTagKey = @"__HOOK_DEALLOC_BLOCK_TAG";
    [paramDict removeObjectForKey:deallocBlockTagKey];
}

+(BOOL) hookDeallocOnlyOnce:(void(^)(void * targetPointer)) deallocBlock clazz:(Class) clazz{
    kDISPATCH_ONCE_BLOCK(^{
        SEL hookAction = sel_getUid("dealloc");
        NSAssert([NSObject hookInstanceMethodName:NSStringFromSelector(hookAction)], @"Hook dealloc failed");
    });
    
    NSString * deallocBlockTagKey = @"__HOOK_DEALLOC_BLOCK_TAG";
    if(deallocBlock != nil){
        [[clazz __paramsDictForHookStatic:true] setValue:deallocBlock forKey:deallocBlockTagKey];
    }
    NSString * dellocTagKey = @"__HOOK_DEALLOC_TAG";
    NSNumber * __HOOK_DEALLOC_TAG = [[clazz __paramsDictForHookStatic:true] valueForKey:dellocTagKey];
    if(__HOOK_DEALLOC_TAG != nil && __HOOK_DEALLOC_TAG.boolValue){
        return true;
    }
    @synchronized (clazz) {
        __HOOK_DEALLOC_TAG = [[clazz __paramsDictForHookStatic:true] valueForKey:dellocTagKey];
        if(__HOOK_DEALLOC_TAG != nil && __HOOK_DEALLOC_TAG.boolValue){
            return true;
        }
        __HOOK_DEALLOC_TAG = [NSNumber numberWithBool:true];
        [[clazz __paramsDictForHookStatic:true] setValue:__HOOK_DEALLOC_TAG forKey:dellocTagKey];
    }
    return true;
}

-(void) exchangeDealloc{
    NSMutableDictionary * paramDict = [self.class __paramsDictForHookStatic:false];
    if(paramDict == nil){
        [self exchangeDealloc];
        return;
    }
    void(^deallocBlock)(void * targetPointer) = [paramDict valueForKey:@"__HOOK_DEALLOC_BLOCK_TAG"];
    if(deallocBlock != nil){
        void * target = (__bridge void *)(self);
        deallocBlock(target);
    }
    objc_removeAssociatedObjects(self);
    [self exchangeDealloc];
}

#pragma hookDealloc方法，对象回收时会自动清理数据和执行回调监听<====

+(nullable NSMutableDictionary *) __paramsDictForHookStatic:(BOOL) isFill{
    NSMutableDictionary * dict = objc_getAssociatedObject(self, UIResponderHookParamDictPointer);
    if(dict != nil){
        return dict;
    }
    if(!isFill){
        return nil;
    }
    @synchronized (self) {
        dict = objc_getAssociatedObject(self, UIResponderHookParamDictPointer);
        if(dict != nil){
            return dict;
        }
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, UIResponderHookParamDictPointer, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}

- (nullable NSMutableDictionary *) __paramsDictForHookInstance:(BOOL) isFill{
    NSMutableDictionary * dict = objc_getAssociatedObject(self, UIResponderHookParamDictPointer);
    if(dict != nil){
        return dict;
    }
    if(!isFill){
        return nil;
    }
    @synchronized (self) {
        dict = objc_getAssociatedObject(self, UIResponderHookParamDictPointer);
        if(dict != nil){
            return dict;
        }
        dict = [NSMutableDictionary new];
        objc_setAssociatedObject(self, UIResponderHookParamDictPointer, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return dict;
}
@end
