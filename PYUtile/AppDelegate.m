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
@interface PYParseTest : NSObject<PYObjectParseProtocol>{
@public
    int ivarInt;
    CGRect ivarRect;
    NSString * ivarString;
    PYParseTest * ivarTest;
}
kPNA int keyId;
kPNA int keyNewVar;
kPNA CGRect pRect;
kPNSNA NSDate * date;
kPNSNA NSString * keyDescription;
kPNSNA PYParseTest * pTest;
kPNSNA NSArray<PYParseTest *> * pTests;
kPNSNA NSArray<NSArray<PYParseTest *> *> * pTestss;
kPNSNA NSArray * trainPassengers;


kPNSNA PYParseTest * property_pTests;
kPNSNA PYParseTest * property_pTestss;
@end

@interface SMEBudgetListParam : PYParseTest

/** 登录人ID */
kPNA NSInteger employeeId;
kPNA NSInteger budgetId;
kPNSNA NSString * budgetName;
kPNSNA NSString * masterName;
kPNSNA NSString * masterTel;
kPNA NSInteger year;
kPNSNA NSString * __remove_dict_obj;

kPNA NSInteger pageIndex;//=DEFAULT_PAGE_INDEX;
kPNA NSInteger pageSize;//=DEFAULT_PAGE_SIZE;

@end

@implementation SMEBudgetListParam

-(instancetype) init{
    self = [super init];
    self.pageIndex = 1;
    self.pageSize = 20;
    self.__remove_dict_obj = @"444";
    return self;
}

@end
@implementation PYParseTest

//-(nullable NSArray *) pyObjectGetKeysForParseValue{
//    return @[@"keyNewVar",@"ketId"];
//}
@end

NSTimer * timer;
@interface AppDelegate (){
//    PYNetworkReachabilityNotification * nrn;
}
@end

@implementation AppDelegate

- (int)test01:(int )v {
    return 2 + v;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * arg = @"2020-10-14T15:00:35.000+00:00";//
    [arg dateFormateString:nil];
    [NSString matchArg:arg regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2}T\\d{2}:\\d{2}:\\d{2})$"];
//    NSString *  args  = @"<p dir=\"auto\" style=\"font-family:'Times New Roman';font-size:16px;\"><img src=\"http://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&f=JPEG?w=900&h=1350\" /><span style=\"color:#505050;\"><br />testtesttest<br /></span><a href=\"https://www.baidu.com\"><span style=\"color:#0000ee;text-decoration:underline;\">wewe</span></a><span style=\"color:#505050;\"><br />testtesttest2</span></p>\n";
//    PYXmlDocument * doc =[PYXmlDocument instanceWithXmlString:args];
//    SMEBudgetListParam * params = [SMEBudgetListParam new];
//    id obj = [params objectToDictionary];
//    NSLog(doc.rootElement.stringValue);

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
