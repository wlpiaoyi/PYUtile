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
    UIView * view = [self.view viewWithTag:186332];
    [view py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.width.py_constant(100);
    }];
    NSLayoutConstraint * lcw  = view.py_getAutolayoutWidth;
    NSLayoutConstraint * lcH  = view.py_getAutolayoutHeight;
    NSLog(@"");
//    NSArray<NSLayoutConstraint *> * lcs =[[self.view viewWithTag:186333] py_getAllLayoutContarint];
//    
//    NSLayoutConstraint * lc1 = [[self.view viewWithTag:186333] py_getAutolayoutRelationTop];
//    NSLayoutConstraint * lc3 = [[self.view viewWithTag:186333] py_getAutolayoutRelationBottom];
//    
//    UIView * subView = [UIView new];
//    subView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:subView];
//    __block NSArray * obj;
//    obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
////        make.left.right.py_inSafe(NO).py_constant(0);
//        make.bottom.py_inArea(NO).py_constant(-20);
////        make.height.py_constant(56);
//        NSLog(@"11");
//    }];
//    threadJoinGlobal(^{
//        [NSThread sleepForTimeInterval:2];
//        
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                [subView py_removeAllLayoutContarint];
//                UIView * item = [self.view viewWithTag:1860022];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.top.left.bottom.right.py_inArea(YES).py_constant(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//            NSLog(@"11");
//        });
//        [NSThread sleepForTimeInterval:2];
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                [subView py_removeAllLayoutContarint];
//                UIView * item = [self.view viewWithTag:1860022];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.top.left.bottom.right.py_toReversal(YES).py_toItem(item).py_constant(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//            NSLog(@"11");
//        });
//        
//        [NSThread sleepForTimeInterval:2];
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                [subView py_removeAllLayoutContarint];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.width.height.py_constant(100).centerX.centerY.py_constant(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//        });
//        [NSThread sleepForTimeInterval:2];
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                UIView * item = [self.view viewWithTag:1860022];
//                [subView py_removeAllLayoutContarint];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.width.height.py_toItem(item).py_constant(-20).centerX.centerY.py_toItem(item).py_constant(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//            NSLog(@"11");
//        });
//        [NSThread sleepForTimeInterval:2];
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                UIView * item = [self.view viewWithTag:1860022];
//                [subView py_removeAllLayoutContarint];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.width.height.py_toItem(item).py_constant(0).centerX.centerY.py_constant(0);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//            NSLog(@"11");
//        });
//        [NSThread sleepForTimeInterval:2];
//        threadJoinMain(^{
//            [UIView animateWithDuration:.2 animations:^{
//                [subView py_removeAllLayoutContarint];
//                obj = [subView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
//                    make.top.left.bottom.right.py_inArea(YES).py_constant(30);
//                }];
//                [self.view layoutIfNeeded];
//            }];
//            NSLog(@"11");
//        });
//    });
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
