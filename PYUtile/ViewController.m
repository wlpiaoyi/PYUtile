//
//  ViewController.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "pyutilea.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView = [self.view viewWithTag:186003];
    imageView.image = [UIImage createQRCodeImageWithString:@"xxxx" withSize:100];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"adfad";
    UIView * view = [UIView new];
    [view setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor systemRedColor]];
    [self.view addSubview:view];
    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero controller:self];
//    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
//    eii.top = (__bridge void * _Nullable)(self.topLayoutGuide);
//    eii.bottom = (__bridge void * _Nullable)(self.bottomLayoutGuide);
//    eii.topActive = true;
//    eii.bottomActive = true;
//    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero relationToItems:eii];
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
