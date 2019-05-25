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
#import "NSObject+__PYHook_Private.h"

static id HookOrientationSynTag = @"";
static id HookOrientationTempSynTag = @"";
static BOOL HookOrientationIsIteritor = NO;
BOOL isExcuteUIViewControllerHookOrientationMethod = false;

@implementation UIViewController(HookOrientation)

//重写父类方法判断是否可以旋转
-(BOOL) exchangeShouldAutorotate{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteShouldAutorotate:target:)]) {
            [delegate beforeExcuteShouldAutorotate:&isExcute target:self];
        }
    } target:self];
    
    __block BOOL result = false;
    if (isExcute) {
        result = [self exchangeShouldAutorotate];
    }
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(aftlerExcuteShouldAutorotateWithTarget:)]) {
            result = [delegate aftlerExcuteShouldAutorotateWithTarget:self];
        }
        if (delegate && [delegate respondsToSelector:@selector(aftlerExcuteShouldAutorotateWithTarget:result:)]) {
            result = [delegate aftlerExcuteShouldAutorotateWithTarget:self result:result];
        }
    } target:self];
    return result;
}

//重写父类方法判断支持的旋转方向
-(UIInterfaceOrientationMask) exchangeSupportedInterfaceOrientations{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteSupportedInterfaceOrientations:target:)]) {
            [delegate beforeExcuteSupportedInterfaceOrientations:&isExcute target:self];
        }
    } target:self];
    
    __block UIInterfaceOrientationMask result = 0;
    if (isExcute) {
        result = [self exchangeSupportedInterfaceOrientations];
    }
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteSupportedInterfaceOrientationsWithTarget:)]) {
            result = [delegate afterExcuteSupportedInterfaceOrientationsWithTarget:self];
        }
    } target:self];
    
    return result;
}
//重写父类方法返回当前方向
- (UIInterfaceOrientation) exchangePreferredInterfaceOrientationForPresentation{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcutePreferredInterfaceOrientationForPresentation:target:)]) {
            [delegate beforeExcutePreferredInterfaceOrientationForPresentation:&isExcute target:self];
        }
    } target:self];
    
    __block UIInterfaceOrientation result = UIInterfaceOrientationUnknown;
    if (isExcute) {
        result = [self exchangePreferredInterfaceOrientationForPresentation];
    }
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcutePreferredInterfaceOrientationForPresentationWithTarget:)]) {
            result = [delegate afterExcutePreferredInterfaceOrientationForPresentationWithTarget:self];
        }
    } target:self];
    
    return result;
}
-(void) exchangeViewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteViewWillTransitionToSize:withTransitionCoordinator:isExcute:target:)]) {
            [delegate beforeExcuteViewWillTransitionToSize:size withTransitionCoordinator:coordinator isExcute:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeViewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    }
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteViewWillTransitionToSize:withTransitionCoordinator:target:)]) {
            [delegate afterExcuteViewWillTransitionToSize:size withTransitionCoordinator:coordinator target:self];
        }
    } target:self];
}
//⇒ 重写父类方法旋转开始和结束
-(void) exchangeWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration{
    __block BOOL isExcute = true;
    
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteWillRotateToInterfaceOrientation:duration:isExcute:target:)]) {
            [delegate beforeExcuteWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration isExcute:&isExcute target:self];
        }
    } target:self];
    
    if (isExcute) {
        [self exchangeWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate){
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteWillRotateToInterfaceOrientation:duration:target:)]) {
            [delegate afterExcuteWillRotateToInterfaceOrientation:toInterfaceOrientation duration:duration target:self];
        }
    } target:self];
}
-(void) exchangeDidRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation{
    __block BOOL isExcute = true;
    NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> * delegates = [self.class delegateOrientations];
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDidRotateFromInterfaceOrientation:isExcute:target:)]) {
            [delegate beforeExcuteDidRotateFromInterfaceOrientation:fromInterfaceOrientation isExcute:&isExcute target:self];
        }
    } target:self];
    if (isExcute) {
        [self exchangeDidRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }
    [UIViewController hookOrientationIteratorTable:delegates block:^(id delegate) {
        if (delegate && [delegate respondsToSelector:@selector(afterExcuteDidRotateFromInterfaceOrientation:target:)]) {
            [delegate afterExcuteDidRotateFromInterfaceOrientation:fromInterfaceOrientation target:self];
        }
    } target:self];
}
//⇐

+(nullable NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> *) delegateOrientations{
    return [self __paramsDictForHookExpand].delegateOrientations;
}
+(void) setDelegateOrientations:(nullable NSHashTable<id<UIViewcontrollerHookOrientationDelegate>> *) delegateOrientations{
    [self __paramsDictForHookExpand].delegateOrientations = delegateOrientations;
}
+(void) hookOrientationIteratorTable:(nonnull NSHashTable *) table block:(void(^)(id sub)) block target:(nonnull UIViewController *) target{
    if(![UIViewController canExcuHookMethod:target]) return;
    @synchronized (HookOrientationSynTag) {
        HookOrientationIsIteritor = YES;
        for (id sub in table) {
            block(sub);
        }
        HookOrientationIsIteritor = NO;
        @synchronized (HookOrientationTempSynTag) {
            NSMutableArray * temps = [self __paramsDictForHookExpand].delegateOrientationsTemp;
            if(temps && temps.count > 0){
                for (id temp in temps) {
                    [self addDelegateOrientation:temp];
                }
            }
            [temps removeAllObjects];
        }
    }
}
+(void) addDelegateOrientation:(nullable id<UIViewcontrollerHookOrientationDelegate>) delegateOrientation{
    if(HookOrientationIsIteritor && delegateOrientation){
        @synchronized (HookOrientationTempSynTag) {
            NSMutableArray * temps = [self __paramsDictForHookExpand].delegateOrientationsTemp;
            if(temps == nil){
                temps = [NSMutableArray new];
                [self __paramsDictForHookExpand].delegateOrientationsTemp = temps;
            }
            [temps addObject:delegateOrientation];
        }
        return;
    }
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
-(BOOL) aftlerExcuteShouldAutorotateWithTarget:(nonnull UIViewController *) target result:(BOOL) result{
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
