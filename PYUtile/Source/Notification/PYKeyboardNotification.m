//
//  PYKeyboardNotification.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/10/23.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYKeyboardNotification.h"
#import "PYInvoke.h"
#import "EXTScope.h"
#import <objc/runtime.h>
#import "UIResponder+Hook.h"
//#import "UIView+Hook.h"


@interface PYKeyboardNotification()
+(NSNumber*) getKeyWithResponder:(UIResponder*) responder;
@end

NSMapTable<NSNumber*, NSMutableDictionary*> *PYNotifactionTableBlock;

@interface UIResponderHookBaseDelegateImp : NSObject<UIResponderHookBaseDelegate>
-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target;
@end

//@interface UIViewHookDelegateImp : NSObject<UIViewHookDelegate>
//-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target;
//@end

@implementation UIResponderHookBaseDelegateImp
-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target{
    [PYKeyboardNotification removeKeyboardNotificationWithResponder:(UIResponder *)target];
    [PYKeyboardNotification hiddenKeyboard];
}
@end

//@implementation UIViewHookDelegateImp
//-(void) beforeExcuteRemoveFromSuperview:(nonnull BOOL *) isExcute target:(nonnull UIView *) target{
//    *isExcute = true;
//    [PYKeyboardNotification removeKeyboardNotificationWithResponder:target];
//    [PYKeyboardNotification hiddenKeyboard];
//}
//@end
UIResponderHookBaseDelegateImp * xUIResponderHookBaseDelegateImp;
//UIViewHookDelegateImp * xUIViewHookDelegateImp;

@protocol PYNOtifactionProtocolTag <NSObject>@end


const NSString * PYNotifactionTableKeyResponder = @"a";

const NSString * PYNotifactionTableKeyBlockShowBegin = @"b";
const NSString * PYNotifactionTableKeyBlockHiddenBegin = @"c";
const NSString * PYNotifactionTableKeyBlockShowing = @"d";
const NSString * PYNotifactionTableKeyBlockHiddening = @"e";
const NSString * PYNotifactionTableKeyBlockShowEnd = @"f";
const NSString * PYNotifactionTableKeyBlockHiddenEnd = @"g";


@implementation PYKeyboardNotification
+(void) initialize{
    NSMapTable<NSNumber*, NSMutableDictionary*> *tableBlock  = [NSMapTable<NSNumber*, NSMutableDictionary*> strongToStrongObjectsMapTable];
    PYNotifactionTableBlock = tableBlock;
}
+(NSMutableDictionary *) preparSetKeyboardNotificationWithResponder:(nonnull UIResponder*) responder{
    
    if (![responder isKindOfClass:[UIResponder class]]) {
        return false;
    }
    [self hookResponder:responder];
    NSMutableDictionary *dict = nil;
    @synchronized(PYNotifactionTableBlock) {
        NSNumber *key  = [self getKeyWithResponder:responder];
         dict = [PYNotifactionTableBlock objectForKey:key];
        if (!dict) {
            dict = [NSMutableDictionary new];
            SEL selInputShow = @selector(inputshow:);
            SEL selInputHidden = @selector(inputhidden:);
            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector: selInputHidden name: UIKeyboardWillHideNotification object:nil];
            [PYNotifactionTableBlock setObject:dict forKey:key];
        }
    }
    return dict;
}
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘显示开始
 @showing 键盘显示中
 @showEnd 键盘显示结束
 */
+(BOOL)setKeyboardNotificationShowWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nonnull BlockKeyboardAnimatedBE) end{
    
    NSMutableDictionary *dict = [self preparSetKeyboardNotificationWithResponder:responder];
    if (!dict) {
        return false;
    }
    @synchronized(PYNotifactionTableBlock) {
        if (begin) {
            [dict setObject:begin forKey:PYNotifactionTableKeyBlockShowBegin];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockShowBegin];
        }
        if (doing) {
            [dict setObject:doing forKey:PYNotifactionTableKeyBlockShowing];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockShowing];
        }
        if (end) {
            [dict setObject:end forKey:PYNotifactionTableKeyBlockShowEnd];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockShowEnd];
        }
    }
    return true;
}
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘隐藏开始
 @showing 键盘隐藏中
 @showEnd 键盘隐藏结束
 */
