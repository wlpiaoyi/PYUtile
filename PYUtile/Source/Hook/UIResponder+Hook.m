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

void * UIResponderHookBaseDelegatePointer = &UIResponderHookBaseDelegatePointer;

@implementation UIResponder(Hook)

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
        if(IOS8_OR_LATER){
            [UIResponder hookMethodWithName:@"dealloc"];
            [UIResponder setDelegateBase:[NSHashTable<id<UIResponderHookBaseDelegate>> weakObjectsHashTable]];
        }else{
            NSLog(@"not hook dealloc method \"objc_removeAssociatedObjects\" should not be excuted!");
        }
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
    if(![self instancesRespondToSelector:orgSel]){
        return false;
    }
    if(![self instancesRespondToSelector:exchangeSel]){
        return false;
    }
    Method orgMethod = class_getInstanceMethod(self, orgSel);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeSel);
    method_exchangeImplementations(exchangeMethod, orgMethod);
    
    return true;
}


@end
