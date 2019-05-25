//
//  NSObject+__PYHook_Private.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/20.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+__PYHook_Private.h"
#import <objc/runtime.h>

void * UIResponderHookParamDictPointer = &UIResponderHookParamDictPointer;

@implementation NSObject(__PYHook_Private)

+(nonnull __UIResponderHookParamPointerContext *) __paramsDictForHookExpand{
    __UIResponderHookParamPointerContext * ppContext = objc_getAssociatedObject([UIResponder class], UIResponderHookParamDictPointer);
    if(!ppContext) {
        ppContext = [__UIResponderHookParamPointerContext new];
        objc_setAssociatedObject([UIResponder class], UIResponderHookParamDictPointer, ppContext, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ppContext;
}

@end


@implementation __UIResponderHookParamPointerContext @end
