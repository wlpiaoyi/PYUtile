//
//  UIViewController+HookView.h
//  PYFrameWork
//
//  Created by wlpiaoyi on 16/1/16.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewcontrollerHookViewDelegate<NSObject>

@optional
-(void) beforeExcuteViewDidLoad:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewDidLoadWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewWillAppear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewDidAppear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewDidAppearWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewWillDisappear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewWillDisappearWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewDidDisappear:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewDidDisappearWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewWillLayoutSubviews:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewWillLayoutSubviewsWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcuteViewDidLayoutSubviews:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(void) afterExcuteViewDidLayoutSubviewsWithTarget:(nonnull UIViewController *) target;

-(void) beforeExcutePreferredStatusBarStyle:(nonnull BOOL *) isExcute target:(nonnull UIViewController *) target;
-(UIStatusBarStyle) afterExcutePreferredStatusBarStyleWithTarget:(nonnull UIViewController *) target;
@end

@interface UIViewController(hookview)
+(nullable NSHashTable<id<UIViewcontrollerHookViewDelegate>> *) delegateViews;
+(void) addDelegateView:(nonnull id<UIViewcontrollerHookViewDelegate>) delegateView;
+(BOOL) hookMethodView;
@end
