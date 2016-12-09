//
//  UIViewController+HookView.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/1/16.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIViewController+HookView.h"
#import "UIViewController+Hook.h"
#import <objc/runtime.h>

void * UIViewControllerHookViewDelegatePointer = &UIViewControllerHookViewDelegatePointer;
BOOL isExcuteUIViewControllerHookViewMethod = false;

@implementation UIViewController(hookview)

//==>exchangeMethods
-(void) exchangeViewDidLoad{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates) {
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidLoad:target:)]) {
            [delegate beforeExcuteViewDidLoad:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewDidLoad];
    }
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates) {
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidLoadWithTarget:)]) {
            [delegate afterExcuteViewDidLoadWithTarget:self];
        }
    }
}
-(void) exchangeViewWillAppear:(BOOL) animated{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillAppear:target:)]) {
            [delegate beforeExcuteViewWillAppear:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewWillAppear:animated];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillAppearWithTarget:)]) {
            [delegate afterExcuteViewWillAppearWithTarget:self];
        }
    }
}
-(void) exchangeViewDidAppear:(BOOL) animated{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidAppear:target:)]) {
            [delegate beforeExcuteViewDidAppear:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewDidAppear:animated];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidAppearWithTarget:)]) {
            [delegate afterExcuteViewDidAppearWithTarget:self];
        }
    }
}
-(void) exchangeViewWillDisappear:(BOOL) animated{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillDisappear:target:)]) {
            [delegate beforeExcuteViewWillDisappear:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewWillDisappear:animated];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillDisappearWithTarget:)]) {
            [delegate afterExcuteViewWillDisappearWithTarget:self];
        }
    }
}
-(void) exchangeViewDidDisappear:(BOOL) animated{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidDisappear:target:)]) {
            [delegate beforeExcuteViewDidDisappear:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewDidDisappear:animated];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidDisappearWithTarget:)]) {
            [delegate afterExcuteViewDidDisappearWithTarget:self];
        }
    }
}
-(void) exchangeViewWillLayoutSubviews{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillLayoutSubviews:target:)]) {
            [delegate beforeExcuteViewWillLayoutSubviews:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewDidLayoutSubviews];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillLayoutSubviewsWithTarget:)]) {
            [delegate afterExcuteViewWillLayoutSubviewsWithTarget:self];
        }
    }
}
-(void) exchangeViewDidLayoutSubviews{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidLayoutSubviews:target:)]) {
            [delegate beforeExcuteViewDidLayoutSubviews:&isExcute target:self];
        }
    }

    if (isExcute) {
        [self exchangeViewDidLayoutSubviews];
    }

    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidLayoutSubviewsWithTarget:)]) {
            [delegate afterExcuteViewDidLayoutSubviewsWithTarget:self];
        }
    }
}


- (UIStatusBarStyle)exchangeNvPreferredStatusBarStyle{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredStatusBarStyle:target:)]) {
            [delegate beforeExcutePreferredStatusBarStyle:&isExcute target:self];
        }
    }
    
    UIStatusBarStyle result = UIStatusBarStyleLightContent;
    if (isExcute) {
        result = [self exchangeNvPreferredStatusBarStyle];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredStatusBarStyleWithTarget:)]) {
            result = [delegate afterExcutePreferredStatusBarStyleWithTarget:self];
        }
    }
    
    return result;
}

- (UIStatusBarStyle)exchangePreferredStatusBarStyle{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredStatusBarStyle:target:)]) {
            [delegate beforeExcutePreferredStatusBarStyle:&isExcute target:self];
        }
    }
    
    UIStatusBarStyle result = UIStatusBarStyleLightContent;
    if (isExcute) {
         result = [self exchangePreferredStatusBarStyle];
    }
    
    for (id<UIViewcontrollerHookViewDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredStatusBarStyleWithTarget:)]) {
            result = [delegate afterExcutePreferredStatusBarStyleWithTarget:self];
        }
    }
    
    return result;
}


+(nullable NSHashTable<id<UIViewcontrollerHookViewDelegate>> *) delegateViews{
    return objc_getAssociatedObject([UIViewController class], UIViewControllerHookViewDelegatePointer);
}
+(void) setDelegateViews:(NSHashTable<id<UIViewcontrollerHookViewDelegate>> *) delegateViews{
    objc_setAssociatedObject([UIViewController class], UIViewControllerHookViewDelegatePointer, delegateViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void) addDelegateView:(nonnull id<UIViewcontrollerHookViewDelegate>) delegateView{
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegateViews = [self delegateViews];
    if (!delegateViews) {
        delegateViews = [NSHashTable<id<UIViewcontrollerHookViewDelegate>> weakObjectsHashTable];
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
    }
}
+(BOOL) hookMethodView{
    NSArray *hookMethodNames;
    if(([self isSubclassOfClass:[UIViewController class]] || self == [UIViewController class])){
        @synchronized (self) {
            if (isExcuteUIViewControllerHookViewMethod) {
                return false;
            }
            isExcuteUIViewControllerHookViewMethod = true;
        }
        hookMethodNames =
        @[@"viewDidLoad",
          @"viewDidAppear:",
          @"viewWillAppear:",
          @"viewWillDisappear:",
          @"viewDidDisappear:",
          @"viewWillLayoutSubviews",
          @"viewDidLayoutSubviews",
          @"preferredStatusBarStyle"];
        return [UIViewController hookWithMethodNames:hookMethodNames];
    }
    return false;
}
//
//#pragma UIViewcontrollerHookViewDelegate ===>
//-(void) beforeExcuteViewDidLoad:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewDidLoadWithTarget:(nonnull UIViewController *) target{
//}
//
//-(void) beforeExcuteViewWillAppear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target{
//}
//
//-(void) beforeExcuteViewDidAppear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target{
//}
//
//-(void) beforeExcuteViewWillDisappear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewWillDisappearWithTarget:(nonnull UIViewController *) target{
//}
//
//-(void) beforeExcuteViewDidDisappear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewDidDisappearWithTarget:(nonnull UIViewController *) target{
//}
//
//-(void) beforeExcuteViewDidLayoutSubviews:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
//    *isExcute = true;
//}
//-(void) afterExcuteViewDidLayoutSubviewsWithTarget:(nonnull UIViewController *) target{
//}
//#pragma UIViewcontrollerHookViewDelegate <===

@end
