//
//  AppDelegate.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "pyutilea.h"
#import <objc/runtime.h>
#import "PYXml.h"
#import "PYKeychain.h"



@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    dispatch_queue_t myqueue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t myqueue2 = dispatch_queue_create("queue2", DISPATCH_QUEUE_CONCURRENT);
    void * p = NULL;
    void (^block1) (void) = [self testBlock:&p];
    NSInteger i = p;
    void * p1 = i;
//    NSString * a1 = (__bridge NSString *)(p1);
//    NSString * b = (__bridge NSString *)();
    NSLog(@"1");
    //同步执行任务创建方法
    dispatch_sync(myqueue1, ^{
        void * p2 = i;
//        NSString * a2 = (__bridge NSString *)(p2);
        NSLog(@"1-1");
        sleep(1);
        NSLog(@"1-2");
        block1();
        
    });
    dispatch_sync(myqueue2, ^{
        NSLog(@"2-1");
        sleep(1);
        NSLog(@"2-2");
    });
    NSLog(@"2");
    //主队列的获取方法
    dispatch_queue_t queue = dispatch_get_main_queue();
    //获取全局并发队列的方法
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    return YES;
}

-(void (^) (void)) testBlock:(void **) pointer{
    NSObject * args = [NSObject new];
    NSLog(@"args1,%@", args);
    void * p1 = (__bridge void *)(args);
    *pointer = p1;
    kAssign(<#type#>)
    __unsafe_unretained typeof(args) args2 = args;
    void (^block1) (void) = ^(void){
        NSLog(@"args2,%@", args2);
    };
    block1();
    return block1;
}

- (void)motionBeganWithEvent:(nullable UIEvent *)event{
    
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
