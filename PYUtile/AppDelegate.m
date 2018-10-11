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
#import "PYNetworkReachabilityNotification.h"
SINGLETON_SYNTHESIZE_FOR_hCLASS(PyTest, NSObject, <NSObject>);
@end
SINGLETON_SYNTHESIZE_FOR_mCLASS(PyTest){
    
}
@end

@interface Test1:NSObject<UITextFieldDelegate>{
@public int _pvalue0;
@private NSDictionary * _dict;
}
@property (nonatomic, strong) NSString * name1;
@property (nonatomic) SEL action;
@property (nonatomic, readonly, getter=isValue0) NSNumber * value0;
@property (nonatomic, strong) NSNumber * value00;
@property (nonatomic, strong) NSArray * value1;
@property (nonatomic, strong) NSDate * value2;
@property (nonatomic, retain) NSData * value3;
@property (nonatomic, retain) NSDictionary * value4;
@property (nonatomic, strong) NSArray * value5;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) Test1 * t1;
@end
@implementation Test1
-(instancetype) init{
    self = [super init];
    _dict =@{@"a":@"ba"};
    _value0 = @(4);
    return self;
}
@end
@interface Test2:Test1
@property (nonatomic) NSString * name2;
@end
@implementation Test2
@end
@interface Test3:NSObject
@end
@implementation Test3
@end

NSTimer * timer;
@interface AppDelegate (){
    PYNetworkReachabilityNotification * nrn;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString * a = [PYUtile MD5ForLower32Bate:@"adfasdf39847$%"];

    return YES;
}

-(void) test{
    
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
