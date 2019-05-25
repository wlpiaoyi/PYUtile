//
//  ViewAutolayoutCenter.m
//  Common
//
//  Created by wlpiaoyi on 15/1/5.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "PYViewAutolayoutCenter.h"
#import "UIView+Expand.h"


const CGFloat DisableConstrainsValueMAX = CGFLOAT_MAX - 1;
const CGFloat DisableConstrainsValueMIN  = -DisableConstrainsValueMAX;
const NSString * PYAtltSuperTop = @"superTop";
const NSString * PYAtltSuperBottom = @"superBottom";
const NSString * PYAtltSuperLeft = @"superLeft";
const NSString * PYAtltSuperRight = @"superRight";
const NSString * PYAtltSelfWith = @"selfWith";
const NSString * PYAtltSelfHeight = @"selfHeight";
const NSString * PYAtltSelfCenterX = @"selfCenterX";
const NSString * PYAtltSelfCenterY = @"selfCenterY";
const NSString * PYAtltEquelsWidth = @"equelsWidth";
const NSString * PYAtltEquelsHeight = @"equelsHeight";

@implementation PYViewAutolayoutCenter

/**
 新增关系约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
    if ([self isValueEnable:margins.top]) {
        UIView *superView = toItems.top ? (__bridge UIView *)(toItems.top) : nil;
        NSLayoutAttribute superAtt = NSLayoutAttributeBottom;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeTop;
        }
        NSLayoutConstraint * marginsTop = nil;
        if (toItems.topActive && superView == [subView superview]){
            if (@available(iOS 11.0, *)) {
                marginsTop =[subView.topAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.topAnchor constant:margins.top];
                marginsTop.active = true;
            }
        }
        if(!marginsTop){
          marginsTop = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:margins.top];
            [[subView superview] addConstraint:marginsTop];
        }
        dictResult[PYAtltSuperTop] = marginsTop;
    }
    if ([self isValueEnable:margins.bottom]) {
        UIView *superView = toItems.bottom ? (__bridge UIView *)(toItems.bottom) : nil;
        NSLayoutAttribute superAtt = NSLayoutAttributeTop;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeBottom;
        }
        NSLayoutConstraint * marginsBottom = nil;
        if (toItems.bottomActive && superView == [subView superview]){
            if (@available(iOS 11.0, *)) {
                marginsBottom =[subView.bottomAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.bottomAnchor constant:-margins.bottom];
                marginsBottom.active = true;
            }
        }
        if(!marginsBottom){
             marginsBottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:-margins.bottom];
            [[subView superview] addConstraint:marginsBottom];
        }

        dictResult[PYAtltSuperBottom] = marginsBottom;
    }
    if ([self isValueEnable:margins.left]) {
        UIView *superView = toItems.left ? (__bridge UIView *)(toItems.left) : nil;
        NSLayoutAttribute superAtt = NSLayoutAttributeRight;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeLeft;
        }
        NSLayoutConstraint *marginsLeft = nil;
        if (toItems.leftActive && superView == [subView superview]){
            if (@available(iOS 11.0, *)) {
                marginsLeft = [subView.leftAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.leftAnchor constant:margins.left];
                marginsLeft.active = true;
            }
        }
        if(!marginsLeft){
             marginsLeft = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:margins.left];
            [[subView superview] addConstraint:marginsLeft];
        }
        dictResult[PYAtltSuperLeft] = marginsLeft;
    }
    if ([self isValueEnable:margins.right]) {
        UIView *superView = toItems.right ? (__bridge UIView *)(toItems.right) : nil;
        NSLayoutAttribute superAtt = NSLayoutAttributeLeft;
        if (!superView) {
            superView = [subView superview];
            superAtt = NSLayoutAttributeRight;
        }
        NSLayoutConstraint *marginsRight = nil;
        if (toItems.rightActive && superView == [subView superview]){
            if (@available(iOS 11.0, *)) {
                marginsRight = [subView.rightAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.rightAnchor constant:-margins.right];
                marginsRight.active = true;
            }
        }
        if(!marginsRight){
            marginsRight = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:superAtt multiplier:1 constant:-margins.right];
            [[subView superview] addConstraint:marginsRight];
        }

        dictResult[PYAtltSuperRight] = marginsRight;
    }
    return dictResult;
}

/**
 新增大小约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView size:(CGSize) size{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
    
    if ([self isValueEnable:size.width]) {
        NSLayoutConstraint *sizeWith = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.width];
        [subView addConstraint:sizeWith];
        
        dictResult[PYAtltSelfWith] = sizeWith;
    }
    if ([self isValueEnable:size.height]) {
        NSLayoutConstraint *sizeHeight= [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:size.height];
        [subView addConstraint:sizeHeight];
        
        dictResult[PYAtltSelfHeight] = sizeHeight;
    }
    
    return dictResult;
}
/*
 新增布局约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView centerPointer:(CGPoint) pointer{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *superView = [subView superview];
    NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
    
    if ([self isValueEnable:pointer.x]) {
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:pointer.x];
        [superView addConstraint:centerX];
        
        dictResult[PYAtltSelfCenterX] = centerX;
    }
    if ([self isValueEnable:pointer.y]) {
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:pointer.y];
        [superView addConstraint:centerY];
        
        dictResult[PYAtltSelfCenterY] = centerY;
    }

    return dictResult;
}

/**
 等宽约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsWithForView:(nonnull UIView *) view target:(nonnull UIView *) target{
    return [self persistEqualsWithForView:view target:target multiplier:1 constant:0];
}
/**
 等宽约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsWithForView:(nonnull UIView *) view target:(nonnull UIView *) target multiplier:(CGFloat) multiplier constant:(CGFloat) constant{
    NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:target attribute:NSLayoutAttributeWidth multiplier:multiplier constant:constant];
    [view.superview addConstraint:equalsConstraint];
    return @{PYAtltEquelsWidth: equalsConstraint};
}

/**
 等高约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsHeightForView:(nonnull UIView *) view target:(nonnull UIView *) target{
    return [self persistEqualsHeightForView:view target:target multiplier:1 constant:0];
}

/**
 等高约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsHeightForView:(nonnull UIView *) view target:(nonnull UIView *) target multiplier:(CGFloat) multiplier constant:(CGFloat) constant{
    NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:target attribute:NSLayoutAttributeWidth multiplier:multiplier constant:constant];
    [view.superview addConstraint:equalsConstraint];
    return @{PYAtltEquelsWidth: equalsConstraint};
}

/**
 横向等比约束
 */
