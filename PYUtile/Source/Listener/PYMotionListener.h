//
//  PYMotionListener.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/19.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PYMotionListener <NSObject>
- (void)motionBeganWithEvent:(nullable UIEvent *)event;
- (void)motionEndedWithEvent:(nullable UIEvent *)event;
- (void)motionCancelledWithEvent:(nullable UIEvent *)event;
@end


/**
 手机摇晃监听
 */
@interface PYMotionListener : NSObject
+(nonnull instancetype) instanceSingle;
-(void) addListener:(nonnull id<PYMotionListener>) listener;
-(void) removeListenser:(nonnull id<PYMotionListener>) listener;
@end
