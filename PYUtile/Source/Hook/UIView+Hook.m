//
//  UIView+Hook.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/8/22.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIView+Hook.h"
#import "UIResponder+Hook.h"
#import <objc/runtime.h>
void * UIViewDelegatePointer = &UIViewDelegatePointer;

BOOL isExcuteUIViewHookMethod;

@implementation UIView(Hook)

-(void) exchangeAddSubview:(UIView *) view{
    BOOL isExcute = true;
    NSHashTable<id<UIViewHookDelegate>> * delegates = [UIView delegateViews];
    for (id<UIViewHookDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteAddSubview:isExcute:target:)]) {
            [delegate beforeExcuteAddSubview:view isExcute:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeAddSubview:view];
    }
    
    for (id<UIViewHookDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteAddSubview:target:)]) {
            [delegate afterExcuteAddSubview:view target:self];
        }
    }
}
-(void) exchangeRemoveFromSuperview{
    BOOL isExcute = true;
    NSHashTable<id<UIViewHookDelegate>> * delegates = [UIView delegateViews];
    for (id<UIViewHookDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteRemoveFromSuperview:target:)]) {
            [delegate beforeExcuteRemoveFromSuperview:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeRemoveFromSuperview];
    }
    
    for (id<UIViewHookDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteRemoveFromSuperviewWithTarget:)]) {
            [delegate afterExcuteRemoveFromSuperviewWithTarget:self];
        }
    }
}

+(nullable NSHashTable<id<UIViewHookDelegate>> *) delegateViews{
    return objc_getAssociatedObject([UIView class], UIViewDelegatePointer);
}
+(void) setDelegateViews:(NSHashTable<id<UIViewHookDelegate>> *) delegateViews{
    objc_setAssociatedObject([UIView class], UIViewDelegatePointer, delegateViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void) addDelegateView:(nonnull id<UIViewHookDelegate>) delegateView{
    NSHashTable<id<UIViewHookDelegate>> * delegateViews = [self delegateViews];
    if (!delegateViews) {
        delegateViews = [NSHashTable<id<UIViewHookDelegate>> weakObjectsHashTable];
        [self setDelegateViews:delegateViews];
    }
    bool hasObj = false;
    for (id obj in delegateViews) {
        if (obj == delegateView) {
            hasObj = true;
            break;
        }
    }
    if (!hasObj) {
        [delegateViews addObject:delegateView];
    }}
+(BOOL) hookMethodView{
    NSArray *hookMethodNames;
    if(([self isSubclassOfClass:[UIView class]] || self == [UIView class])){
        @synchronized (self) {
            if (isExcuteUIViewHookMethod) {
                return false;
            }
            isExcuteUIViewHookMethod = true;
        }
        hookMethodNames =
        @[@"addSubview:",
          @"removeFromSuperview"];
        return [UIView hookWithMethodNames:hookMethodNames];
    }
    return false;
}

@end
