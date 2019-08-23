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

kPNA NSInteger pageIndex;//=DEFAULT_PAGE_INDEX;
kPNA NSInteger pageSize;//=DEFAULT_PAGE_SIZE;

@end

@implementation SMEBudgetListParam

-(instancetype) init{
    self = [super init];
    self.pageIndex = 1;
    self.pageSize = 20;
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    SMEBudgetListParam * param01 = [SMEBudgetListParam new];
//    param01.masterName = @"xxxx";
//    param01.pRect = CGRectMake(2, 2, 2, 2);
//    SMEBudgetListParam * param02 = [SMEBudgetListParam new];
//    [NSObject copyValueFromObj:param01 toObj:param02];
//
//    NSDate * date = [NSDate date];
//    NSDate * d1 = [date offsetSecond:-10];
//    NSDate * d2 = [date offsetSecond:-40];
//    NSDate * d3 = [date offsetSecond:-60 * 5];
//    NSDate * d4 = [date offsetHours:-3];
//    NSDate * d5 = [date offsetHours:-8];
//    NSDate * d6 = [date offsetDay:-1];
//    NSDate * d7 = [date offsetDay:-10];
//    NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",
//          [d1 dateTimeDescribe1],
//          [d2 dateTimeDescribe1],
//          [d3 dateTimeDescribe1],
//          [d4 dateTimeDescribe1],
//          [d5 dateTimeDescribe1],
//          [d6 dateTimeDescribe1],
//          [d7 dateTimeDescribe1]
//          );
//
//    date = [NSDate date];
//    d1 = [date offsetSecond:10];
//    d2 = [date offsetSecond:40];
//    d3 = [date offsetSecond:60 * 5];
//    d4 = [date offsetHours:3];
//    d5 = [date offsetHours:8];
//    d6 = [date offsetDay:1];
//    d7 = [date offsetDay:10];
//    NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",
//          [d1 dateTimeDescribe1],
//          [d2 dateTimeDescribe1],
//          [d3 dateTimeDescribe1],
//          [d4 dateTimeDescribe1],
//          [d5 dateTimeDescribe1],
//          [d6 dateTimeDescribe1],
//          [d7 dateTimeDescribe1]
//          );
//
//    NSString * data =  @"{\"\\u6e56\\u5317\\u7701\":[\"\\u9ec4\\u77f3\\u5e02\",\"\\u8944\\u9633\\u5e02\",\"\\u6b66\\u6c49\\u5e02\",\"\\u8346\\u95e8\\u5e02\",\"\\u54b8\\u5b81\\u5e02\",\"\\u8346\\u5dde\\u5e02\",\"\\u5929\\u95e8\\u5e02\",\"\\u9ec4\\u5188\\u5e02\"],\"\\u5c71\\u4e1c\\u7701\":[\"\\u6ee8\\u5dde\\u5e02\",\"\\u83b1\\u829c\\u5e02\",\"\\u5a01\\u6d77\\u5e02\",\"\\u6dc4\\u535a\\u5e02\",\"\\u6d4e\\u5357\\u5e02\",\"\\u6cf0\\u5b89\\u5e02\",\"\\u70df\\u53f0\\u5e02\",\"\\u67a3\\u5e84\\u5e02\",\"\\u6f4d\\u574a\\u5e02\",\"\\u6d4e\\u5b81\\u5e02\",\"\\u5fb7\\u5dde\\u5e02\"],\"\\u5c71\\u897f\\u7701\":[\"\\u664b\\u4e2d\\u5e02\"],\"\\u6d77\\u5357\\u7701\":[\"\\u6d77\\u53e3\\u5e02\"],\"\\u9655\\u897f\\u7701\":[\"\\u5b89\\u5eb7\\u5e02\",\"\\u5546\\u6d1b\\u5e02\",\"\\u897f\\u5b89\\u5e02\"],\"\\u8fbd\\u5b81\\u7701\":[\"\\u978d\\u5c71\\u5e02\",\"\\u76d8\\u9526\\u5e02\",\"\\u961c\\u65b0\\u5e02\",\"\\u4e39\\u4e1c\\u5e02\",\"\\u94c1\\u5cad\\u5e02\",\"\\u629a\\u987a\\u5e02\",\"\\u8fbd\\u9633\\u5e02\"],\"\\u6d59\\u6c5f\\u7701\":[\"\\u5609\\u5174\\u5e02\",\"\\u4e3d\\u6c34\\u5e02\",\"\\u6e29\\u5dde\\u5e02\",\"\\u5b81\\u6ce2\\u5e02\",\"\\u91d1\\u534e\\u5e02\",\"\\u821f\\u5c71\\u5e02\",\"\\u53f0\\u5dde\\u5e02\",\"\\u676d\\u5dde\\u5e02\",\"\\u8862\\u5dde\\u5e02\",\"\\u7ecd\\u5174\\u5e02\"],\"\\u4e91\\u5357\\u7701\":[\"\\u6606\\u660e\\u5e02\",\"\\u666e\\u6d31\\u5e02\",\"\\u66f2\\u9756\\u5e02\",\"\\u4fdd\\u5c71\\u5e02\",\"\\u5927\\u7406\\u5e02\",\"\\u4e3d\\u6c5f\\u5e02\",\"\\u9999\\u683c\\u91cc\\u62c9\\u5dde\",\"\\u695a\\u96c4\\u5e02\",\"\\u662d\\u901a\\u5e02\",\"\\u897f\\u53cc\\u7248\\u7eb3\\u5dde\",\"\\u6587\\u5c71\\u5dde\",\"\\u7ea2\\u6cb3\\u5e02\",\"\\u6012\\u6c5f\\u5e02\",\"\\u5fb7\\u5b8f\\u5e02\",\"\\u4e34\\u6ca7\\u5e02\",\"\\u7389\\u6eaa\\u5e02\"],\"\\u6cb3\\u5317\\u7701\":[\"\\u4fdd\\u5b9a\\u5e02\",\"\\u79e6\\u7687\\u5c9b\\u5e02\",\"\\u90a2\\u53f0\\u5e02\",\"\\u90af\\u90f8\\u5e02\",\"\\u5eca\\u574a\\u5e02\"],\"\\u6cb3\\u5357\\u7701\":[\"\\u5f00\\u5c01\\u5e02\",\"\\u6d1b\\u9633\\u5e02\",\"\\u4fe1\\u9633\\u5e02\",\"\\u4e09\\u95e8\\u5ce1\\u5e02\",\"\\u9a7b\\u9a6c\\u5e97\\u5e02\",\"\\u90d1\\u5dde\\u5e02\",\"\\u5e73\\u9876\\u5c71\\u5e02\",\"\\u7126\\u4f5c\\u5e02\",\"\\u6f2f\\u6cb3\\u5e02\",\"\\u6d4e\\u6e90\\u5e02\"],\"\\u6c5f\\u82cf\\u7701\":[\"\\u8fde\\u4e91\\u6e2f\\u5e02\",\"\\u6cf0\\u5dde\\u5e02\",\"\\u65e0\\u9521\\u5e02\",\"\\u82cf\\u5dde\\u5e02\",\"\\u5e38\\u5dde\\u5e02\",\"\\u9547\\u6c5f\\u5e02\",\"\\u6dee\\u5b89\\u5e02\",\"\\u5357\\u901a\\u5e02\",\"\\u626c\\u5dde\\u5e02\",\"\\u5f90\\u5dde\\u5e02\",\"\\u76d0\\u57ce\\u5e02\",\"\\u5bbf\\u8fc1\\u5e02\",\"\\u5357\\u4eac\\u5e02\"],\"\\u5b89\\u5fbd\\u7701\":[\"\\u5408\\u80a5\\u5e02\",\"\\u5ba3\\u57ce\\u5e02\",\"\\u5bbf\\u5dde\\u5e02\",\"\\u9ec4\\u5c71\\u5e02\",\"\\u94dc\\u9675\\u5e02\",\"\\u9a6c\\u978d\\u5c71\\u5e02\",\"\\u6c60\\u5dde\\u5e02\",\"\\u961c\\u9633\\u5e02\",\"\\u6dee\\u5357\\u5e02\",\"\\u829c\\u6e56\\u5e02\",\"\\u6ec1\\u5dde\\u5e02\",\"\\u868c\\u57e0\\u5e02\",\"\\u4eb3\\u5dde\\u5e02\"],\"\\u5e7f\\u897f\\u58ee\\u65cf\\u81ea\\u6cbb\\u533a\":[\"\\u6842\\u6797\\u5e02\",\"\\u67f3\\u5dde\\u5e02\",\"\\u5357\\u5b81\\u5e02\"],\"\\u5b81\\u590f\\u56de\\u65cf\\u81ea\\u6cbb\\u533a\":[\"\\u56fa\\u539f\\u5e02\"],\"\\u5409\\u6797\\u7701\":[\"\\u677e\\u539f\\u5e02\"],\"\\u5e7f\\u4e1c\\u7701\":[\"\\u73e0\\u6d77\\u5e02\",\"\\u60e0\\u5dde\\u5e02\",\"\\u63ed\\u9633\\u5e02\",\"\\u6c5f\\u95e8\\u5e02\",\"\\u6cb3\\u6e90\\u5e02\",\"\\u4e91\\u6d6e\\u5e02\",\"\\u8302\\u540d\\u5e02\",\"\\u4e2d\\u5c71\\u5e02\",\"\\u4f5b\\u5c71\\u5e02\",\"\\u6df1\\u5733\\u5e02\",\"\\u5e7f\\u5dde\\u5e02\",\"\\u6885\\u5dde\\u5e02\",\"\\u6e5b\\u6c5f\\u5e02\"],\"\\u53f0\\u6e7e\\u7701\":[\"\\u6d77\\u53e3\\u5e02\"],\"\\u5929\\u6d25\\u76f4\\u8f96\\u5e02\":[\"\\u5929\\u6d25\\u5e02\"],\"\\u798f\\u5efa\\u7701\":[\"\\u53a6\\u95e8\\u5e02\",\"\\u6f33\\u5dde\\u5e02\",\"\\u5bbf\\u5dde\\u5e02\",\"\\u66f2\\u9756\\u5e02\",\"\\u5b81\\u5fb7\\u5e02\",\"\\u4e09\\u660e\\u5e02\",\"\\u5357\\u5e73\\u5e02\",\"\\u8386\\u7530\\u5e02\",\"\\u9f99\\u5ca9\\u5e02\",\"\\u6cc9\\u5dde\\u5e02\"],\"\\u9752\\u6d77\\u7701\":[\"\\u897f\\u5b81\\u5e02\",\"\\u7261\\u4e39\\u6c5f\\u5e02\",\"\\u6d77\\u897f\\u5e02\"],\"\\u91cd\\u5e86\\u76f4\\u8f96\\u5e02\":[\"\\u91cd\\u5e86\\u5e02\"],\"\\u4e0a\\u6d77\\u76f4\\u8f96\\u5e02\":[\"\\u4e0a\\u6d77\\u5e02\"],\"\\u5317\\u4eac\\u76f4\\u8f96\\u5e02\":[\"\\u5317\\u4eac\\u5e02\"],\"\\u6e56\\u5357\\u7701\":[\"\\u6e58\\u6f6d\\u5e02\",\"\\u76ca\\u9633\\u5e02\",\"\\u90f4\\u5dde\\u5e02\",\"\\u5e38\\u5fb7\\u5e02\",\"\\u8861\\u9633\\u5e02\",\"\\u5a04\\u5e95\\u5e02\",\"\\u90b5\\u9633\\u5e02\"],\"\\u9ed1\\u9f99\\u6c5f\\u7701\":[\"\\u4f73\\u6728\\u65af\\u5e02\",\"\\u7261\\u4e39\\u6c5f\\u5e02\"],\"\\u6c5f\\u897f\\u7701\":[\"\\u8d63\\u5dde\\u5e02\",\"\\u5357\\u660c\\u5e02\",\"\\u666f\\u5fb7\\u9547\\u5e02\",\"\\u629a\\u5dde\\u5e02\"],\"\\u56db\\u5ddd\\u7701\":[\"\\u5fb7\\u9633\\u5e02\",\"\\u81ea\\u8d21\\u5e02\",\"\\u7709\\u5c71\\u5e02\",\"\\u96c5\\u5b89\\u5e02\",\"\\u8d44\\u9633\\u5e02\",\"\\u6cf8\\u5dde\\u5e02\",\"\\u6210\\u90fd\\u5e02\",\"\\u7ef5\\u9633\\u5e02\",\"\\u8fbe\\u5dde\\u5e02\",\"\\u5357\\u5145\\u5e02\"],\"\\u5185\\u8499\\u53e4\\u81ea\\u6cbb\\u533a\":[\"\\u9102\\u5c14\\u591a\\u65af\\u5e02\",\"\\u547c\\u548c\\u6d69\\u7279\\u5e02\",\"\\u4e4c\\u6d77\\u5e02\"]}";
//    NSArray * bbb = @[@{@"a":@"b"}];
//
//    float ft1 =  [@"abcdef" likePercentForCompare:@"abcdef"];
//    float ft2 =  [@"abcdef" likePercentForCompare:@"abcde"];
//    float ft3 =  [@"dabcdef" likePercentForCompare:@"abcdef"];
//    [NSObject dictionaryAnalysisForClass:@{@"bb":@"adfa",@"aa":[NSNull null]}];
//    NSLog(@"%ld %ld", [@"0xabcdef48733" toInteger] ,0xabcdef48733);
//    NSLog(@"%ld %ld", [@"0b100100101111" toInteger] ,0b100100101111);
//
//    NSLog(@"%@", [@"1999-08-08" dateFormateString:nil]);
//    NSLog(@"%@", [@"1999-08-08 02:02" dateFormateString:nil]);
//    NSLog(@"%@", [@"1999-08-08 02:02:02" dateFormateString:nil]);
//
//    [@"2001-01-10 08" dateFormateString:@"yyyy-MM-dd HH"];
////    [dft dateFromString:@];
//    NSTimeInterval timer = [NSDate timeIntervalSinceReferenceDate];
//    for (int i = 0; i<100; i++) {
//        PYParseTest * t = [PYParseTest new];
//        t.keyNewVar = 2;
//        t->ivarInt = 2;
//        t->ivarRect = CGRectMake(2, 3, 4, 5);
//        t->ivarString = @"adfasdfafasdf";
//        t.date = [NSDate date];
//        t.keyId = 3;
//        t.pRect = CGRectMake(4, 5, 6, 7);
//        t.keyDescription = @"adfaf";
//        NSDictionary * dict = [t objectToDictionary];
//        t.pTest = [PYParseTest objectWithDictionary:dict];
//        dict = [t objectToDictionary];
//        t.pTests = @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]];
//        dict = [t objectToDictionary];
//        t.pTestss = @[
//                      @[@[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]], @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]]],
//                      @[[PYParseTest objectWithDictionary:dict], [PYParseTest objectWithDictionary:dict]]
//                      ];
//        dict = [t objectToDictionary];
//        t = [PYParseTest objectWithDictionary:dict];
//        PYParseTest * t2 = [PYParseTest new];
//        [PYParseTest copyValueFromObj:t toObj:t2];
//        t2 = [t deepCopyObject];
//        id copyArray = [t2.pTests deepCopyObject];
//        copyArray = [t2.pTestss deepCopyObject];
//        NSLog(@"");
//    }
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
