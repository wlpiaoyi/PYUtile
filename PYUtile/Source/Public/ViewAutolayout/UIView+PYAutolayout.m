//
//  UIView+UIView_PYAutolayoutSet.m
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/4.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "UIView+PYAutolayout.h"
#import "PYViewAutolayoutCenter.h"
#import "UIView+NoUse.h"


@interface PYConstraint()

kPNRNA UIView * toItem;
kPNAR CGFloat value;
kPNAR BOOL isSafe;
kPNAR BOOL isReversal;
kPNA BOOL isInstall;

kPNA PYConstraintMaker * maker;

@end


@implementation UIView (PYAutolayout)

- (nullable NSArray<NSLayoutConstraint *> *) py_makeConstraints:(void(NS_NOESCAPE ^)(PYConstraintMaker *make))block{
    if(!block) return nil;
    PYConstraintMaker * make = [PYConstraintMaker new];
    block(make);
    [make setValue:@(YES) forKey:@"isInstall"];
    if(make.width){
        if(make.width.toItem && [make.width.toItem isKindOfClass:[UIView class]]){
            [self py_setAutolayoutEqulesWidth:make.width.value toItem:make.width.toItem];
        }else{
            [self py_setAutolayoutWidth:make.width.value];
        }
    }
    if(make.height){
        if(make.height.toItem && [make.height.toItem isKindOfClass:[UIView class]]){
            [self py_setAutolayoutEqulesHeight:make.height.value toItem:make.height.toItem];
        }else{
            [self py_setAutolayoutHeight:make.height.value];
        }
    }
    if(make.centerX){
        PYConstraint * constraint = make.centerX;
        [self py_setAutolayoutCenterX:constraint.value toItem:constraint.toItem];
    }
    if(make.centerY){
        PYConstraint * constraint = make.centerY;
        [self py_setAutolayoutCenterY:constraint.value toItem:constraint.toItem];
    }
    
    if(make.top){
        PYConstraint * constraint = make.top;
        [self py_setAutolayoutRelationTop:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe isReverse:constraint.isReversal];
    }
    if(make.bottom){
        PYConstraint * constraint = make.bottom;
        [self py_setAutolayoutRelationBottom:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe isReverse:constraint.isReversal];
    }
    if(make.left){
        PYConstraint * constraint = make.left;
        [self py_setAutolayoutRelationLeft:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe isReverse:constraint.isReversal];
    }
    if(make.right){
        PYConstraint * constraint = make.right;
        [self py_setAutolayoutRelationRight:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe isReverse:constraint.isReversal];
    }
    return [self py_getAllLayoutContarint];
}

@end

