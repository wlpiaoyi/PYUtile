//
//  ViewController.m
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/5.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "pyutilea.h"
#import "UIView+PYAutolayout.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIImageView * imageView = [self.view viewWithTag:186003];
//    imageView.image = [UIImage createQRCodeImageWithString:@"xxxx" withSize:100];
//    self.navigationController.navigationBar.hidden = NO;
//    self.title = @"adfad";
//    UIView * view = [UIView new];
//    [view setCornerRadiusAndBorder:1 borderWidth:1 borderColor:[UIColor systemRedColor]];
//    [self.view addSubview:view];
//    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero controller:self];
////    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
////    eii.top = (__bridge void * _Nullable)(self.topLayoutGuide);
////    eii.bottom = (__bridge void * _Nullable)(self.bottomLayoutGuide);
////    eii.topActive = true;
////    eii.bottomActive = true;
////    [PYViewAutolayoutCenter persistConstraint:view relationmargins:UIEdgeInsetsZero relationToItems:eii];
    
    UIView * subView = [UIView new];
    subView.backgroundColor = [UIColor redColor];
    [self.view addSubview:subView];
    __block NSArray * obj;
    obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
    make.top.bottom.py_inSafe(YES).py_constant(10).left.right.py_constant(10);
        NSLog(@"11");
    }];
    threadJoinGlobal(^{
        
        [NSThread sleepForTimeInterval:2];
        threadJoinMain(^{
            [UIView animateWithDuration:.2 animations:^{
                [subView py_removeAllLayoutContarint];
                UIView * item = [self.view viewWithTag:1860022];
                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.top.left.bottom.right.py_toReversal(YES).py_toItem(item).py_constant(0);
                }];
                [self.view layoutIfNeeded];
            }];
            NSLog(@"11");
        });
        
        [NSThread sleepForTimeInterval:2];
        threadJoinMain(^{
            [UIView animateWithDuration:.2 animations:^{
                [subView py_removeAllLayoutContarint];
                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.width.height.py_constant(100).centerX.centerY.py_constant(0);
                }];
                [self.view layoutIfNeeded];
            }];
        });
        [NSThread sleepForTimeInterval:2];
        threadJoinMain(^{
            [UIView animateWithDuration:.2 animations:^{
                UIView * item = [self.view viewWithTag:1860022];
                [subView py_removeAllLayoutContarint];
                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.width.height.py_toItem(item).py_constant(-20).centerX.centerY.py_toItem(item).py_constant(0);
                }];
                [self.view layoutIfNeeded];
            }];
            NSLog(@"11");
        });
        [NSThread sleepForTimeInterval:2];
        threadJoinMain(^{
            [UIView animateWithDuration:.2 animations:^{
                UIView * item = [self.view viewWithTag:1860022];
                [subView py_removeAllLayoutContarint];
                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.width.height.py_toItem(item).py_constant(0).centerX.centerY.py_constant(0);
                }];
                [self.view layoutIfNeeded];
            }];
            NSLog(@"11");
        });
        [NSThread sleepForTimeInterval:2];
        threadJoinMain(^{
            [UIView animateWithDuration:.2 animations:^{
                [subView py_removeAllLayoutContarint];
                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
                    make.top.left.bottom.right.py_inSafe(YES).py_constant(30);
                }];
                [self.view layoutIfNeeded];
            }];
            NSLog(@"11");
        });
    });
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
