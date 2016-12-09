//
//  PYReachabilityNotification.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYReachabilityNotification.h"

static PYReachabilityNotification *xPYReachabilityNotification;

@interface PYReachabilityNotification()

@property (nonatomic, strong) NSHashTable<id<PYReachabilityNotification>> *tableListeners;
@property (nonatomic, strong) Reachability *hostReach;

@end

@implementation PYReachabilityNotification
+(nonnull instancetype) instanceSingle{
    @synchronized(self) {
        if (!xPYReachabilityNotification) {
            xPYReachabilityNotification = [PYReachabilityNotification new];
        }
    }
    return xPYReachabilityNotification;
}
-(instancetype) init{
    if (self = [super init]) {
        self.tableListeners = [NSHashTable<id<PYReachabilityNotification>> weakObjectsHashTable];
        _status = ReachableViaWiFi;
        //开启网络状况的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        self.hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
        [self.hostReach startNotifier];  //开始监听，会启动一个run loop
        
    }
    return self;
}
//网络链接改变时会调用的方法
-(void)reachabilityChanged:(NSNotification *)note{
    @synchronized(self.tableListeners){
        Reachability *currReach = [note object];
        NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
        //对连接改变做出响应处理动作
        _status = [currReach currentReachabilityStatus];
        for (id<PYReachabilityNotification> listener in self.tableListeners) {
            switch (self.status) {
                case NotReachable:{
                    if ([listener respondsToSelector:@selector(notReachable)]) {
                        [listener notReachable];
                    }
                }
                    // 没有网络连接
                    break;
                case ReachableViaWWAN:{
                    if ([listener respondsToSelector:@selector(reachableViaWWAN)]) {
                        [listener reachableViaWWAN];
                    }
                }
                    // 使用3G网络
                    break;
                case ReachableViaWiFi:{
                    if ([listener respondsToSelector:@selector(reachableViaWiFi)]) {
                        [listener reachableViaWiFi];
                    }
                }
                    // 使用WiFi网络
                    break;
            }
        }
    }
}
-(void) addListener:(nonnull id<PYReachabilityNotification>) listener{
    @synchronized(self.tableListeners){
        if ([self.tableListeners containsObject:listener]) {
            return;
        }
        [self.tableListeners addObject:listener];
    }
}
-(void) removeListenser:(nonnull id<PYReachabilityNotification>) listener{
    @synchronized(self.tableListeners){
        [self.tableListeners removeObject:listener];
    }
}

-(void) dealloc{
    [self.tableListeners removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
