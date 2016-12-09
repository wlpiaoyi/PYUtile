//
//  NSObject+Hook.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Hook.h"
#import <objc/runtime.h>

void * NSObjectHookBaseDelegatePointer = &NSObjectHookBaseDelegatePointer;

@implementation NSObject(Hook)

+(nullable NSHashTable<id<NSObjectHookBaseDelegate>> *) delegateBase{
    return objc_getAssociatedObject([NSObject class], NSObjectHookBaseDelegatePointer);
}
+(void) setDelegateBase:(nullable NSHashTable<id<NSObjectHookBaseDelegate>> *) delegateBase{
    objc_setAssociatedObject([NSObject class], NSObjectHookBaseDelegatePointer, delegateBase, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void) exchangeDealloc{
    BOOL isExcute = true;
    if(self && [self isMemberOfClass:[NSObject class]]){
        NSHashTable<id<NSObjectHookBaseDelegate>> * delegates = [self.class delegateBase];
        
        for (id<NSObjectHookBaseDelegate> delegate in delegates){
            if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDealloc:target:)]) {
                [delegate beforeExcuteDealloc:&isExcute target:self];
            }
        }
        objc_removeAssociatedObjects(self);
    }
    if (isExcute) {
         [self exchangeDealloc];
    }
}
///<== exchangeMethods
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        [NSObject hookMethodWithName:@"dealloc"];
        [NSObject setDelegateBase:[NSHashTable<id<NSObjectHookBaseDelegate>> weakObjectsHashTable]];
    });
    if (!methodNames) {
        return false;
    }
    @synchronized([NSObject class]){
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