+(nonnull NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> *) persistConstraintHorizontal:(nonnull NSArray<UIView *> *)subViews relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems offset:(CGFloat) offset{
    
    NSMutableArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * arrayResult = [NSMutableArray new];
    
    NSUInteger index = 0;
    for (UIView *subView in subViews) {
        
        NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
        
        PYEdgeInsetsItem _toItems = toItems;
        UIEdgeInsets _margins = margins;
        
        if (index == 0) {
            _toItems.right = nil;
            _margins.right = DisableConstrainsValueMAX;
        }else if(index == [subViews count] - 1){
            _toItems.left = (__bridge void * _Nullable)(subViews[index - 1]);
            _margins.left = offset;
            _toItems.right = nil;
        }else{
            _toItems.left = (__bridge void * _Nullable)(subViews[index - 1]);
            _margins.left = offset;
            _toItems.right = nil;
            _margins.right = DisableConstrainsValueMAX;//offset;
        }
        [dictResult addEntriesFromDictionary:[self persistConstraint:subView relationmargins:_margins relationToItems:_toItems]];
        if (index != 0) {
            [dictResult addEntriesFromDictionary:[self persistEqualsWithForView:subView target:subViews.firstObject]];
        }
        [arrayResult addObject:dictResult];
        index ++;
    }
    return arrayResult;
}

/**
 纵向等比约束
 */
+(nonnull NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> *) persistConstraintVertical:(nonnull NSArray<UIView *> *)subViews relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems offset:(CGFloat) offset{
    
    NSMutableArray<NSDictionary<NSString *, NSLayoutConstraint *> *> * arrayResult = [NSMutableArray new];
    
    NSUInteger index = 0;
    for (UIView *subView in subViews) {
        
        NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
        
        PYEdgeInsetsItem _toItems = toItems;
        UIEdgeInsets _margins = margins;
        
        if (index == 0) {
            _toItems.bottom = nil;
            _margins.bottom = DisableConstrainsValueMAX;
            
        }else if(index == [subViews count] - 1){
            _toItems.top = (__bridge void * _Nullable)(subViews[index - 1]);
            _margins.top = offset;
            _toItems.bottom = nil;
        }else{
            _toItems.top = (__bridge void * _Nullable)(subViews[index - 1]);
            _margins.top = offset;
            _toItems.bottom = nil;
            _margins.bottom = DisableConstrainsValueMAX;//offset;
        }
        
        [dictResult addEntriesFromDictionary:[self persistConstraint:subView relationmargins:_margins relationToItems:_toItems]];
        if (index != 0) {
            [dictResult addEntriesFromDictionary:[self persistEqualsHeightForView:subView target:subViews.firstObject]];
//            NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:subViews.firstObject attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
//            [subView.superview addConstraint:equalsConstraint];
//            dictResult[@"superEqualsHeight"] = equalsConstraint;
        }
        [arrayResult addObject:dictResult];
        index ++;
    }
    
    return arrayResult;
}

+(BOOL) isValueEnable:(float) value{
    if (value<DisableConstrainsValueMAX-1&&value>=DisableConstrainsValueMIN+1) {
        return YES;
    }
    return NO;
}

@end
