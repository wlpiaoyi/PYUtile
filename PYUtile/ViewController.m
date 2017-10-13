//
//  ViewController.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "UIResponder+Hook.h"
#import "PYGraphicsDraw.h"
#import "UIView+Expand.h"
#import "PYKeyboardNotification.h"
#import "NSNumber+Expand.h"
#import "pyutilea.h"
@interface Dview2 : UIView

@end
@implementation Dview2
-(void) layoutSubviews{
    [super layoutSubviews];
    
    if(self.bounds.size.height > 0){NSString
        *pngPath
        =
        [NSHomeDirectory()
            stringByAppendingPathComponent:@"Documents/Test.png"];
          [UIImagePNGRepresentation([self drawView])
           writeToFile:pngPath atomically:YES];
    }
}

@end

@interface Dview : UIView

@end
@implementation Dview

-(void) drawRect:(CGRect)rect{
    [PYGraphicsDraw drawLinearGradientWithContext:nil colorValues : (CGFloat[]){
        0.0f, 0.0f, 0.0f, 0.8f,
        0.5f, 0.5f, 0.5f, 0.1f}
                                          alphas : (CGFloat[]){
                                              20.0f/rect.size.height,
                                              1.0f}
                                          length : 2 startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, rect.size.height)];
}

@end

@interface ViewController ()
//@property (weak, nonatomic) IBOutlet UITextField *search;
//@property (nonatomic) UIView * aView;

@property int a;
@property NSString * b;
@property ViewController * vc;
@property NSArray * vcs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.a = 2;
    self.b = @"adfadf";
    id obj = [[UIApplication sharedApplication].keyWindow objectToDictionary];
    ViewController * vc = [ViewController objectWithDictionary:obj];
    self.vc = vc;
    self.vcs = @[[ViewController new]];
    obj = [self objectToDictionary];
    vc = [ViewController objectWithDictionary:obj];
    
//    self.aView = self.view;
//    NSNumber * n = @(22.4);
//    NSString * a = [n stringValueWithPrecision:2];
//    [UIResponder hookWithMethodNames:nil];
//    [PYKeyboardNotification setKeyboardNotificationShowWithResponder:self.search begin:^(UIResponder * _Nonnull responder) {
//        NSLog(@"=====>");
//    } doing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
//        
//    } end:^(UIResponder * _Nonnull responder) {
//        
//    }];
//    [PYKeyboardNotification setKeyboardNotificationHiddenWithResponder:self.search begin:^(UIResponder * _Nonnull responder) {
//        NSLog(@"=====>");
//    } doing:^(UIResponder * _Nonnull responder, CGRect keyBoardFrame) {
//        
//    } end:nil];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary * obj =  [((NSObject *)[UIApplication sharedApplication].delegate) objectToDictionary];
//    UIWindow * windwos =  [UIWindow objectWithDictionary:obj];
    NSString * value = [[obj toData] toString];
    value = value;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
