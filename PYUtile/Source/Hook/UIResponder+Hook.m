//
//  UIResponder+Hook.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIResponder+Hook.h"
#import "PYUtile.h"
#import <objc/runtime.h>
#import <objc/message.h>

void * UIResponderHookBaseDelegatePointer = &UIResponderHookBaseDelegatePointer;

@implementation UIResponder(Hook)

-(void) myDealloc{
    
}

+(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    return objc_getAssociatedObject([UIResponder class], UIResponderHookBaseDelegatePointer);
}
+(void) setDelegateBase:(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    objc_setAssociatedObject([UIResponder class], UIResponderHookBaseDelegatePointer, delegateBase, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) exchangeDealloc{
    BOOL isExcute = true;
    NSHashTable<id<UIResponderHookBaseDelegate>> * delegates = [self.class delegateBase];
    for (id<UIResponderHookBaseDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDealloc:target:)]) {
            [delegate beforeExcuteDealloc:&isExcute target:self];
        }
    }
    objc_removeAssociatedObjects(self);
    if (isExcute) {
        [self exchangeDealloc];
    }
}
///<== exchangeMethods
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SEL sel = sel_getUid("dealloc");
        IMP imp = class_getMethodImplementation([UIResponder class], sel);
        IMP superImp = class_getMethodImplementation(class_getSuperclass([UIResponder class]), sel);
        if(imp == superImp){
            SEL mySel = @selector(myDealloc);
            IMP myImp = class_getMethodImplementation([UIResponder class], mySel);
            Method myMethod = class_getInstanceMethod(self, mySel);
            class_replaceMethod(self, sel, myImp, method_getTypeEncoding(myMethod));
        }
        [UIResponder hookMethodWithName:@"dealloc"];
        [UIResponder setDelegateBase:[NSHashTable<id<UIResponderHookBaseDelegate>> weakObjectsHashTable]];
    });
    if (!methodNames) {
        return false;
    }
    @synchronized([self class]){
        for (NSString *methodName in methodNames) {
            if([self hookMethodWithName:methodName]){
                NSLog(@"%@ hook Success",methodName);
            }else{
                NSLog(@"%@ hook Faild",methodName);
            }
        }
    }
    return true;
}

+(BOOL) hookMethodWithName:(NSString*) name{
    SEL orgSel = sel_getUid(name.UTF8String);
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]].UTF8String);
    IMP exchangeIMP = class_getMethodImplementation(self, exchangeSel);
    IMP orgIMP = class_getMethodImplementation(self, orgSel);
    IMP gmf = (IMP)_objc_msgForward;
    if(exchangeIMP == gmf || orgIMP == gmf){
        return false;
    }
    
    Class superClazz = class_getSuperclass(self);
    IMP superOrgIMP = class_getMethodImplementation(superClazz, orgSel);
    IMP superExchangeIMP = class_getMethodImplementation(superClazz, exchangeSel);
    
    if(superOrgIMP != gmf && superExchangeIMP != gmf && superOrgIMP == orgIMP){
        return [superClazz hookMethodWithName:name];;
    }
    
    Method orgMethod = class_getInstanceMethod(self, orgSel);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeSel);
    class_replaceMethod(self, orgSel, exchangeIMP, method_getTypeEncoding(orgMethod));
    class_replaceMethod(self, exchangeSel, orgIMP, method_getTypeEncoding(exchangeMethod));
    return true;
}


@end
