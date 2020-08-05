//
//  ViewAutolayoutCenter.h
//  Common
//
//  Created by wlpiaoyi on 15/1/5.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PYUtile.h"

extern const NSString * _Nonnull PYAtltSuperTop;
extern const NSString * _Nonnull PYAtltSuperBottom ;
extern const NSString * _Nonnull PYAtltSuperLeft;
extern const NSString * _Nonnull PYAtltSuperRight;
extern const NSString * _Nonnull PYAtltSelfWith;
extern const NSString * _Nonnull PYAtltSelfHeight;
extern const NSString * _Nonnull PYAtltSelfCenterX;
extern const NSString * _Nonnull PYAtltSelfCenterY;
extern const NSString * _Nonnull PYAtltEquelsWidth;
extern const NSString * _Nonnull PYAtltEquelsHeight;

extern const CGFloat DisableConstrainsValueMAX;
extern const CGFloat DisableConstrainsValueMIN;

typedef struct PYEdgeInsetsItem {
    void  * _Nullable top, * _Nullable left, * _Nullable bottom, * _Nullable right;
    bool topActive, leftActive, bottomActive, rightActive;
    bool topReverse, leftReverse, bottomReverse, rightReverse;
    // specify amount to inset (positive) for each of the edges. values can be negative to 'outset'
} PYEdgeInsetsItem;
kUTILE_STATIC_INLINE PYEdgeInsetsItem PYEdgeInsetsItemMake(void  * _Nullable top, void  * _Nullable left, void  * _Nullable bottom, void  * _Nullable right) {
    PYEdgeInsetsItem insets = {top, left, bottom, right, false, false, false, false, false, false, false, false};
    return insets;
}
kUTILE_STATIC_INLINE PYEdgeInsetsItem PYEdgeInsetsItemNull() {
    PYEdgeInsetsItem insets = {nil, nil, nil, nil, false, false, false, false, false, false, false, false};
    return insets;
}


@interface PYViewAutolayoutCenter : NSObject

/**
 新增关系约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(nonnull UIView*) subView relationmargins:(UIEdgeInsets) margins controller:(nonnull UIViewController *) controller;
/**
 新增关系约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(nonnull UIView*) subView relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems;
/**
 新增大小约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(nonnull UIView*) subView size:(CGSize) size;
/*
 新增布局约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(nonnull UIView*) subView centerPointer:(CGPoint) pointer;
/*
 新增布局约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistConstraint:(nonnull UIView*) subView centerPointer:(CGPoint) pointer toItem:(nullable UIView *) toItem;
/**
 等宽约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsWithForView:(nonnull UIView *) view target:(nonnull UIView *) target;
/**
 等宽约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsWithForView:(nonnull UIView *) view target:(nonnull UIView *) target multiplier:(CGFloat) multiplier constant:(CGFloat) constant;
/**
 等高约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsHeightForView:(nonnull UIView *) view target:(nonnull UIView *) target;
/**
 等高约束
 */
+(nonnull NSDictionary<NSString *, NSLayoutConstraint *> *) persistEqualsHeightForView:(nonnull UIView *) view target:(nonnull UIView *) target multiplier:(CGFloat) multiplier constant:(CGFloat) constant;
/**
 横向等比约束
 */
+(nonnull NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> *) persistConstraintHorizontal:(nonnull NSArray<UIView *> *)subViews relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems offset:(CGFloat) offset;
/**
 纵向等比约束
 */
+(nonnull NSArray<NSDictionary<NSString *, NSLayoutConstraint *> *> *) persistConstraintVertical:(nonnull NSArray<UIView *> *)subViews relationmargins:(UIEdgeInsets) margins relationToItems:(PYEdgeInsetsItem) toItems offset:(CGFloat) offset;

@end
