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

@interface Test1:NSObject<UITextFieldDelegate>
@property (nonatomic, copy) void (^block) (int i);
@property (nonatomic) SEL action;
@property (nonatomic, assign) CGSize s;
@property (nonatomic, assign) PYEdgeInsetsItem e;
@property (nonatomic, strong) Test1 * t;
@property (nonatomic, strong) NSArray<Test1 *> * ts;
@property (nonatomic, strong) Test1 * property_ts;
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

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSString * value = @"{\"T\":{\"S1\":{\"MinStay\":[[\"\",\"无限制\"]],\"MaxStay\":[[\"\",\"无限制。\"]],\"Penalties\":[[\"Cancel/Refund\",\"允许，收取手续费500人民币。\"],[\"Change\",\"允许。\"],[\"Noshow\",\"退票：收取手续费500人民币。\n\n更改：不允许。\"]],\"ResultData\":[[\"\",\"最短停留:\n无限制\n\n最长停留:\n无限制。\n\n退改规定:\n1.退票:\n允许，收取手续费500人民币。\n2.更改:允许。\n3.误机:退票：收取手续费500人民币。更改：不允许。\r\n\n\n\"]]}}}";
////    value = @"{\"ResultData\":[[\"\",\"最短停留:\n无限制 最长停留:无限制\"]]}";
//    value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
//    [[value toData] toDictionary];
//    NSMutableString * xmlString = [NSMutableString new];
//    [xmlString appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"];
//    [xmlString appendString:@"<string xmlns=\"http://tempuri.org/\">\n"];
//    [xmlString appendString:@"<item a=\"b\">2</item>\n"];
//    [xmlString appendString:@"<item a=\"b\">2</item>\n"];
//    [xmlString appendString:@"</string>"];
//    [xmlString appendString:@"</string>"];
    
//    PYXml * xml = [PYXml instanceWithXmlString:xmlString];
//    
//    [UITextField hookWithMethodNames:nil];
//    [Test2 hookMethodWithName:@"textFieldShouldEndEditing:"];
//    [Test3 new];
    Test1 * t1 = [Test1 new];
    
//    [t1 setBlock:^(int i){
//        NSLog(@"aa");
//    }];
    t1.s = CGSizeMake(3, 3);
    t1.t = [Test1 new];
    t1.ts = @[t1.t];
    PYEdgeInsetsItem e= PYEdgeInsetsItemNull();
    e.top = (__bridge void *)t1;
    t1.e = e;
    t1.t.s = CGSizeMake(3, 4);
    t1.t.e = PYEdgeInsetsItemNull();
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
