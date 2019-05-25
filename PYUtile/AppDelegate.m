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
@interface PYParseTest : NSObject{
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

@implementation PYParseTest @end

NSTimer * timer;
@interface AppDelegate (){
//    PYNetworkReachabilityNotification * nrn;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray * bbb = @[@{@"a":@"b"}];

    float ft1 =  [@"abcdef" likePercentForCompare:@"abcdef"];
    float ft2 =  [@"abcdef" likePercentForCompare:@"abcde"];
    float ft3 =  [@"dabcdef" likePercentForCompare:@"abcdef"];
    [NSObject dictionaryAnalysisForClass:@{@"bb":@"adfa",@"aa":[NSNull null]}];
    NSLog(@"%ld %ld", [@"0xabcdef48733" toInteger] ,0xabcdef48733);
    NSLog(@"%ld %ld", [@"0b100100101111" toInteger] ,0b100100101111);

    NSLog(@"%@", [@"1999-08-08" dateFormateString:nil]);
    NSLog(@"%@", [@"1999-08-08 02:02" dateFormateString:nil]);
    NSLog(@"%@", [@"1999-08-08 02:02:02" dateFormateString:nil]);

    [@"2001-01-10 08" dateFormateString:@"yyyy-MM-dd HH"];
//    [dft dateFromString:@];
    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
    for (int i = 0; i<100; i++) {
        PYParseTest * t = [PYParseTest new];
        t.keyNewVar = 2;
        t->ivarInt = 2;
        t->ivarRect = CGRectMake(2, 3, 4, 5);
        t->ivarString = @"adfasdfafasdf";
        t.date = [NSDate date];
        t.keyId = 3;
        t.pRect = CGRectMake(4, 5, 6, 7);
        t.keyDescription = @"adfaf";
        NSDictionary * dict = [t objectToDictionary];
        t.pTest = [PYParseTest objectWithDictionary:dict];
        dict = [t objectToDictionary];
        t.pTests = @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]];
        dict = [t objectToDictionary];
        t.pTestss = @[
                      @[@[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]], @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]]],
                      @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]]
                      ];
        dict = [t objectToDictionary];
        t = [PYParseTest objectWithDictionary:dict];
        PYParseTest * t2 = [PYParseTest new];
        [PYParseTest copyValueFromObj:t toObj:t2];
        t2 = [t deepCopyObject];
        id copyArray = [t2.pTests deepCopyObject];
        copyArray = [t2.pTestss deepCopyObject];
        NSLog(@"");
    }
