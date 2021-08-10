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


@interface ZLTLawModel : NSObject

kPNSNA NSString * ldi;//    String    2001/10/27 00:00:00
kPNSNA NSString * lato;//    String    中华人民共和国商标法(2001修正)第二十二条
kPNSNA NSString * lao;//    String    中华人民共和国商标法(2001修正)第二十二条:注册商标需要改变其标志的，应当重新提出注册申请。
kPNSNA NSString * lsd;//    String    1983/03/01 00:00:00
kPNSNA NSString * ltio;//    String    中华人民共和国商标法(2001修正)
kPNSNA NSString * cid;//   String    10048022001

kPNRNA NSString * locationPath;

@end

@implementation ZLTLawModel
@end

@interface AppDelegate ()
kPNSNA PYMotionNotification * motionNotify;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * str = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'/><style>img{max-width:100%; max-height:'auto';};</style></header><p>他沟沟壑壑回家</p><img style=\"display: block; width: 100%; height: 100%; margin-left: auto; margin-right: auto; object-fit: cover;\" src='http://qn.100csc.com/oabsw6as2cr' alt=\"\"   />";//[NSString stringWithContentsOfFile:@"/Users/wlpiaoyi/Documents/Source/iOS/PYUtile/Location.gpx" encoding:NSUTF8StringEncoding error:nil];
    PYXmlDocument * doc = [PYXmlDocument instanceWithXmlString:kFORMAT(@"<div>%@</div>", str)];
    _motionNotify = [PYMotionNotification new];
    [_motionNotify addListener:self];
    id obj = [ZLTLawModel objectWithDictionary:@{
        @"lato":@"中华人民共和国商标法(2019年修正)",
        @"locationPath":@"法律法规/商标/中华人民共和国商标法(2019年修正).docx",
    }];

    return YES;
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
