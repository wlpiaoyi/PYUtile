//
//  UIViewController+Orientation.m
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/1/16.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIViewController+HookOrientation.h"
#import "UIViewController+Hook.h"
#import "PYUtile.h"
#import <objc/runtime.h>

void * UIViewControllerHookOrientationDelegatePointer = &UIViewControllerHookOrientationDelegatePointer;
BOOL isExcuteUIViewControllerHookOrientationMethod = false;

@implementation UIViewController(HookOrientation)

//重写父类方法判断是否可以旋转
-(BOOL) exchangeShouldAutorotate{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteShouldAutorotate:target:)]) {
            [delegate beforeExcuteShouldAutorotate:&isExcute target:self];
        }
    }
    
    BOOL result = false;
    if (isExcute) {
        result = [self exchangeShouldAutorotate];
    }
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(aftlerExcuteShouldAutorotateWithTarget:)]) {
            result = [delegate aftlerExcuteShouldAutorotateWithTarget:self];
        }
    }
    return result;
}

//重写父类方法判断支持的旋转方向
-(NSUInteger) exchangeSupportedInterfaceOrientations{
    BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteSupportedInterfaceOrientations:target:)]) {
            [delegate beforeExcuteSupportedInterfaceOrientations:&isExcute target:self];
        }
    }
    
    NSUInteger result = 0;
    if (isExcute) {
        result = [self exchangeSupportedInterfaceOrientations];
    }
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteSupportedInterfaceOrientationsWithTarget:)]) {
            result = [delegate afterExcuteSupportedInterfaceOrientationsWithTarget:self];
        }
    }
    
    return result;
}
//重写父类方法返回当前方向
- (UIInterfaceOrientation) exchangePreferredInterfaceOrientationForPresentation{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredInterfaceOrientationForPresentation:target:)]) {
            [delegate beforeExcutePreferredInterfaceOrientationForPresentation:&isExcute target:self];
        }
    }
    
    UIInterfaceOrientation result = UIInterfaceOrientationUnknown;
    if (isExcute) {
        result = [self exchangePreferredInterfaceOrientationForPresentation];
    }
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredInterfaceOrientationForPresentationWithTarget:)]) {
            result = [delegate afterExcutePreferredInterfaceOrientationForPresentationWithTarget:self];
            
        }
    }
    
    return result;
}
-(void) exchangeViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillTransitionToSize:withTransitionCoordinator:isExcute:target:)]) {
            [delegate beforeExcuteViewWillTransitionToSize:size withTransitionCoordinator:coordinator isExcute:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeViewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillTransitionToSize:withTransitionCoordinator:target:)]) {
            [delegate afterExcuteViewWillTransitionToSize:size withTransitionCoordinator:coordinator target:self];
        }
    }
}
//⇒ 重写父类方法旋转开始和结束
-(void) exchangeWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteWillRotateToInterfaceOrientation:duration:isExcute:target:)]) {
            [delegate beforeExcuteWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration isExcute:&isExcute target:self];
        }
    }
    
    if (isExcute) {
        [self exchangeWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteWillRotateToInterfaceOrientation:duration:target:)]) {
            [delegate afterExcuteWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration target:self];
        }
    }
}
-(void) exchangeDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation{
    BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDidRotateFromInterfaceOrientation:isExcute:target:)]) {
            [delegate beforeExcuteDidRotateFromInterfaceOrientation:fromInterfaceOrientation isExcute:&isExcute target:self];
        }
    }
    if (isExcute) {
        [self exchangeDidRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
    for (id<UIViewcontrollerHookOrientationDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteDidRotateFromInterfaceOrientation:target:)]) {
            [delegate afterExcuteDidRotateFromInterfaceOrientation:fromInterfaceOrientation target:self];
        }
    }
}
//⇐

+(nullable NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> *) delegateOrientations{
    return objc_getAssociatedObject([UIViewController class], UIViewControllerHookOrientationDelegatePointer);
}
+(void) setDelegateOrientations:(nullable NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> *) delegateOrientations{
    objc_setAssociatedObject([UIViewController class], UIViewControllerHookOrientationDelegatePointer, delegateOrientations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+(void) addDelegateOrientation:(nullable id<UIViewcontrollerHookOrientationDelegate>) delegateOrientation{
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegateOrientations = (NSHashTable<id<UIViewcontrollerHookOrientationDelegate>>*)[self delegateOrientations];
    if (!delegateOrientations) {
        delegateOrientations = [NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> weakObjectsHashTable];
        [self setDelegateOrientations:delegateOrientations];
    }
    bool hasObj = false;
    for (id obj in delegateOrientations) {
        if (obj == delegateOrientation) {
            hasObj = true;
            break;
        }
    }
    if (!hasObj) {
        [delegateOrientations addObject:delegateOrientation];
    }
}

+(BOOL) hookMethodOrientation{
    NSArray *hookMethodNames;
    if(([self isSubclassOfClass:[UIViewController class]] || self == [UIViewController class])){
        @synchronized (self) {
            if (isExcuteUIViewControllerHookOrientationMethod) {
                return false;
            }
            isExcuteUIViewControllerHookOrientationMethod = true;
        }
        if (IOS8_OR_LATER) {
            hookMethodNames =
            @[@"shouldAutorotate",
              @"supportedInterfaceOrientations",
              @"preferredInterfaceOrientationForPresentation",
              @"willRotateToInterfaceOrientation:duration:",
              @"viewWillTransitionToSize:withTransitionCoordinator:",
              @"didRotateFromInterfaceOrientation:"];
        }else{
            hookMethodNames =
            @[@"shouldAutorotate",
              @"supportedInterfaceOrientations",
              @"preferredInterfaceOrientationForPresentation",
              @"willRotateToInterfaceOrientation:duration:",
              @"didRotateFromInterfaceOrientation:"];
        }
        return [UIViewController hookWithMethodNames:hookMethodNames];
    }
    return false;
}


#pragma UIViewcontrollerHookOrientationDelegate ===>
//重写父类方法判断是否可以旋转
-(void) beforeExcuteShouldAutorotate:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = false;
}
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target{
    return true;
}

//重写父类方法判断支持的旋转方向
-(void) beforeExcuteSupportedInterfaceOrientations:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = false;
}
-(NSUInteger) afterExcuteSupportedInterfaceOrientationsWithTarget:(nonnull UIViewController *) target{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

//重写父类方法返回当前方向
-(void) beforeExcutePreferredInterfaceOrientationForPresentation:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = false;
}
-(UIInterfaceOrientation) afterExcutePreferredInterfaceOrientationForPresentationWithTarget:(nonnull UIViewController *) target{
    return UIInterfaceOrientationPortrait;
}

//⇒ 重写父类方法旋转开始和结束
-(void) beforeExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = true;
}
-(void) afterExcuteViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator target:(nonnull UIViewController *)target{
}
-(void) beforeExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = true;
}
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target{
}

-(void) beforeExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation isExcute:(nonnull BOOL *) isExcute target:(nonnull UIViewController *)target{
    *isExcute = true;
}
-(void) afterExcuteDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation target:(nonnull UIViewController *)target{
    [self setNeedsStatusBarAppearanceUpdate];
}
//⇐
#pragma UIViewcontrollerHookOrientationDelegate <===

@end
