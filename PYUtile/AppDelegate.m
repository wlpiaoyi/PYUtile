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
@interface SMETrainDetailSegment : NSObject

kPNSNA NSString * seatGrade;//1
kPNSNA NSString * arrTime;//2018-04-30 14:58:00
kPNSNA NSString * seatGradeName;//硬座
kPNSNA NSString * seatNumber;//硬座
kPNSNA NSString * arrStationName;//郑州
kPNSNA NSString * arrStationCode;//ZZF
kPNSNA NSString * depTime;//2018-04-30 08:36:00
kPNSNA NSString * trainId;//Z149
kPNSNA NSString * durationTime;//06:22
kPNSNA NSString * trainNum;//Z149
kPNSNA NSString * depStationCode;//BXP
kPNSNA NSString * depStationName;//北京西

@end
@interface SMETrainDetailTicket : NSObject

kPNSNA NSString * belongOrderCode;
kPNSNA NSString * passengerNames;//129974
kPNSNA NSString * keyId;//129974
kPNSNA NSString * seatNumber;//10001
kPNSNA NSString * ticketCode;//2314
kPNSNA NSString * payPrice;//121.0
kPNSNA NSString * createDate;//2018-04-23 16:20:57
kPNSNA NSString * statusName;//退票中
kPNSNA NSString * refundOrChangeFee;//0
kPNSNA NSString * type;//ORDER
kPNSNA NSString * oldTicketId;//null
kPNSNA NSString * belongOrderId;//87869
kPNSNA NSString * ticketPrice;//93.0
kPNSNA SMETrainDetailSegment * trainSegment;
kPNSNA NSString * statusCode;//A11
kPNSNA NSString * extraFee;//8.0
kPNSNA NSString * seatGrade;

@end

@interface SMETrainDetailPassengers : NSObject

kPNSNA NSString * passengerMobile;//13810000002
kPNSNA NSString * passengerCertificateTypeName;//护照
kPNSNA NSString * passengerSourceType;//EMPLOYEE
kPNSNA NSString * changeFlag;//0
kPNSNA NSString * passengerName;//王二
kPNSNA NSString * passengerCertificateCode;//G665544
kPNSNA NSArray * ticketViewList;
kPNSNA SMETrainDetailTicket * property_ticketViewList;
kPNSNA SMETrainDetailTicket *recentTicket;//最近的票
kPNSNA NSString * refundFlag;//0
kPNA BOOL  isSelected;
kPNSNA NSString * needPayDate;
@end
@interface PYParseTest : NSObject{
@public
    int ivarInt;
    CGRect ivarRect;
    NSString * ivarString;
    PYParseTest * ivarTest;
}
//kPNA int keyId;
//kPNSNA NSString * keyDescription;
kPNA int keyId;
kPNA CGRect pRect;
kPNSNA NSDate * date;
kPNSNA NSString * keyDescription;
kPNSNA PYParseTest * pTest;
kPNSNA NSArray<PYParseTest *> * pTests;
kPNSNA NSArray<NSArray<PYParseTest *> *> * pTestss;
kPNSNA NSArray * trainPassengers;

kPNSNA SMETrainDetailPassengers * property_trainPassengers;

kPNSNA PYParseTest * property_pTests;
kPNSNA PYParseTest * property_pTestss;
@end

@implementation PYParseTest @end
@implementation SMETrainDetailPassengers @end
@implementation SMETrainDetailSegment @end
@implementation SMETrainDetailTicket @end

