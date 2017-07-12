//
//  UIView+Hook.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/8/22.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UIViewHookDelegate<NSObject>
@optional
-(void) beforeExcuteAddSubview:(nonnull UIView *)view isExcute:(nonnull BOOL *) isExcute target:(nonnull UIView *) target;
-(void) afterExcuteAddSubview:(nonnull UIView *)view target:(nonnull UIView *) target;

-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target;
-(void) afterExcuteRemoveFromSuperviewWithTarget:(nonnull UIView *) target;
@end

@interface UIView(Hook)
+(nullable NSHashTable<id<UIViewHookDelegate>> *) delegateViews;
+(void) addDelegateView:(nonnull id<UIViewHookDelegate>) delegateView;
+(BOOL) hookMethodView;
@end
