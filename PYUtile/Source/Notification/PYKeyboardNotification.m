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

void * UIResponderKeyboardPointerContextPointer = &UIResponderKeyboardPointerContextPointer;

@interface UIResponderKeyboardPointerContext : NSObject
@property BOOL hasHookKeyboard;
@property BOOL hasAddShowKeyboard;
@property BOOL hasAddHiddenKeyboard;
@property (nonatomic, nullable) BlockKeyboardAnimatedBE showBeginKeyboarAnimation;
@property (nonatomic, nullable) BlockKeyboardAnimatedDoing showDoingKeyboarAnimation;
@property (nonatomic, nullable) BlockKeyboardAnimatedBE showEndKeyboarAnimation;
@property (nonatomic, nullable) BlockKeyboardAnimatedBE hiddenBeginKeyboarAnimation;
@property (nonatomic, nullable) BlockKeyboardAnimatedDoing hiddenDoingKeyboarAnimation;
@property (nonatomic, nullable) BlockKeyboardAnimatedBE hiddenEndKeyboarAnimation;
@end


@interface UIResponder(Keyboard)
@property (nonatomic, readonly) UIResponderKeyboardPointerContext * pointerContext;
@end
@interface PYKeyboardNotification()
@end

NSObject * syn_UIResponder_Keyboard;

@interface UIResponderHookBaseDelegateImp : NSObject<UIResponderHookBaseDelegate>
-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target;
@end


@implementation UIResponderHookBaseDelegateImp
-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target{
    if([target isKindOfClass:[UIResponder class]]){
        if( ((UIResponder*)target).pointerContext.hasAddShowKeyboard || ((UIResponder*)target).pointerContext.hasAddHiddenKeyboard){
            ((UIResponder*)target).pointerContext.hasAddShowKeyboard = ((UIResponder*)target).pointerContext.hasAddHiddenKeyboard = false;
            [PYKeyboardNotification removeKeyboardNotificationWithResponder:(UIResponder *)target];
            [PYKeyboardNotification hiddenKeyboard];
        }
    }
}
@end

UIResponderHookBaseDelegateImp * xUIResponderHookBaseDelegateImp;

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
    syn_UIResponder_Keyboard = [NSObject new];
}
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘显示开始
 @showing 键盘显示中
 @showEnd 键盘显示结束
 */
+(BOOL)setKeyboardNotificationShowWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nullable BlockKeyboardAnimatedBE) end{
    @synchronized(syn_UIResponder_Keyboard) {
        if(!responder.pointerContext.hasAddShowKeyboard){
            SEL selInputShow = @selector(inputshow:);
            [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
            responder.pointerContext.hasAddShowKeyboard = true;
        }
        if(!responder.pointerContext.hasHookKeyboard){
            responder.pointerContext.hasHookKeyboard = true;
            [PYKeyboardNotification hookResponder:responder];
        }
        responder.pointerContext.showBeginKeyboarAnimation = begin;
        responder.pointerContext.showDoingKeyboarAnimation = doing;
        responder.pointerContext.showEndKeyboarAnimation = end;
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
+(BOOL)setKeyboardNotificationHiddenWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nullable BlockKeyboardAnimatedBE) end{
    @synchronized(syn_UIResponder_Keyboard) {
        if(!responder.pointerContext.hasAddHiddenKeyboard){
            SEL selInputHidden = @selector(inputhidden:);
            [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector: selInputHidden name: UIKeyboardWillHideNotification object:nil];
            responder.pointerContext.hasAddHiddenKeyboard = true;
        }
        if(!responder.pointerContext.hasHookKeyboard){
            responder.pointerContext.hasHookKeyboard = true;
            [PYKeyboardNotification hookResponder:responder];
        }
        responder.pointerContext.hiddenBeginKeyboarAnimation = begin;
        responder.pointerContext.hiddenDoingKeyboarAnimation = doing;
        responder.pointerContext.hiddenEndKeyboarAnimation = end;
    
    }
    return true;
}
+(BOOL) removeKeyboardNotificationWithResponder:(nonnull UIResponder*) responder{
    @synchronized(syn_UIResponder_Keyboard) {
        responder.pointerContext.hasAddShowKeyboard = responder.pointerContext.hasAddHiddenKeyboard = false;
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillHideNotification object:nil];
    }
    return true;
}
+(BOOL) hiddenKeyboard{
   return  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



-(void)inputshow:(NSNotification *)notification{
    if (![self isKindOfClass:[UIResponder class]]) {
        return;
    }
    __weak UIResponder *responder = (UIResponder*)self;
    
    //如果对象没有获取到焦点就不执行事件
    if (![responder isFirstResponder]) {
        return;
    }
    
    BlockKeyboardAnimatedBE begin =  responder.pointerContext.showBeginKeyboarAnimation;
    BlockKeyboardAnimatedDoing doing = responder.pointerContext.showDoingKeyboarAnimation;
    BlockKeyboardAnimatedBE end = responder.pointerContext.showEndKeyboarAnimation;
    
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
    
    BlockKeyboardAnimatedBE begin = responder.pointerContext.hiddenBeginKeyboarAnimation;
    BlockKeyboardAnimatedDoing doing = responder.pointerContext.hiddenDoingKeyboarAnimation;
    BlockKeyboardAnimatedBE end = responder.pointerContext.hiddenEndKeyboarAnimation;
    
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

@end

@implementation UIResponder(Keyboard)
-(UIResponderKeyboardPointerContext * _Nonnull) pointerContext{
    UIResponderKeyboardPointerContext * rkpc = objc_getAssociatedObject(self, UIResponderKeyboardPointerContextPointer);
    if(rkpc == nil){
        rkpc = [UIResponderKeyboardPointerContext new];
        objc_setAssociatedObject(self, UIResponderKeyboardPointerContextPointer, rkpc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rkpc;
}
@end
@implementation UIResponderKeyboardPointerContext @end
