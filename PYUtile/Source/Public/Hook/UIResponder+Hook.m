//
//  UIResponder+Hook.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIResponder+Hook.h"
#import "PYUtile.h"
#import "NSObject+Hook.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+__PYHook_Private.h"


@implementation UIResponder(Hook)

-(void) exchangeDealloc{
    NSHashTable<id<UIResponderHookBaseDelegate>> * delegates = [self.class delegateBase];
    if(delegates) for (id<UIResponderHookBaseDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDeallocWithTarget:)]) {
            [delegate beforeExcuteDeallocWithTarget:self];
        }
    }
    if([self conformsToProtocol:@protocol(UITextInput)] && [self isFirstResponder])[self resignFirstResponder];
    objc_removeAssociatedObjects(self);
    [self exchangeDealloc];
}

+(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    return [self __paramsDictForHookExpand].delegateBase;
}
+(void) setDelegateBase:(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    [self __paramsDictForHookExpand].delegateBase = delegateBase;
}
///<== exchangeMethods
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames{
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        [UIResponder hookMethodWithName:@"dealloc"];
        [UIResponder setDelegateBase:[NSHashTable<id<UIResponderHookBaseDelegate>> weakObjectsHashTable]];
    });
    if (!methodNames)  return false;
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
    return [self hookInstanceMethodName:name];
}


@end