+(BOOL)setKeyboardNotificationHiddenWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nonnull BlockKeyboardAnimatedBE) end{
    
    NSMutableDictionary *dict = [self preparSetKeyboardNotificationWithResponder:responder];
    if (!dict) {
        return false;
    }
    @synchronized(PYNotifactionTableBlock) {
        if (begin) {
            [dict setObject:begin forKey:PYNotifactionTableKeyBlockHiddenBegin];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockHiddenBegin];
        }
        if (doing) {
            [dict setObject:doing forKey:PYNotifactionTableKeyBlockHiddening];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockHiddening];
        }
        if (end) {
            [dict setObject:end forKey:PYNotifactionTableKeyBlockHiddenEnd];
        }else{
            [dict removeObjectForKey:PYNotifactionTableKeyBlockHiddenEnd];
        }
    }
    return true;
}
+(BOOL) removeKeyboardNotificationWithResponder:(nonnull UIResponder*) responder{
    @synchronized(PYNotifactionTableBlock) {
        NSNumber *key  = [self getKeyWithResponder:responder];
        [PYNotifactionTableBlock removeObjectForKey:key];
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillHideNotification object:nil];
    }
    return true;
}
+(BOOL) hiddenKeyboard{
   return  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//+(BOOL)setKeyboardNotificationWithResponder:(nonnull UIResponder*) responder start:(nonnull BlockKeyboardAnimatedDoing) blockStart end:(nonnull BlockKeyboardAnimatedDoing) blockEnd{
//    if (![responder isKindOfClass:[UIResponder class]]) {
//        return false;
//    }
//    [self hookResponder:responder];
//    @synchronized(PYNotifactionTableBlock) {
//        
//        NSNumber *key  = [self getKeyWithResponder:responder];
//        NSMutableDictionary *dic = [PYNotifactionTableBlock objectForKey:key];
//        if (!dic) {
//            dic = [NSMutableDictionary new];
//            SEL selInputShow = @selector(inputshow:);
//            SEL selInputHidden = @selector(inputhidden:);
//            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
//            [[NSNotificationCenter defaultCenter]addObserver:responder selector: selInputHidden name: UIKeyboardWillHideNotification object:nil];
//        }
//        [dic setDictionary:@{
//                             PYNotifactionTableKeyBlockShowing:blockStart,
//                             PYNotifactionTableKeyBlockHiddening:blockEnd
//                             } ];
//        [PYNotifactionTableBlock setObject:dic forKey:key];
//    }
//    return true;
//}
//+(BOOL)setKeyboardNotificationWithResponder:(nonnull UIResponder*) responder completionStart:(nonnull BlockKeyboardAnimatedBE) blockCompletionStart completionEnd:(nonnull BlockKeyboardAnimatedBE) blockCompletionEnd{
//    if (![responder isKindOfClass:[UIResponder class]]) {
//        return false;
//    }
//    [self hookResponder:responder];
//    @synchronized(PYNotifactionTableBlock) {
//        NSNumber *key  = [self getKeyWithResponder:responder];
//        NSMutableDictionary *dic = [PYNotifactionTableBlock objectForKey:key];
//        if (!dic) {
//            dic = [NSMutableDictionary new];
//            SEL selInputShow = @selector(inputshow:);
//            SEL selInputHidden = @selector(inputhidden:);
//            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
//            [[NSNotificationCenter defaultCenter]addObserver:responder selector: selInputHidden name: UIKeyboardWillHideNotification object:nil];
//        }
//        [dic setDictionary:@{
//                             PYNotifactionTableKeyBlockShowEnd:blockCompletionStart,
//                             PYNotifactionTableKeyBlockHiddenEnd:blockCompletionEnd
//                             }];
//        [PYNotifactionTableBlock setObject:dic forKey:key];
//    }
//    return true;
//}




-(void)inputshow:(NSNotification *)notification{
    if (![self isKindOfClass:[UIResponder class]]) {
        return;
    }
    __weak UIResponder *responder = (UIResponder*)self;
    
    //如果对象没有获取到焦点就不执行事件
    if (![responder isFirstResponder]) {
        return;
    }
    NSNumber *key  = [PYKeyboardNotification getKeyWithResponder:responder];
    
    BlockKeyboardAnimatedBE begin = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockShowBegin];
    __weak BlockKeyboardAnimatedDoing doing = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockShowing];
    __weak BlockKeyboardAnimatedBE end = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockShowEnd];
    
    if (!begin &&  !doing && !end) {
        return;
    }
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyBoardFrame.size.height == 0) {
        return;
    }
    if(begin && responder)begin(responder);
    [UIView animateWithDuration:animationTime>0?animationTime:0.25 animations:^{
        if (doing && responder) {
            doing(responder,keyBoardFrame);
        }
    } completion:^(BOOL finished) {
        if (end && responder) {
            end(responder);
        }
    }];
    
    
}