NSTimer * timer;
@interface AppDelegate (){
    PYNetworkReachabilityNotification * nrn;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
        t->ivarInt = 2;
        t->ivarRect = CGRectMake(2, 3, 4, 5);
        t->ivarString = @"adfasdfafasdf";
        t.keyId = 3;
        t.pRect = CGRectMake(4, 5, 6, 7);
        t.keyDescription = @"adfaf";
        NSDictionary * dict = [t objectToDictionary];
        ((NSMutableDictionary *)dict)[@"date"] = @(1515747850);
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
        NSLog(@"");
    }
    NSLog(@"======>%f", [NSDate timeIntervalSinceReferenceDate] - timer);
    
    NSString * a = @"ewogICJ0cmFpblBhc3NlbmdlcnMiIDogWwogICAgewogICAgICAicGFzc2VuZ2VyTW9iaWxlIiA6ICIxMzkxMDAwMDAwMSIsCiAgICAgICJwYXNzZW5nZXJDZXJ0aWZpY2F0ZVR5cGVOYW1lIiA6ICLmiqTnhaciLAogICAgICAicGFzc2VuZ2VyU291cmNlVHlwZSIgOiAiRU1QTE9ZRUUiLAogICAgICAiY2hhbmdlRmxhZyIgOiAiMSIsCiAgICAgICJuZWVkUGF5RGF0ZSIgOiB7CiAgICAgICAgIm5lZWRQYXlQcmljZSIgOiAiMCIsCiAgICAgICAgImlzTmVlZFBheSIgOiAiTiIKICAgICAgfSwKICAgICAgInBhc3Nlbmdlck5hbWUiIDogIueOi+S4gCIsCiAgICAgICJwYXNzZW5nZXJDZXJ0aWZpY2F0ZUNvZGUiIDogIkcyMjE1NTQiLAogICAgICAidGlja2V0Vmlld0xpc3QiIDogWwogICAgICAgIHsKICAgICAgICAgICJpZCIgOiAiMTM2MiIsCiAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAidGlja2V0Q29kZSIgOiAiMnNIWTEiLAogICAgICAgICAgInBheVByaWNlIiA6ICI0NS41IiwKICAgICAgICAgICJjcmVhdGVEYXRlIiA6ICIyMDE5LTAxLTE1IDE3OjU3OjM4IiwKICAgICAgICAgICJiZWxvbmdPcmRlckNvZGUiIDogIlNCVDIwMTkwMTE1MDAwMDA4IiwKICAgICAgICAgICJzdGF0dXNOYW1lIiA6ICLpooTorqLmiJDlip8iLAogICAgICAgICAgInJlZnVuZE9yQ2hhbmdlRmVlIiA6ICIwIiwKICAgICAgICAgICJ0eXBlIiA6ICJPUkRFUiIsCiAgICAgICAgICAib2xkVGlja2V0SWQiIDogIm51bGwiLAogICAgICAgICAgImJlbG9uZ09yZGVySWQiIDogIjEyMTAiLAogICAgICAgICAgInRpY2tldFByaWNlIiA6ICIzNy41IiwKICAgICAgICAgICJ0cmFpblNlZ21lbnQiIDogewogICAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAgICJ0cmFpbk51bSIgOiAiMzMzOCIsCiAgICAgICAgICAgICJ0cmFpbklkIiA6ICIzMzM4IiwKICAgICAgICAgICAgImRlcFN0YXRpb25OYW1lIiA6ICLmiJDpg70iLAogICAgICAgICAgICAiZGVwU3RhdGlvbkNvZGUiIDogIkNEVyIsCiAgICAgICAgICAgICJhcnJTdGF0aW9uTmFtZSIgOiAi6L6+5beeIiwKICAgICAgICAgICAgImFyclN0YXRpb25Db2RlIiA6ICJSWFciLAogICAgICAgICAgICAiYXJyVGltZSIgOiAiMjAxOS0wMS0xOSAwODowNzowMCIsCiAgICAgICAgICAgICJkZXBUaW1lIiA6ICIyMDE5LTAxLTE5IDAzOjQyOjAwIiwKICAgICAgICAgICAgImR1cmF0aW9uVGltZSIgOiAiMDQ6MjUiLAogICAgICAgICAgICAic2VhdEdyYWRlTmFtZSIgOiAi56Gs5bqnIiwKICAgICAgICAgICAgInNlYXRHcmFkZSIgOiAiMSIKICAgICAgICAgIH0sCiAgICAgICAgICAic3RhdHVzQ29kZSIgOiAiNSIsCiAgICAgICAgICAic2VhdEdyYWRlIiA6ICJPIiwKICAgICAgICAgICJleHRyYUZlZSIgOiAiOC4wIgogICAgICAgIH0sCiAgICAgICAgewogICAgICAgICAgImlkIiA6ICIxMzYzIiwKICAgICAgICAgICJwYXlQcmljZSIgOiAiOTQuMCIsCiAgICAgICAgICAiY3JlYXRlRGF0ZSIgOiAiMjAxOS0wMS0xNSAxNzo1ODoxMiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJDb2RlIiA6ICJTQlRDMjAxOTAxMTUwMDAwMDMiLAogICAgICAgICAgInN0YXR1c05hbWUiIDogIuaUueetvuWksei0pSIsCiAgICAgICAgICAicmVmdW5kT3JDaGFuZ2VGZWUiIDogIjAuMCIsCiAgICAgICAgICAidHlwZSIgOiAiQ0hBTkdFIiwKICAgICAgICAgICJvbGRUaWNrZXRJZCIgOiAiMTM2MiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJJZCIgOiAiMTIxMSIsCiAgICAgICAgICAidGlja2V0UHJpY2UiIDogIjEzMS41IiwKICAgICAgICAgICJ0cmFpblNlZ21lbnQiIDogewogICAgICAgICAgICAic2VhdEdyYWRlIiA6ICIzIiwKICAgICAgICAgICAgImFyclRpbWUiIDogIjIwMTktMDEtMTkgMTQ6MzE6MDAiLAogICAgICAgICAgICAic2VhdEdyYWRlTmFtZSIgOiAi56Gs5Y2nIiwKICAgICAgICAgICAgImFyclN0YXRpb25OYW1lIiA6ICLovr7lt54iLAogICAgICAgICAgICAiYXJyU3RhdGlvbkNvZGUiIDogIlJYVyIsCiAgICAgICAgICAgICJkZXBUaW1lIiA6ICIyMDE5LTAxLTE5IDA5OjQ5OjAwIiwKICAgICAgICAgICAgInRyYWluSWQiIDogIksxMjU4IiwKICAgICAgICAgICAgImR1cmF0aW9uVGltZSIgOiAiMDQ6NDIiLAogICAgICAgICAgICAidHJhaW5OdW0iIDogIksxMjU4IiwKICAgICAgICAgICAgImRlcFN0YXRpb25Db2RlIiA6ICJJQ1ciLAogICAgICAgICAgICAiZGVwU3RhdGlvbk5hbWUiIDogIuaIkOmDveS4nCIKICAgICAgICAgIH0sCiAgICAgICAgICAic3RhdHVzQ29kZSIgOiAiOTMiLAogICAgICAgICAgInNlYXRHcmFkZSIgOiAiMyIsCiAgICAgICAgICAiZXh0cmFGZWUiIDogIjAuMCIKICAgICAgICB9LAogICAgICAgIHsKICAgICAgICAgICJpZCIgOiAiMTM2NCIsCiAgICAgICAgICAic2VhdE51bWJlciIgOiAiWFjovaZYWOW6pyIsCiAgICAgICAgICAidGlja2V0Q29kZSIgOiAiMnNIWTEiLAogICAgICAgICAgInBheVByaWNlIiA6ICItMzUuNSIsCiAgICAgICAgICAiY3JlYXRlRGF0ZSIgOiAiMjAxOS0wMS0xNSAxNzo1ODo1NCIsCiAgICAgICAgICAiYmVsb25nT3JkZXJDb2RlIiA6ICJTQlRSMjAxOTAxMTUwMDAwMDIiLAogICAgICAgICAgInN0YXR1c05hbWUiIDogIumAgOelqOWksei0pSIsCiAgICAgICAgICAicmVmdW5kT3JDaGFuZ2VGZWUiIDogIjIuMCIsCiAgICAgICAgICAidHlwZSIgOiAiUkVGVU5EIiwKICAgICAgICAgICJvbGRUaWNrZXRJZCIgOiAiMTM2MiIsCiAgICAgICAgICAiYmVsb25nT3JkZXJJZCIgOiAiMTIxMiIsCiAgICAgICAgICAidGlja2V0UHJpY2UiIDogIjM3LjUiLAogICAgICAgICAgInRyYWluU2VnbWVudCIgOiB7CiAgICAgICAgICAgICJzZWF0TnVtYmVyIiA6ICJYWOi9plhY5bqnIiwKICAgICAgICAgICAgInRyYWluTnVtIiA6ICIzMzM4IiwKICAgICAgICAgICAgInRyYWluSWQiIDogIjMzMzgiLAogICAgICAgICAgICAiZGVwU3RhdGlvbk5hbWUiIDogIuaIkOmDvSIsCiAgICAgICAgICAgICJkZXBTdGF0aW9uQ29kZSIgOiAiQ0RXIiwKICAgICAgICAgICAgImFyclN0YXRpb25OYW1lIiA6ICLovr7lt54iLAogICAgICAgICAgICAiYXJyU3RhdGlvbkNvZGUiIDogIlJYVyIsCiAgICAgICAgICAgICJhcnJUaW1lIiA6ICIyMDE5LTAxLTE5IDA4OjA3OjAwIiwKICAgICAgICAgICAgImRlcFRpbWUiIDogIjIwMTktMDEtMTkgMDM6NDI6MDAiLAogICAgICAgICAgICAiZHVyYXRpb25UaW1lIiA6ICIwNDoyNSIsCiAgICAgICAgICAgICJzZWF0R3JhZGVOYW1lIiA6ICLnoazluqciLAogICAgICAgICAgICAic2VhdEdyYWRlIiA6ICIxIgogICAgICAgICAgfSwKICAgICAgICAgICJzdGF0dXNDb2RlIiA6ICI5MiIsCiAgICAgICAgICAic2VhdEdyYWRlIiA6ICJPIiwKICAgICAgICAgICJleHRyYUZlZSIgOiAiMC4wIgogICAgICAgIH0KICAgICAgXSwKICAgICAgInJlZnVuZEZsYWciIDogIjEiCiAgICB9CiAgXQp9";
    NSDictionary * dict = [[a toDataForBase64] toDictionary];
    PYParseTest * t2 = [PYParseTest objectWithDictionary:dict];
    

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
