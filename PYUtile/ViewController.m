//
//  ViewController.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
//#import "pyutilea.h"
#import "UIView+PYLayoutGetSet.h"
#import "UIView+PYExpand.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcTralling;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcBottom;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView * view = [self.view viewWithTag:186001];
    UIView * view2 = [self.view viewWithTag:186002];
    UIView * view3 = [self.view viewWithTag:186003];
    UIView * view4 = [self.view viewWithTag:186004];
    UIView * view5 = [self.view viewWithTag:186005];
    [view setCornerRadiusAndBorder:1 borderWidth:5 borderColor:[UIColor grayColor]];
    [view2 setCornerRadiusAndBorder:1 borderWidth:5 borderColor:[UIColor greenColor]];
    [view3 setCornerRadiusAndBorder:1 borderWidth:5 borderColor:[UIColor yellowColor]];
    [view4 setCornerRadiusAndBorder:1 borderWidth:5 borderColor:[UIColor blueColor]];
    [view5 setCornerRadiusAndBorder:1 borderWidth:5 borderColor:[UIColor orangeColor]];
    NSArray<__kindof NSLayoutConstraint *> *constraints;
    
    id top = view.py_layoutTopSafe;
    id left = view.py_layoutLeadingSafe;
    id bottom = view.py_layoutBottomSafe;
    id rigt = view.py_layoutTrailingSafe;
    NSLog(@"======================>\n%@,\n%@,\n%@,\n%@", top, left,bottom, rigt);
    
    top = view2.py_layoutTop;
    left = view2.py_layoutLeading;
    bottom = view2.py_layoutBottom;
    rigt = view2.py_layoutTrailing;
    NSLog(@"======================>\n%@,\n%@,\n%@,\n%@", top, left,bottom, rigt);
    
    id width = view3.py_layoutWidth;
    id height = view3.py_layoutHeight;
    id centerX = view3.py_layoutCenterX;
    id centerY = view3.py_layoutCenterY;
    NSLog(@"======================>\n%@,\n%@,\n%@,\n%@", width, height, centerX, centerY);
    
    width = view4.py_layoutEqulesWidth;
    height = view4.py_layoutEqulesHeight;
    NSLog(@"======================>\n%@,\n%@", width, height);
    
    id aspect = view5.py_layoutAspect;
    NSLog(@"======================>\n%@",aspect);
    
    
    constraints = [view py_removeAllLayout];
    NSLog(@"======================>\n%@", constraints);
    constraints = [view2 py_removeAllLayout];
    NSLog(@"======================>\n%@", constraints);
    constraints = [view3 py_removeAllLayout];
    NSLog(@"======================>\n%@", constraints);
    constraints = [view4 py_removeAllLayout];
    NSLog(@"======================>\n%@", constraints);
    constraints = [view5 py_removeAllLayout];
    NSLog(@"======================>\n%@", constraints);
    
    NSLog(@"");
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
