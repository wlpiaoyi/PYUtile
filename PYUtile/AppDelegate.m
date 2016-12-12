//
//  AppDelegate.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "pyutilea.h"
@interface Test1:NSObject
@property (nonatomic, assign) CGSize s;
@property (nonatomic, assign) PYEdgeInsetsItem e;
@property (nonatomic, strong) Test1 * t;
@property (nonatomic, strong) NSArray<Test1 *> * ts;
@property (nonatomic, strong) Test1 * property_ts;
@end
@implementation Test1 @end

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Test1 * t1 = [Test1 new];
    t1.s = CGSizeMake(3, 3);
    t1.t = [Test1 new];
    t1.ts = @[t1.t];
    PYEdgeInsetsItem e= PYEdgeInsetsItemNull();
    e.top = (__bridge void *)t1;
    t1.e = e;
    t1.t.s = CGSizeMake(3, 4);
    t1.t.e = PYEdgeInsetsItemNull();
    NSDictionary * obj = (NSDictionary *)[t1 objectToDictionary];
    t1 = [NSObject objectWithDictionary:obj clazz:t1.class];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
