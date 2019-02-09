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
#import "PYUtile.h"

CGRect PYCurrentKeyboardFrame;

void * PYKeyboardNotifyPointerContextPointer = &PYKeyboardNotifyPointerContextPointer;

@interface PYKeyboardNotifyPointerContext : NSObject
@property BOOL hasAddShowKeyboard;
@property BOOL hasAddHiddenKeyboard;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE showBeginKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedDoing showDoingKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE showEndKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE hiddenBeginKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedDoing hiddenDoingKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE hiddenEndKeyboarAnimation;
@end


@interface UIResponder(Keyboard)
@property (nonatomic, readonly) PYKeyboardNotifyPointerContext * pykeyboroard_pointerContext;
-(void)py_keybord_inputshow:(NSNotification *)notification;
-(void)py_keybord_inputhidden:(NSNotification *)notification;
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
        if( ((UIResponder*)target).pykeyboroard_pointerContext.hasAddShowKeyboard || ((UIResponder*)target).pykeyboroard_pointerContext.hasAddHiddenKeyboard){
            ((UIResponder*)target).pykeyboroard_pointerContext.hasAddShowKeyboard = ((UIResponder*)target).pykeyboroard_pointerContext.hasAddHiddenKeyboard = false;
            [PYKeyboardNotification removeKeyboardNotificationWithResponder:(UIResponder *)target];
            [PYKeyboardNotification hiddenKeyboard];
        }
    }
}
@end

UIResponderHookBaseDelegateImp * xUIResponderHookBaseDelegateImp;


@implementation PYKeyboardNotification
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        syn_UIResponder_Keyboard = [NSObject new];
        PYCurrentKeyboardFrame = CGRectZero;
        [UIResponder hookWithMethodNames:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PY_KEYBOARD_SHOW:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PY_KEYBOARD_HIDDEN:) name:UIKeyboardWillChangeFrameNotification object:nil];
    });
}
+(void) PY_KEYBOARD_SHOW:(NSNotification *)notification{
    PYCurrentKeyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
}
+(void) PY_KEYBOARD_HIDDEN:(NSNotification *)notification{
    PYCurrentKeyboardFrame = CGRectZero;
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
        if(!responder.pykeyboroard_pointerContext.hasAddShowKeyboard){
            SEL selInputShow = @selector(py_keybord_inputshow:);
            [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillChangeFrameNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector:selInputShow name:UIKeyboardWillChangeFrameNotification object:nil];
            responder.pykeyboroard_pointerContext.hasAddShowKeyboard = true;
        }
        responder.pykeyboroard_pointerContext.showBeginKeyboarAnimation = begin;
        responder.pykeyboroard_pointerContext.showDoingKeyboarAnimation = doing;
        responder.pykeyboroard_pointerContext.showEndKeyboarAnimation = end;
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
        if(!responder.pykeyboroard_pointerContext.hasAddHiddenKeyboard){
            SEL selInputHidden = @selector(py_keybord_inputhidden:);
            [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillHideNotification object:nil];
            [[NSNotificationCenter defaultCenter]addObserver:responder selector: selInputHidden name: UIKeyboardWillHideNotification object:nil];
            responder.pykeyboroard_pointerContext.hasAddHiddenKeyboard = true;
        }
        responder.pykeyboroard_pointerContext.hiddenBeginKeyboarAnimation = begin;
        responder.pykeyboroard_pointerContext.hiddenDoingKeyboarAnimation = doing;
        responder.pykeyboroard_pointerContext.hiddenEndKeyboarAnimation = end;
    }
    return true;
}
/**
 键盘监听事件添加
 @responder 输入源
 @showDoing 键盘显示中
 @hiddenDoing 键盘隐藏中
 */
+(BOOL)setKeyboardNotificationWithResponder:(UIResponder *)responder
                                  showDoing:(nullable BlockKeyboardAnimatedDoing)showDoing
                                hiddenDoing:(nullable BlockKeyboardAnimatedDoing)hiddenDoing{
    BOOL result = [PYKeyboardNotification setKeyboardNotificationShowWithResponder:responder begin:nil doing:showDoing end:nil];
    result = result | [PYKeyboardNotification setKeyboardNotificationHiddenWithResponder:responder begin:nil doing:hiddenDoing end:nil];
    return result;
}
+(BOOL) removeKeyboardNotificationWithResponder:(nonnull UIResponder*) responder{
    @synchronized(syn_UIResponder_Keyboard) {
        responder.pykeyboroard_pointerContext.hasAddShowKeyboard = responder.pykeyboroard_pointerContext.hasAddHiddenKeyboard = false;
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:responder name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return true;
}
+(BOOL) hiddenKeyboard{
   return  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end

@implementation UIResponder(Keyboard)

-(void)py_keybord_inputshow:(NSNotification *)notification{
    if (![self isKindOfClass:[UIResponder class]]) {
        return;
    }
    __weak UIResponder *responder = (UIResponder*)self;
    PYCurrentKeyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (PYCurrentKeyboardFrame.size.height == 0) return;
    if(responder.pykeyboroard_pointerContext.hasAddShowKeyboard == false) return;
    
    BlockKeyboardAnimatedBE begin =  responder.pykeyboroard_pointerContext.showBeginKeyboarAnimation;
    BlockKeyboardAnimatedDoing doing = responder.pykeyboroard_pointerContext.showDoingKeyboarAnimation;
    BlockKeyboardAnimatedBE end = responder.pykeyboroard_pointerContext.showEndKeyboarAnimation;
    
    if (!begin &&  !doing && !end) return;
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if(begin && responder)begin(responder);
    [UIView animateWithDuration:animationTime > 0 ? animationTime : 0.25 animations:^{
        if (doing && responder) {
            doing(responder,PYCurrentKeyboardFrame);
        }
    } completion:^(BOOL finished) {
        if (end && responder) {
            end(responder);
        }
    }];
    
    
}

-(void)py_keybord_inputhidden:(NSNotification *)notification{
    if (![self isKindOfClass:[UIResponder class]]) {
        return;
    }
    PYCurrentKeyboardFrame = CGRectZero;
    __weak UIResponder *responder = (UIResponder*)self;
    if(responder.pykeyboroard_pointerContext.hasAddHiddenKeyboard == false) return;
    
    BlockKeyboardAnimatedBE begin = responder.pykeyboroard_pointerContext.hiddenBeginKeyboarAnimation;
    BlockKeyboardAnimatedDoing doing = responder.pykeyboroard_pointerContext.hiddenDoingKeyboarAnimation;
    BlockKeyboardAnimatedBE end = responder.pykeyboroard_pointerContext.hiddenEndKeyboarAnimation;
    
    if (!begin &&  !doing && !end) return;
    
    __block CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
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
-(PYKeyboardNotifyPointerContext * _Nonnull) pykeyboroard_pointerContext{
    PYKeyboardNotifyPointerContext * rkpc = objc_getAssociatedObject(self, PYKeyboardNotifyPointerContextPointer);
    if(rkpc == nil){
        rkpc = [PYKeyboardNotifyPointerContext new];
        objc_setAssociatedObject(self, PYKeyboardNotifyPointerContextPointer, rkpc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rkpc;
}
@end
@implementation PYKeyboardNotifyPointerContext @end
