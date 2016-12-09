//
//  PYMotionListener.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/19.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYMotionListener.h"
#import "PYHook.h"

NSString * PYMotionBeganNotification = @"PYMotionBeganNotification";
NSString * PYMotionEndedNotification = @"PYMotionEndedNotification";
NSString * PYMotionCanceledNotification = @"PYMotionCanceledNotification";

static PYMotionListener * xPYMotionListener;
@interface PYMotionListener()

@property (nonatomic,strong) NSHashTable<id<PYMotionListener>> *tableListeners;

@end

@implementation PYMotionListener
+(nonnull instancetype) instanceSingle{
    @synchronized(self) {
        if (!xPYMotionListener) {
            xPYMotionListener = [PYMotionListener new];
        }
    }
    return xPYMotionListener;
}

-(instancetype) init{
    if (self = [super init]) {
        // 设置允许摇一摇功能
        [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(motionBeganWithEvent:) name:PYMotionBeganNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(motionEndedWithEvent:) name:PYMotionEndedNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(motionCancelledWithEvent:) name:PYMotionCanceledNotification object:nil];
        
        self.tableListeners = [NSHashTable<id<PYMotionListener>> weakObjectsHashTable];
        
        static dispatch_once_t predicate;
        dispatch_once(&predicate, ^{
            
            [PYHook mergeHookInstanceWithTarget:[UIWindow class] action:@selector(motionBegan:withEvent:) blockBefore:^BOOL(NSInvocation *invoction) {
                return true;
            } blockAfter:^(NSInvocation *invoction) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PYMotionBeganNotification object:nil];
            }];
            [PYHook mergeHookInstanceWithTarget:[UIWindow class] action:@selector(motionEnded:withEvent:) blockBefore:^BOOL(NSInvocation *invoction) {
                return true;
            } blockAfter:^(NSInvocation *invoction) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PYMotionEndedNotification object:nil];
            }];
            [PYHook mergeHookInstanceWithTarget:[UIWindow class] action:@selector(motionCancelled:withEvent:) blockBefore:^BOOL(NSInvocation *invoction) {
                return true;
            } blockAfter:^(NSInvocation *invoction) {
                [[NSNotificationCenter defaultCenter] postNotificationName:PYMotionCanceledNotification object:nil];
            }];
        });
    }
    return self;
}
-(void) addListener:(nonnull id<PYMotionListener>) listener{
    @synchronized(self.tableListeners) {
        [self.tableListeners addObject:listener];
    }
}
-(void) removeListenser:(nonnull id<PYMotionListener>) listener{
    @synchronized(self.tableListeners) {
        [self.tableListeners removeObject:listener];
    }
}

- (void)motionBeganWithEvent:(nullable UIEvent *)event{
    @synchronized(self.tableListeners) {
        for (id<PYMotionListener> listner in self.tableListeners) {
            if ([listner respondsToSelector:@selector(motionBeganWithEvent:)]) {
                [listner motionBeganWithEvent:event];
            }
        }
    }
}
- (void)motionEndedWithEvent:(nullable UIEvent *)event{
    @synchronized(self.tableListeners) {
        for (id<PYMotionListener> listner in self.tableListeners) {
            if ([listner respondsToSelector:@selector(motionEndedWithEvent:)]) {
                [listner motionEndedWithEvent:event];
            }
        }
    }
}
- (void)motionCancelledWithEvent:(nullable UIEvent *)event{
    @synchronized(self.tableListeners) {
        for (id<PYMotionListener> listner in self.tableListeners) {
            if ([listner respondsToSelector:@selector(motionCancelledWithEvent:)]) {
                [listner motionCancelledWithEvent:event];
            }
        }
    }
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
