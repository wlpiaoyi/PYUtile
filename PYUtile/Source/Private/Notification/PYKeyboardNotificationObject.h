//
//  PYKeyboardNotificationObject.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYKeyboardNotifyPointerContext.h"

NS_ASSUME_NONNULL_BEGIN


@interface PYKeyboardNotificationObject : NSObject
@property (nonatomic, readonly, copy) NSMutableSet<NSNumber *> * notifyContextSet;
+(nonnull PYKeyboardNotificationObject *) shareObject;
-(void)py_keybord_inputshow:(NSNotification *)notification;
-(void)py_keybord_inputhidden:(NSNotification *)notification;
-(void) addNoitfyContext:(nonnull PYKeyboardNotifyPointerContext *) notifyContext;
-(void) removeNoitfyContext:(nonnull PYKeyboardNotifyPointerContext *) notifyContext;
@end

NS_ASSUME_NONNULL_END
