//
//  PYConstraintMaker.h
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/5.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PYAutolayoutUtilites.h"
#import "PYUtile.h"

NS_ASSUME_NONNULL_BEGIN

@class PYConstraint;

@interface PYConstraintMaker : NSObject

kPNRNA PYConstraint * width;
kPNRNA PYConstraint * height;
kPNRNA PYConstraint * centerX;
kPNRNA PYConstraint * centerY;

kPNRNA PYConstraint * top;
kPNRNA PYConstraint * bottom;
kPNRNA PYConstraint * left;
kPNRNA PYConstraint * right;

+(instancetype) instanceWithView:(nonnull UIView *) view;

@end


@interface PYConstraint : NSObject

kPNRNA PYConstraint * width;
kPNRNA PYConstraint * height;
kPNRNA PYConstraint * centerX;
kPNRNA PYConstraint * centerY;

kPNRNA PYConstraint * top;
kPNRNA PYConstraint * bottom;
kPNRNA PYConstraint * left;
kPNRNA PYConstraint * right;

+(instancetype) instanceWithMaker:(nonnull PYConstraintMaker *) maker;
#pragma mark 布局值
- (nonnull PYConstraintMaker* (^)(id value)) py_constant;
#pragma mark 布局是否在安全区域
- (nonnull PYConstraint* (^)(BOOL isSafe)) py_inSafe;
#pragma mark 布局参考对象, 默认是superView
- (nonnull PYConstraint* (^)(UIView * toItem)) py_toItem;
@end


NS_ASSUME_NONNULL_END
