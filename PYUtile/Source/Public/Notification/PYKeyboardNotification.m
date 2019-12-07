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
#import "PYKeyboardNotificationObject.h"
#import "PYKeyboardNotifyPointerContext.h"
#import "UIResponder+PYKeyboard.h"




@implementation PYKeyboardNotification
+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PYCurrentKeyboardFrame = CGRectZero;
        [UIResponder hookWithMethodNames:nil];
    });
}
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘显示开始
 @showing 键盘显示中
 @showEnd 键盘显示结束
 */
+(BOOL)setKeyboardNotificationShowWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nullable BlockKeyboardAnimatedBE) end{
  [responder addPYKeyboroard_pointerContext];
  responder.pykeyboroard_pointerContext.showBeginKeyboarAnimation = begin;
  responder.pykeyboroard_pointerContext.showDoingKeyboarAnimation = doing;
  responder.pykeyboroard_pointerContext.showEndKeyboarAnimation = end;
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
    [responder addPYKeyboroard_pointerContext];
    responder.pykeyboroard_pointerContext.hiddenBeginKeyboarAnimation = begin;
    responder.pykeyboroard_pointerContext.hiddenDoingKeyboarAnimation = doing;
    responder.pykeyboroard_pointerContext.hiddenEndKeyboarAnimation = end;
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
    [responder removePYKeyboroard_pointerContext];
    return true;
}
+(BOOL) hiddenKeyboard{
   return  [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end



//@implementation UIResponderHookBaseDelegateImp
//-(void) beforeExcuteDealloc:(nonnull BOOL *) isExcute target:(nonnull NSObject *) target{
//    if([target isKindOfClass:[UIResponder class]] && ((UIResponder*)target).pykeyboroard_pointerContext){
//        [PYKeyboardNotification hiddenKeyboard];
//    }
//}
//@end
