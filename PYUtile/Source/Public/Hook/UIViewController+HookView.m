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

static id HookViewSynTag = @"";
static id HookViewTempSynTag = @"";
static BOOL HookViewIsIteritor = NO;

void * UIViewControllerHookViewDelegatePointer = &UIViewControllerHookViewDelegatePointer;
BOOL isExcuteUIViewControllerHookViewMethod = false;

@implementation UIViewController(hookview)

//==>exchangeMethods
-(void) exchangeViewDidLoad{
     __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidLoad:target:)]) {
            [delegate beforeExcuteViewDidLoad:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewDidLoad];
    }
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidLoadWithTarget:)]) {
            [delegate afterExcuteViewDidLoadWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewWillAppear:(BOOL) animated{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillAppear:target:)]) {
            [delegate beforeExcuteViewWillAppear:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewWillAppear:animated];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillAppearWithTarget:)]) {
            [delegate afterExcuteViewWillAppearWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewDidAppear:(BOOL) animated{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidAppear:target:)]) {
            [delegate beforeExcuteViewDidAppear:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewDidAppear:animated];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidAppearWithTarget:)]) {
            [delegate afterExcuteViewDidAppearWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewWillDisappear:(BOOL) animated{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillDisappear:target:)]) {
            [delegate beforeExcuteViewWillDisappear:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewWillDisappear:animated];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillDisappearWithTarget:)]) {
            [delegate afterExcuteViewWillDisappearWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewDidDisappear:(BOOL) animated{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidDisappear:target:)]) {
            [delegate beforeExcuteViewDidDisappear:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewDidDisappear:animated];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidDisappearWithTarget:)]) {
            [delegate afterExcuteViewDidDisappearWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewWillLayoutSubviews{
    __block __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillLayoutSubviews:target:)]) {
            [delegate beforeExcuteViewWillLayoutSubviews:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewDidLayoutSubviews];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillLayoutSubviewsWithTarget:)]) {
            [delegate afterExcuteViewWillLayoutSubviewsWithTarget:self];
        }
    } target:self];
}
-(void) exchangeViewDidLayoutSubviews{
    __block __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewDidLayoutSubviews:target:)]) {
            [delegate beforeExcuteViewDidLayoutSubviews:&isExcute target:self];
        }
    } target:self];

    if (isExcute) {
        [self exchangeViewDidLayoutSubviews];
    }

    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewDidLayoutSubviewsWithTarget:)]) {
            [delegate afterExcuteViewDidLayoutSubviewsWithTarget:self];
        }
    } target:self];
}


- (UIStatusBarStyle)exchangeNvPreferredStatusBarStyle{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredStatusBarStyle:target:)]) {
            [delegate beforeExcutePreferredStatusBarStyle:&isExcute target:self];
        }
    } target:self];
    
    __block UIStatusBarStyle result = UIStatusBarStyleLightContent;
    if (isExcute) {
        result = [self exchangeNvPreferredStatusBarStyle];
    }
    
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredStatusBarStyleWithTarget:)]) {
            result = [delegate afterExcutePreferredStatusBarStyleWithTarget:self];
        }
    } target:self];
    
    return result;
}

- (UIStatusBarStyle)exchangePreferredStatusBarStyle{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookViewDelegate>> * delegates = [UIViewController delegateViews];
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredStatusBarStyle:target:)]) {
            [delegate beforeExcutePreferredStatusBarStyle:&isExcute target:self];
        }
    } target:self];
    
    __block UIStatusBarStyle result = UIStatusBarStyleLightContent;
    if (isExcute) {
         result = [self exchangePreferredStatusBarStyle];
    }
    [UIViewController hookViewIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredStatusBarStyleWithTarget:)]) {
            result = [delegate afterExcutePreferredStatusBarStyleWithTarget:self];
        }
    } target:self];
    
    return result;
}


+(nullable NSHashTable<id<UIViewcontrollerHookViewDelegate>> *) delegateViews{
    return objc_getAssociatedObject([UIViewController class], UIViewControllerHookViewDelegatePointer);
}
+(void) setDelegateViews:(NSHashTable<id<UIViewcontrollerHookViewDelegate>> *) delegateViews{
    objc_setAssociatedObject([UIViewController class], UIViewControllerHookViewDelegatePointer, delegateViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void) hookViewIteratorTable:(nonnull NSHashTable *) table block:(void(^)(id sub)) block target:(nonnull UIViewController *) target{
    if(![UIViewController canExcuHookMethod:target]) return;
    @synchronized (HookViewSynTag) {
        HookViewIsIteritor = YES;
        for (id sub in table) {
            block(sub);
        }
        HookViewIsIteritor = NO;
        @synchronized (HookViewTempSynTag) {
            NSMutableArray * temps = [self paramsDictForHookExpand][@"delegateOrientationsTemp"];
            if(temps && temps.count > 0){
                for (id temp in temps) {
                    [self addDelegateView:temp];
                }
            }
            [temps removeAllObjects];
        }
    }
}
+(void) addDelegateView:(nonnull id<UIViewcontrollerHookViewDelegate>) delegateView{
    if(HookViewIsIteritor && delegateView){
        @synchronized (HookViewTempSynTag) {
            NSMutableArray * temps = [self paramsDictForHookExpand][@"delegateViewsTemp"];
            if(temps == nil){
                temps = [NSMutableArray new];
                [self paramsDictForHookExpand][@"delegateViewsTemp"] = temps;
            }
            [temps addObject:delegateView];
        }
        return;
    }
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
