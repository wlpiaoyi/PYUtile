//
//  OrientationsListener.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PYOrientationNotification <NSObject>
@optional
// Device oriented vertically, home button on the bottom
-(void) deviceOrientationPortrait;
// Device oriented vertically, home button on the top
-(void) deviceOrientationPortraitUpsideDown;
// Device oriented horizontally, home button on the right
-(void) deviceOrientationLandscapeLeft;
// Device oriented horizontally, home button on the left
-(void) deviceOrientationLandscapeRight;
// Device oriented horizontally, home button not support
-(void) deviceOrientationNotSupport:(UIDeviceOrientation) deviceOrientation;
@end
@interface PYOrientationNotification : NSObject
//当前旋转方向
@property(nonatomic,readonly) UIDeviceOrientation deviceOrientation;
//当前控制器方向
@property(nonatomic,readonly) UIInterfaceOrientation interfaceOrientation;
//旋转时间
@property(nonatomic) NSTimeInterval duration;
+(nonnull instancetype) instanceSingle;
/**
 旋转当前装置
 只有当iOS版本大于10才有Timer
 */
-(nullable NSTimer *) attemptRotationToDeviceOrientation:(UIDeviceOrientation) deviceOrientation completion:(void (^ _Nullable)(NSTimer * _Nullable timer)) completion;
-(void) addListener:(nonnull id<PYOrientationNotification>) listener;
-(void) removeListenser:(nonnull id<PYOrientationNotification>) listener;
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportDeviceOrientation:(UIDeviceOrientation) orientation;
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportDeviceOrientation:(UIDeviceOrientation) orientation targetController:(nonnull UIViewController *) targetController;

/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation targetController:(nonnull UIViewController *) targetController;
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportInterfaceOrientationMask:(UIInterfaceOrientationMask) interfaceOrientationMask targetController:(nonnull UIViewController *) targetController;
@end
