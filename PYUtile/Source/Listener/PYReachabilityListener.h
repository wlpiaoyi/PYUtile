//
//  PYReachabilityListener.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Reachability.h"

/**
 网络链接发生改变是对应要执行的协议方法
 */
@protocol PYReachabilityListener <NSObject>
/**
 没有网络
 */
-(void) notReachable;
/**
 2G/3G/4G网络
 */
-(void) reachableViaWWAN;
/**
 WIFI/WLAN网络
 */
-(void) reachableViaWiFi;
@end

@interface PYReachabilityListener : NSObject
@property (nonatomic, readonly) NetworkStatus status;
+(nonnull instancetype) instanceSingle;
-(void) addListener:(nonnull id<PYReachabilityListener>) listener;
-(void) removeListenser:(nonnull id<PYReachabilityListener>) listener;
@end
