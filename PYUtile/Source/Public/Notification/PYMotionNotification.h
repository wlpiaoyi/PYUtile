//
//  PYMotionNotification.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/19.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PYMotionNotification <NSObject>
- (void)motionBeganWithEvent:(nullable UIEvent *)event;
- (void)motionEndedWithEvent:(nullable UIEvent *)event;
- (void)motionCancelledWithEvent:(nullable UIEvent *)event;
@end


/**
 手机摇晃监听
 */
@interface PYMotionNotification : NSObject
+(nonnull instancetype) instanceSingle;
-(void) addListener:(nonnull id<PYMotionNotification>) listener;
-(void) removeListenser:(nonnull id<PYMotionNotification>) listener;
@end
