//
//  PYKeyboardNotificationObject.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYKeyboardNotificationObject.h"
#import "PYKeyboardNotifyPointerContext.h"
#import "UIResponder+PYKeyboard.h"

CGRect PYCurrentKeyboardFrame;
PYKeyboardNotificationObject * xPYKeyboardNotificationObject;

//@interface PYKeyboardUIResponderHookBaseDelegateImpl : NSObject<UIResponderHookBaseDelegate>
//@end
//
//@implementation PYKeyboardUIResponderHookBaseDelegateImpl
//
//-(void) beforeExcuteDeallocWithTarget:(nonnull NSObject *) target{
//    if([target isKindOfClass:[UIResponder class]]){
//
//    }
//}
//
//@end

@implementation PYKeyboardNotificationObject

+(nonnull PYKeyboardNotificationObject *) shareObject{
    if(xPYKeyboardNotificationObject == nil)
    @synchronized ([PYKeyboardNotificationObject class]) {
        [UIResponder hookWithMethodNames:nil];
//        [UIResponder delegateBase]addObject:(nullable id<UIResponderHookBaseDelegate>)
        if(xPYKeyboardNotificationObject == nil){
            xPYKeyboardNotificationObject = [PYKeyboardNotificationObject new];
        }
    }
    return xPYKeyboardNotificationObject;
}

-(instancetype) init{
    self = [super init];
//    SEL selInputShow = @selector(py_keybord_inputshow:);
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:selInputShow name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:selInputShow name:UIKeyboardWillChangeFrameNotification object:nil];
//    SEL selInputHidden = @selector(py_keybord_inputhidden:);
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:selInputHidden name:UIKeyboardWillHideNotification object:nil];
//    _notifyContextSet = [NSMutableSet new];
    return self;
}

-(void)py_keybord_inputshow:(NSNotification *)notification{
//    PYCurrentKeyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (PYCurrentKeyboardFrame.size.height == 0) return;
//    if([_notifyContextSet count] <= 0) return;
//
//    @synchronized (_notifyContextSet) {
//        for (NSNumber * object in _notifyContextSet) {
//            void * pointer = (void *)object.longValue;
//            PYKeyboardNotifyPointerContext * noitfyContext = (__bridge PYKeyboardNotifyPointerContext *)(pointer);
//            BlockKeyboardAnimatedBE begin =  noitfyContext.showBeginKeyboarAnimation;
//            BlockKeyboardAnimatedDoing doing = noitfyContext.showDoingKeyboarAnimation;
//            BlockKeyboardAnimatedBE end = noitfyContext.showEndKeyboarAnimation;
//
//            if (!begin &&  !doing && !end) return;
//
//            UIResponder *responder = noitfyContext.responder;
//            CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//            if(begin) begin(responder);
//
//            [UIView animateWithDuration:animationTime > 0 ? animationTime : 0.25 animations:^{
//                if (doing ) {
//                    doing(responder,PYCurrentKeyboardFrame);
//                }
//            } completion:^(BOOL finished) {
//                if (end) {
//                    end(responder);
//                }
//            }];
//        }
//    }
}

-(void)py_keybord_inputhidden:(NSNotification *)notification{
//    PYCurrentKeyboardFrame = CGRectZero;
//    if([_notifyContextSet count] <= 0) return;
//
//    @synchronized (_notifyContextSet) {
//        for (NSNumber * object in _notifyContextSet) {
//            void * pointer = (void *)object.longValue;
//            PYKeyboardNotifyPointerContext * noitfyContext = (__bridge PYKeyboardNotifyPointerContext *)(pointer);
//            BlockKeyboardAnimatedBE begin = noitfyContext.hiddenBeginKeyboarAnimation;
//            BlockKeyboardAnimatedDoing doing = noitfyContext.hiddenDoingKeyboarAnimation;
//            BlockKeyboardAnimatedBE end = noitfyContext.hiddenEndKeyboarAnimation;
//            if (!begin &&  !doing && !end) return;
//            UIResponder *responder = noitfyContext.responder;
//            __block CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//            CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//            if (begin ) begin(responder);
//            [UIView animateWithDuration:animationTime>0?animationTime:0.25 animations:^{
//                if (doing) {
//                    doing(responder,keyBoardFrame);
//                }
//            } completion:^(BOOL finished) {
//                if (end) {
//                    end(responder);
//                }
//            }];
//        }
//    }
}

-(void) addNoitfyContext:(nonnull PYKeyboardNotifyPointerContext *) notifyContext{
//    @synchronized (_notifyContextSet) {
//        void * pointer = (__bridge void *)(notifyContext);
//        NSNumber * object = @((long) pointer);
//        if([_notifyContextSet containsObject:object]) return;
//        [_notifyContextSet addObject:object];
//    }
}
-(void) removeNoitfyContext:(nonnull PYKeyboardNotifyPointerContext *) notifyContext{
//    @synchronized (_notifyContextSet) {
//        void * pointer = (__bridge void *)(notifyContext);
//        NSNumber * object = @((long) pointer);
//        [_notifyContextSet removeObject:object];
//    }
}

-(void) dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

@end