-(void)inputhidden:(NSNotification *)notification{
    if (![self isKindOfClass:[UIResponder class]]) {
        return;
    }
    __weak UIResponder *responder = (UIResponder*)self;
    
    //如果对象没有获取到焦点就不执行事件
    if (![responder isFirstResponder]) {
        return;
    }
    
    NSNumber *key  = [PYKeyboardNotification getKeyWithResponder:responder];
    
    BlockKeyboardAnimatedBE begin = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockHiddenBegin];
    __weak BlockKeyboardAnimatedDoing doing = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockHiddening];
    __weak BlockKeyboardAnimatedBE end = [[PYNotifactionTableBlock objectForKey:key] objectForKey:PYNotifactionTableKeyBlockHiddenEnd];
    
    if (!begin &&  !doing && !end) {
        return;
    }
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __block CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (keyBoardFrame.size.height == 0) {
        return;
    }
    if (begin && responder) begin(responder);
    [UIView animateWithDuration:animationTime>0?animationTime:0.25 animations:^{
        if (doing && responder) {
            doing(responder,keyBoardFrame);
        }
    } completion:^(BOOL finished) {
        if (end && responder) {
            end(responder);
        }
    }];
    
}
+(void) hookResponder:(UIResponder*) responder{
    @synchronized(responder) {
        SEL selInputShow = @selector(inputshow:);
        SEL selInputHidden = @selector(inputhidden:);
        if (![responder conformsToProtocol:@protocol(PYNOtifactionProtocolTag)]) {
            [UIResponder hookWithMethodNames:nil];
            if (xUIResponderHookBaseDelegateImp == nil) {
                xUIResponderHookBaseDelegateImp = [UIResponderHookBaseDelegateImp new];
            }
            [[UIResponder delegateBase] addObject:xUIResponderHookBaseDelegateImp];
            
            
            Method mInputShow = class_getInstanceMethod(self, selInputShow);
            Method mInputHidden = class_getInstanceMethod(self, selInputHidden);
            class_addMethod(responder.class, selInputShow, method_getImplementation(mInputShow), method_getTypeEncoding(mInputShow));
            class_addMethod(responder.class, selInputHidden, method_getImplementation(mInputHidden), method_getTypeEncoding(mInputHidden));
            class_addProtocol(responder.class, @protocol(PYNOtifactionProtocolTag));
        }
    }
}
+(NSNumber*) getKeyWithResponder:(UIResponder*) responder{
    return @(responder.hash);
}

@end
