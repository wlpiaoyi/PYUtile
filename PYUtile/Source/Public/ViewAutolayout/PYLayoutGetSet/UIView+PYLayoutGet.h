//
//  UIView+PYLayoutGet.h
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/4.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView(PYLayoutGet)

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTop;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTopSafe;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeft;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeftSafe;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutBottom;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutBottomSafe;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutRight;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutRightSafe;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeading;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeadingSafe;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTrailing;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTrailingSafe;

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutWidth;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutHeight;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutEqulesWidth;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutEqulesHeight;

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutCenterX;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutCenterY;

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutAspect;

@end

NS_ASSUME_NONNULL_END
