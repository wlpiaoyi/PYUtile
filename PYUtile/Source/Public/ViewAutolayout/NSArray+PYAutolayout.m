//
//  NSArray+PYAutolayout.m
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/5.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "NSArray+PYAutolayout.h"
#import "PYUtile.h"

@interface PYConstraint()

kPNAR CGFloat value;
kPNAR BOOL isSafe;
kPNRNA UIView * toItem;
kPNAR BOOL isReversal;

@end

@implementation NSArray(PYAutolayout)

- (nullable NSArray<NSLayoutConstraint *> *) py_makeConstraints:(void(NS_NOESCAPE ^)(PYConstraintMaker *make))block{
    if(!block) return nil;
    PYConstraintMaker *make = [PYConstraintMaker new];
    block(make);
    [make setValue:@(YES) forKey:@"isInstall"];
    if(self.count < 2) return nil;
    for (UIView * view in self) {
        if(![view isKindOfClass:[UIView class]]){
            kPrintErrorln("has class [%s] is not UIView class", NSStringFromClass([view class]));
            continue;
        }
        if(view.superview == nil){
            kPrintErrorln("%s", "has view.superview is nil");
            continue;
        }
//        if(view == self.firstObject){
//            if(make.top)
//        }else if(view == self.lastObject){
//
//        }else{
//
//        }
    }
    return nil;
}

@end