//    NSLog(@"======>%f", [NSDate timeIntervalSinceReferenceDate] - timer);
//
//    NSString * a = @"ewogICJ0cmFpblBhc3NlbmdlcnMiIDogWwogICAgewogICAgICAicGFzc2VuZ2VyTW9iaWxlIiA6ICIxMzkxMDAwMDAwMSIsCiAgICAgICJwYXNzZW5nZXJDZXJ0aWZpY2F0ZVR5cGVOYW1lIiA6ICLmiqTnhaciLAogICAgICAicGFzc2VuZ2VyU291cmNlVHlwZSIgOiAiRU1QTE9ZRUUiLAogICAgICAiY2hhbmdlRmxhZyIgOiAiMSIsCiAgICAgICJuZWVkUGF5RGF0ZSIgOiB7CiAgICAgICAgIm5lZWRQYXlQcmljZSIgOiAiMCIsCiAgICAgICAgImlzTmVlZFBheSIgOiAiTiIKICAgICAgfSwKICAgICAgInBhc3Nlbmdlck5hbWUiIDogIueOi+S4gCIsCiAgICAgICJwYXNzZW5nZXJDZXJ0aWZpY2F0ZUNvZGUiIDogIkcyMjE1NTQiLAogICAgICAidGlja2V0Vmlld0xpc3QiIDogWwogICAgICAgIHsKICAgICAgICAgICJpZCIgOiAiMTM2MiIsCiAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAidGlja2V0Q29kZSIgOiAiMnNIWTEiLAogICAgICAgICAgInBheVByaWNlIiA6ICI0NS41IiwKICAgICAgICAgICJjcmVhdGVEYXRlIiA6ICIyMDE5LTAxLTE1IDE3OjU3OjM4IiwKICAgICAgICAgICJiZWxvbmdPcmRlckNvZGUiIDogIlNCVDIwMTkwMTE1MDAwMDA4IiwKICAgICAgICAgICJzdGF0dXNOYW1lIiA6ICLpooTorqLmiJDlip8iLAogICAgICAgICAgInJlZnVuZE9yQ2hhbmdlRmVlIiA6ICIwIiwKICAgICAgICAgICJ0eXBlIiA6ICJPUkRFUiIsCiAgICAgICAgICAib2xkVGlja2V0SWQiIDogIm51bGwiLAogICAgICAgICAgImJlbG9uZ09yZGVySWQiIDogIjEyMTAiLAogICAgICAgICAgInRpY2tldFByaWNlIiA6ICIzNy41IiwKICAgICAgICAgICJ0cmFpblNlZ21lbnQiIDogewogICAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAgICJ0cmFpbk51bSIgOiAiMzMzOCIsCiAgICAgICAgICAgICJ0cmFpbklkIiA6ICIzMzM4IiwKICAgICAgICAgICAgImRlcFN0YXRpb25OYW1lIiA6ICLmiJDpg70iLAogICAgICAgICAgICAiZGVwU3RhdGlvbkNvZGUiIDogIkNEVyIsCiAgICAgICAgICAgICJhcnJTdGF0aW9uTmFtZSIgOiAi6L6+5beeIiwKICAgICAgICAgICAgImFyclN0YXRpb25Db2RlIiA6ICJSWFciLAogICAgICAgICAgICAiYXJyVGltZSIgOiAiMjAxOS0wMS0xOSAwODowNzowMCIsCiAgICAgICAgICAgICJkZXBUaW1lIiA6ICIyMDE5LTAxLTE5IDAzOjQyOjAwIiwKICAgICAgICAgICAgImR1cmF0aW9uVGltZSIgOiAiMDQ6MjUiLAogICAgICAgICAgICAic2VhdEdyYWRlTmFtZSIgOiAi56Gs5bqnIiwKICAgICAgICAgICAgInNlYXRHcmFkZSIgOiAiMSIKICAgICAgICAgIH0sCiAgICAgICAgICAic3RhdHVzQ29kZSIgOiAiNSIsCiAgICAgICAgICAic2VhdEdyYWRlIiA6ICJPIiwKICAgICAgICAgICJleHRyYUZlZSIgOiAiOC4wIgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgImlkIiA6ICIxMzYzIiwKICAgICAgICAgICJwYXlQcmljZSIgOiAiOTQuMCIsCiAgICAgICAgICAiY3JlYXRlRGF0ZSIgOiAiMjAxOS0wMS0xNSAxNzo1ODoxMiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJDb2RlIiA6ICJTQlRDMjAxOTAxMTUwMDAwMDMiLAogICAgICAgICAgInN0YXR1c05hbWUiIDogIuaUueetvuWksei0pSIsCiAgICAgICAgICAicmVmdW5kT3JDaGFuZ2VGZWUiIDogIjAuMCIsCiAgICAgICAgICAidHlwZSIgOiAiQ0hBTkdFIiwKICAgICAgICAgICJvbGRUaWNrZXRJZCIgOiAiMTM2MiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJJZCIgOiAiMTIxMSIsCiAgICAgICAgICAidGlja2V0UHJpY2UiIDogIjEzMS41IiwKICAgICAgICAgICJ0cmFpblNlZ21lbnQiIDogewogICAgICAgICAgICAic2VhdEdyYWRlIiA6ICIzIiwKICAgICAgICAgICAgImFyclRpbWUiIDogIjIwMTktMDEtMTkgMTQ6MzE6MDAiLAogICAgICAgICAgICAic2VhdEdyYWRlTmFtZSIgOiAi56Gs5Y2nIiwKICAgICAgICAgICAgImFyclN0YXRpb25OYW1lIiA6ICLovr7lt54iLAogICAgICAgICAgICAiYXJyU3RhdGlvbkNvZGUiIDogIlJYVyIsCiAgICAgICAgICAgICJkZXBUaW1lIiA6ICIyMDE5LTAxLTE5IDA5OjQ5OjAwIiwKICAgICAgICAgICAgInRyYWluSWQiIDogIksxMjU4IiwKICAgICAgICAgICAgImR1cmF0aW9uVGltZSIgOiAiMDQ6NDIiLAogICAgICAgICAgICAidHJhaW5OdW0iIDogIksxMjU4IiwKICAgICAgICAgICAgImRlcFN0YXRpb25Db2RlIiA6ICJJQ1ciLAogICAgICAgICAgICAiZGVwU3RhdGlvbk5hbWUiIDogIuaIkOmDveS4nCIKICAgICAgICAgIH0sCiAgICAgICAgICAic3RhdHVzQ29kZSIgOiAiOTMiLAogICAgICAgICAgInNlYXRHcmFkZSIgOiAiMyIsCiAgICAgICAgICAiZXh0cmFGZWUiIDogIjAuMCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICJpZCIgOiAiMTM2NCIsCiAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAidGlja2V0Q29kZSIgOiAiMnNIWTEiLAogICAgICAgICAgInBheVByaWNlIiA6ICItMzUuNSIsCiAgICAgICAgICAiY3JlYXRlRGF0ZSIgOiAiMjAxOS0wMS0xNSAxNzo1ODo1NCIsCiAgICAgICAgICAiYmVsb25nT3JkZXJDb2RlIiA6ICJTQlRSMjAxOTAxMTUwMDAwMDIiLAogICAgICAgICAgInN0YXR1c05hbWUiIDogIumAgOelqOWksei0pSIsCiAgICAgICAgICAicmVmdW5kT3JDaGFuZ2VGZWUiIDogIjIuMCIsCiAgICAgICAgICAidHlwZSIgOiAiUkVGVU5EIiwKICAgICAgICAgICJvbGRUaWNrZXRJZCIgOiAiMTM2MiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJJZCIgOiAiMTIxMiIsCiAgICAgICAgICAidGlja2V0UHJpY2UiIDogIjM3LjUiLAogICAgICAgICAgInRyYWluU2VnbWVudCIgOiB7CiAgICAgICAgICAgICJzZWF0TnVtYmVyIiA6ICJYWOi9plhY5bqnIiwKICAgICAgICAgICAgInRyYWluTnVtIiA6ICIzMzM4IiwKICAgICAgICAgICAgInRyYWluSWQiIDogIjMzMzgiLAogICAgICAgICAgICAiZGVwU3RhdGlvbk5hbWUiIDogIuaIkOmDvSIsCiAgICAgICAgICAgICJkZXBTdGF0aW9uQ29kZSIgOiAiQ0RXIiwKICAgICAgICAgICAgImFyclN0YXRpb25OYW1lIiA6ICLovr7lt54iLAogICAgICAgICAgICAiYXJyU3RhdGlvbkNvZGUiIDogIlJYVyIsCiAgICAgICAgICAgICJhcnJUaW1lIiA6ICIyMDE5LTAxLTE5IDA4OjA3OjAwIiwKICAgICAgICAgICAgImRlcFRpbWUiIDogIjIwMTktMDEtMTkgMDM6NDI6MDAiLAogICAgICAgICAgICAiZHVyYXRpb25UaW1lIiA6ICIwNDoyNSIsCiAgICAgICAgICAgICJzZWF0R3JhZGVOYW1lIiA6ICLnoazluqciLAogICAgICAgICAgICAic2VhdEdyYWRlIiA6ICIxIgogICAgICAgICAgfSwKICAgICAgICAgICJzdGF0dXNDb2RlIiA6ICI5MiIsCiAgICAgICAgICAic2VhdEdyYWRlIiA6ICJPIiwKICAgICAgICAgICJleHRyYUZlZSIgOiAiMC4wIgogICAgICAgIH0KICAgICAgXSwKICAgICAgInJlZnVuZEZsYWciIDogIjEiCiAgICB9CiAgXQp9";
//    NSDictionary * dict = [[a toDataForBase64] toDictionary];
//    PYParseTest * t2 = [PYParseTest objectWithDictionary:dict];
    

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
