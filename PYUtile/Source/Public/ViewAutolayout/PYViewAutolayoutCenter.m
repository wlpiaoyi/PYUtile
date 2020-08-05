//
//  ViewAutolayoutCenter.m
//  Common
//
//  Created by wlpiaoyi on 15/1/5.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "PYViewAutolayoutCenter.h"
#import "UIView+PYExpand.h"


const CGFloat DisableConstrainsValueMAX = CGFLOAT_MAX - 1;
const CGFloat DisableConstrainsValueMIN  = -DisableConstrainsValueMAX;
const NSString * _Nonnull PYAtltSuperTop = @"superTop";
const NSString * _Nonnull PYAtltSuperBottom = @"superBottom";
const NSString * _Nonnull PYAtltSuperLeft = @"superLeft";
const NSString * _Nonnull PYAtltSuperRight = @"superRight";
const NSString * _Nonnull PYAtltSelfWith = @"selfWith";
const NSString * _Nonnull PYAtltSelfHeight = @"selfHeight";
const NSString * _Nonnull PYAtltSelfCenterX = @"selfCenterX";
const NSString * _Nonnull PYAtltSelfCenterY = @"selfCenterY";
const NSString * _Nonnull PYAtltEquelsWidth = @"equelsWidth";
const NSString * _Nonnull PYAtltEquelsHeight = @"equelsHeight";

@implementation PYViewAutolayoutCenter

/**
 新增关系约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView relationmargins:(UIEdgeInsets) margins controller:(UIViewController *) controller{
    PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
    eii.top = (__bridge void * _Nullable)(controller.topLayoutGuide);
    eii.bottom = (__bridge void * _Nullable)(controller.bottomLayoutGuide);
    eii.topActive = true;
    eii.bottomActive = true;
    eii.leftActive = true;
    eii.rightActive = true;
    return [PYViewAutolayoutCenter persistConstraint:subView relationmargins:margins relationToItems:eii];
}

/**
 新增关系约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
    NSLayoutAttribute superAtt;
    NSObject *layoutGuide;
    #pragma mark margin top
    if ([self isValueEnable:margins.top]) {
        if(toItems.top){
            superAtt = NSLayoutAttributeBottom;
            layoutGuide = (__bridge NSObject *)(toItems.top);
        }else{
            layoutGuide = [subView superview];
            superAtt = NSLayoutAttributeTop;
        }
        NSLayoutConstraint * marginsTop = nil;
        if (@available(iOS 11.0, *) ) {
            if(toItems.topActive && layoutGuide == [subView superview]){
                marginsTop = [subView.topAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.topAnchor constant:margins.top];
            }
        }
        if(!marginsTop){
            marginsTop = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:layoutGuide attribute:superAtt multiplier:1 constant:margins.top];
        }
        marginsTop.active = toItems.topActive;
        
        [[subView superview] addConstraint:marginsTop];
        dictResult[PYAtltSuperTop] = marginsTop;
    }
    #pragma mark margin buttom
    if ([self isValueEnable:margins.bottom]) {
        if(toItems.bottom){
            superAtt = NSLayoutAttributeTop;
            layoutGuide = (__bridge NSObject *)(toItems.bottom);
        }else{
            layoutGuide = [subView superview];
            superAtt = NSLayoutAttributeBottom;
        }
        NSLayoutConstraint * marginsBottom = nil;
        if (@available(iOS 11.0, *) ) {
            if(toItems.bottomActive && layoutGuide == [subView superview]){
                marginsBottom =[subView.bottomAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.bottomAnchor constant:-margins.bottom];
            }
        }
        if(!marginsBottom){
             marginsBottom = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:layoutGuide attribute:superAtt multiplier:1 constant:-margins.bottom];
        }
        marginsBottom.active = toItems.bottomActive;
        [[subView superview] addConstraint:marginsBottom];

        dictResult[PYAtltSuperBottom] = marginsBottom;
    }
    #pragma mark margin left
    if ([self isValueEnable:margins.left]) {
        if(toItems.left){
            superAtt = NSLayoutAttributeRight;
            layoutGuide = (__bridge NSObject *)(toItems.left);
        }else{
            layoutGuide = [subView superview];
            superAtt = NSLayoutAttributeLeft;
        }
        NSLayoutConstraint *marginsLeft = nil;
        
        if (@available(iOS 11.0, *) ) {
            if(toItems.leftActive && layoutGuide == [subView superview]){
                marginsLeft = [subView.leftAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.leftAnchor constant:margins.left];
            }
        }
        if (layoutGuide == [subView superview]){
            if (@available(iOS 11.0, *)) {
                marginsLeft.active = true;
            }
        }
        if(!marginsLeft){
             marginsLeft = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:layoutGuide attribute:superAtt multiplier:1 constant:margins.left];
        }
        marginsLeft.active = toItems.leftActive;
        [[subView superview] addConstraint:marginsLeft];
        dictResult[PYAtltSuperLeft] = marginsLeft;
    }
    #pragma mark margin right
    if ([self isValueEnable:margins.right]) {
        if(toItems.right){
            superAtt = NSLayoutAttributeLeft;
            layoutGuide = (__bridge NSObject *)(toItems.right);
        }else{
            layoutGuide = [subView superview];
            superAtt = NSLayoutAttributeRight;
        }
        NSLayoutConstraint *marginsRight = nil;
        if (@available(iOS 11.0, *) ) {
            if(toItems.rightActive && layoutGuide == [subView superview]){
                marginsRight = [subView.rightAnchor constraintEqualToAnchor:subView.superview.safeAreaLayoutGuide.rightAnchor constant:-margins.right];
            }
        }
        if(!marginsRight){
            marginsRight = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:layoutGuide attribute:superAtt multiplier:1 constant:-margins.right];
        }
        marginsRight.active = toItems.rightActive;
        [[subView superview] addConstraint:marginsRight];

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
    return [self persistConstraint:subView centerPointer:pointer toItem:nil];
}

/*
 新增布局约束
 */
+(NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(UIView*) subView centerPointer:(CGPoint) pointer toItem:(nullable UIView *) toItem{
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *superView = [subView superview];
    toItem = toItem ? : superView;
    NSMutableDictionary<NSString *, NSLayoutConstraint *> * dictResult = [NSMutableDictionary new];
    
    if ([self isValueEnable:pointer.x]) {
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeCenterX multiplier:1 constant:pointer.x];
        [superView addConstraint:centerX];
        
        dictResult[PYAtltSelfCenterX] = centerX;
    }
    if ([self isValueEnable:pointer.y]) {
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeCenterY multiplier:1 constant:pointer.y];
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
    NSLayoutConstraint *equalsConstraint= [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:target attribute:NSLayoutAttributeHeight multiplier:multiplier constant:constant];
    [view.superview addConstraint:equalsConstraint];
    return @{PYAtltEquelsHeight: equalsConstraint};
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
