//
//  UIResponder+PYKeyboard.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "UIResponder+PYKeyboard.h"
#import "PYKeyboardNotificationObject.h"

void * PYKeyboardNotifyPointerContextPointer = &PYKeyboardNotifyPointerContextPointer;

@implementation UIResponder(PYKeyboard)
-(void) addPYKeyboroard_pointerContext{
//    PYKeyboardNotifyPointerContext * rkpc = self.pykeyboroard_pointerContext;
//    if(rkpc) return;
//    rkpc = [[PYKeyboardNotifyPointerContext alloc] initWithResponder:self];
//    objc_setAssociatedObject(self, PYKeyboardNotifyPointerContextPointer, rkpc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [[PYKeyboardNotificationObject shareObject] addNoitfyContext:rkpc];
}
-(void) removePYKeyboroard_pointerContext{
//    PYKeyboardNotifyPointerContext * rkpc = self.pykeyboroard_pointerContext;
//    if(!rkpc) return;
//    [[PYKeyboardNotificationObject shareObject] removeNoitfyContext:rkpc];
}
-(PYKeyboardNotifyPointerContext * _Nonnull) pykeyboroard_pointerContext{
    PYKeyboardNotifyPointerContext * rkpc = objc_getAssociatedObject(self, PYKeyboardNotifyPointerContextPointer);
    return rkpc;
}
@end
