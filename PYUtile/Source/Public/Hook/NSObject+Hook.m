//
//  NSObject+Hook.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/15.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+Hook.h"
#import "PYUtile.h"

@implementation NSObject(Hook)

#pragma hook method originalAction:当前action exchangeAction:交换action ========>
+(BOOL) hookStaticOriginalAction:(nonnull SEL) originalAction exchangeAction:(nonnull SEL) exchangeAction{
    Method oM = class_getClassMethod(self, originalAction);
    Method eM = class_getClassMethod(self, exchangeAction);
    IMP exchangeIMP = method_getImplementation(eM);
    IMP originalIMP = method_getImplementation(oM);
    IMP gmf = (IMP)_objc_msgForward;
    if(!originalIMP){
        kPrintErrorln("hook class(%s) has no static original IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalAction));
        return false;
    }
    if(originalIMP == gmf){
        kPrintErrorln("hook class(%s) has static original forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalAction));
        return false;
    }
    if(!exchangeIMP){
        kPrintErrorln("hook class(%s) has no static exchange IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeAction));
        return false;
    }
    if(exchangeIMP == gmf){
        kPrintErrorln("hook class(%s) has static exchange forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeAction));
        return false;
    }
    method_exchangeImplementations(eM, oM);
    return true;
}

+(BOOL) hookInstanceOriginalAction:(nonnull SEL) originalAction exchangeAction:(nonnull SEL) exchangeAction{
    IMP exchangeIMP = class_getMethodImplementation(self, exchangeAction);
    IMP originalIMP = class_getMethodImplementation(self, originalAction);
    IMP gmf = (IMP)_objc_msgForward;
    if(!originalIMP){
        kPrintErrorln("hook class(%s) has no instance original IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalAction));
        return false;
    }
    if(originalIMP == gmf){
        kPrintErrorln("hook class(%s) has instance original forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(originalAction));
        return false;
    }
    if(!exchangeIMP){
        kPrintErrorln("hook class(%s) has no instance exchange IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeAction));
        return false;
    }
    if(exchangeIMP == gmf){
        kPrintErrorln("hook class(%s) has instance exchange forward IMP for %s", [NSStringFromClass(self) UTF8String], sel_getName(exchangeAction));
        return false;
    }
    Method originalMethod = class_getInstanceMethod(self, originalAction);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeAction);
    method_exchangeImplementations(exchangeMethod, originalMethod);
    return true;
}
#pragma hook method originalAction:当前action exchangeAction:交换action <========

#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数====>
+(BOOL) hookInstanceMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookInstanceOriginalAction:originalSel exchangeAction:exchangeSel];
}

+(BOOL) hookStaticMethodName:(nonnull NSString *) methodName{
    SEL originalSel = sel_getUid(methodName.UTF8String);
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[methodName substringToIndex:1] uppercaseString], [methodName substringFromIndex:1]].UTF8String);
    return [self hookStaticOriginalAction:originalSel exchangeAction:exchangeSel];
}
#pragma hook method methodName:当前方法名称 需要添加一个exchange{methodName}首字母大写的函数<====
+(BOOL) addInstanceMethod:(nonnull Method) method{
    SEL sel = method_getName(method);
    IMP imp = method_getImplementation(method);
    const char * types = method_getTypeEncoding(method);
    if(class_addMethod(self, sel, imp, types)){
        return YES;
    }else{
        kPrintErrorln("(%s) add method (%s) failed", NSStringFromClass(self).UTF8String, sel_getName(sel));
        return NO;
    }
}
@end
