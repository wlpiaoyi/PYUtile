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
SINGLETON_SYNTHESIZE_FOR_hCLASS(PyTest, NSObject, <NSObject>);
@end
SINGLETON_SYNTHESIZE_FOR_mCLASS(PyTest){
    
}
@end

@interface Test1:NSObject<UITextFieldDelegate>{
@public int _pvalue0;
}
@property (nonatomic, copy) void (^block) (int i);
@property (nonatomic) SEL action;
@property (nonatomic, assign) CGSize value0;
@property (nonatomic, strong) NSArray * value1;
@property (nonatomic, strong) NSDate * value2;
@property (nonatomic, retain) NSData * value3;
@property (nonatomic, retain) NSDictionary * value4;
@property (nonatomic, strong) NSURL * url;
@property (nonatomic, strong) Test1 * t1;
@end
@implementation Test1
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return false;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (BOOL)exchangeTextFieldShouldEndEditing:(UITextField *)textField{
    [self exchangeTextFieldShouldEndEditing:textField];
    return YES;
}
@end
@interface Test2:Test1

@end
@implementation Test2
@end
@interface Test3:NSObject
@end
@implementation Test3
//-(void) dealloc{
//}
@end

NSTimer * timer;
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PYUUID(1024);
    BOOL falg = [NSString matchArg:@"picssdkidu]" regex:@"^(pics{1} ([a-zA-Z0-9_\\.\\-])+)$"];
    NSLog(kFORMAT(@"当前手机型号:%@", [PYUtile getDeviceInfo]));
    NSString * bankCard = @"6225768615095997";
    [bankCard matchBankNumber];
    Test1 * t1 = [Test1 new];
    t1.block = ^(int i) {
        
    };
    t1.action = @selector(appendString:);
    t1.value0 = CGSizeMake(20, 20);
    t1.value1 = [NSArray arrayWithObjects:[Test1 new], @"adfa",nil];
    t1.value2 = [NSDate date];
    t1.value3 = [@"adfadsf" toData];
    t1->_pvalue0 = 4;
    t1.url = [NSURL URLWithString:@"http://www.baidu.com"];
    Test1 * t2 = [Test1 new];
    t1.value4 = @{@"key333":[Test1 new], @"key2":@"ddd"};
    t2.action = @selector(appendString:);
    t2.value0 = CGSizeMake(20, 20);
    t2.value1 = nil;
    t2.value2 = [NSDate date];
    t2.value3 = [@"adfadsf" toData];
    t1.t1 = t2;
    NSDictionary * json = @{@"a" : @"a", @"b" : t1};
    json = [json objectToDictionary];
    json = [[json toData] toDictionary];
    t2 = [Test1 objectWithDictionary:json[@"b"]];
    NSArray * datas =  [PYInvoke getInstanceMethodInfosWithClass:[UIApplication sharedApplication].class];
    datas = datas;
    PyTest * py = [PyTest sharedPyTest];
    py = py;
//    NSString * value = @"{\"T\":{\"S1\":{\"MinStay\":[[\"\",\"无限制\"]],\"MaxStay\":[[\"\",\"无限制。\"]],\"Penalties\":[[\"Cancel/Refund\",\"允许，收取手续费500人民币。\"],[\"Change\",\"允许。\"],[\"Noshow\",\"退票：收取手续费500人民币。\n\n更改：不允许。\"]],\"ResultData\":[[\"\",\"最短停留:\n无限制\n\n最长停留:\n无限制。\n\n退改规定:\n1.退票:\n允许，收取手续费500人民币。\n2.更改:允许。\n3.误机:退票：收取手续费500人民币。更改：不允许。\r\n\n\n\"]]}}}";
////    value = @"{\"ResultData\":[[\"\",\"最短停留:\n无限制 最长停留:无限制\"]]}";
//    value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//    [[value toData] toDictionary];
    NSMutableString * xmlString = [NSMutableString new];
    [xmlString appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"];
    [xmlString appendString:@"\t<string xmlns=\"http://tempuri.org/\">\n"];
    [xmlString appendString:@"\t\t<item1 a=\"b\">\n"];
    [xmlString appendString:@"\t\t\t<item2_c0 a=\"b\">sldk<![CDATA[SomeText]]></item2_c0>\n"];
    [xmlString appendString:@"\t\t</item1>\n"];
    [xmlString appendString:@"\t\t<item1 a=\"b\">2</item1>\n"];
    [xmlString appendString:@"\t</string>\n"];
    [xmlString appendString:@"</xml>"];
    /**
    <?xml version="1.0" encoding="utf-8"?>
         <string xmlns="http://tempuri.org/">
             <item1 a="b">
                 <item2_c0 a="b">sldk<![CDATA[SomeText]]></item2_c0>
             </item1>
         <item1 a="b">2</item1>
         </string>
     </xml>*/
    NSError * error;
//    xmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.w3school.com.cn/example/xmle/simple.xml"] encoding:NSUTF8StringEncoding error:&error];
    PYXmlDocument * xml = [PYXmlDocument instanceWithXmlString:xmlString];
//    xml = [PYXmlDocument instanceWithXmlString:[xml stringValue]];
    xml = xml;
//
//    [UITextField hookWithMethodNames:nil];
//    [Test2 hookMethodWithName:@"textFieldShouldEndEditing:"];
//    [Test3 new];
    
//     timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
//         NSLog(@"");
//    }];
//    [timer invalidate];
    
    
//    [t1 setBlock:^(int i){
//        NSLog(@"aa");
//    }];
//    NSDictionary * obj = (NSDictionary *)[self objectToDictionary];
//    t1 = [NSObject objectWithDictionary:obj clazz:self.class];
    
//    t1.block(2);
    [PYUtile class];
    NSData * data = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/1.html", bundleDir]];
    NSString * arg = [data toBase64String];
//    arg = [[NSString alloc] initWithData:[arg toDataFromBase64] encoding:NSUTF8StringEncoding];
//    NSMutableDictionary * dict = [NSMutableDictionary new];
//    [dict setWeakValue:self forKey:@"a"];
//    typeof(self) s = [dict weakValueForKey:@"a"];
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
