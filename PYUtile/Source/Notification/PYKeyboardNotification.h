//
//  PYKeyboardNotification.h
//  UtileScourceCode


//
//  Created by wlpiaoyi on 15/10/23.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockKeyboardAnimatedDoing)(UIResponder * _Nonnull responder, CGRect keyBoardFrame);
typedef void (^BlockKeyboardAnimatedBE)(UIResponder * _Nonnull responder);
/**
 键盘监听
 目标对象被回收时自动隐藏键盘
 */
@interface PYKeyboardNotification : NSObject
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘显示开始
 @showing 键盘显示中
 @showEnd 键盘显示结束
 */
+(BOOL)setKeyboardNotificationShowWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nullable BlockKeyboardAnimatedBE) end;
/**
 键盘监听事件添加
 @responder 输入源
 @showBegin 键盘隐藏开始
 @showing 键盘隐藏中
 @showEnd 键盘隐藏结束
 */
+(BOOL)setKeyboardNotificationHiddenWithResponder:(nonnull UIResponder*) responder begin:(nullable BlockKeyboardAnimatedBE) begin doing:(nullable BlockKeyboardAnimatedDoing) doing end:(nullable BlockKeyboardAnimatedBE) end;

/**
 移除键盘监听事件
 */
+(BOOL) removeKeyboardNotificationWithResponder:(nonnull UIResponder*) responder;
/**
 隐藏键盘
 */
+(BOOL) hiddenKeyboard;

@end
