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

@interface Test1:NSObject{
@public int _pint;
@private NSDictionary * _pdict;
}
@property (nonatomic, strong) NSString * keyNewP1;
@property (nonatomic, strong) NSNumber * keyId;
@property (nonatomic, strong) NSArray<NSArray <Test1 *> *> * parray1;
@property (nonatomic, strong) NSArray<Test1 *> * parray2;
@property (nonatomic, strong) Test1 * property_parray1;
@property (nonatomic, strong) Test1 * property_parray2;
@property (nonatomic, strong) id has_index_parray1;
@end
@implementation Test1
-(instancetype) init{
    self = [super init];
    return self;
}
@end

NSTimer * timer;
@interface AppDelegate (){
    PYNetworkReachabilityNotification * nrn;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    Test1 * t1 = [Test1 new];
    t1->_pint = 2;
    t1.keyNewP1 = @"str";
    t1.keyId = @(3);
    NSDictionary * dict1 = [t1 objectToDictionary];
    t1.parray1 = @[@[[Test1 objectWithDictionary:dict1], [Test1 objectWithDictionary:dict1]],@[[Test1 objectWithDictionary:dict1]]];
    t1.parray2 = @[[Test1 objectWithDictionary:dict1],[Test1 objectWithDictionary:dict1]];
    dict1 = [t1 objectToDictionary];
    t1 = [Test1 objectWithDictionary:dict1];
    [NSObject dictionaryAnalysisForClass:dict1];
    NSLog([NSObject dictionaryAnalysisForClass:dict1]);
    NSLog([t1 objectToFormWithSuffix:@"param"]);
    NSLog([t1 objectToFormWithSuffix:nil]);
//    NSString * a = [PYUtile MD5ForLower32Bate:@"adfasdf39847$%"];

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
