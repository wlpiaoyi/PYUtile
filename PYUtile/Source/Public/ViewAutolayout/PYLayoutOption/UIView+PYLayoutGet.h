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
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTopSafe API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeft;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeftSafe API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutBottom;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutBottomSafe API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutRight;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutRightSafe API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeading;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutLeadingSafe API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTrailing;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutTrailingSafe API_AVAILABLE(ios(11.0),tvos(11.0));

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutWidth;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutHeight;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutEqulesWidth;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutEqulesHeight;

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutCenterX;
@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutCenterY;

@property (nonatomic, readonly, nullable) NSLayoutConstraint * py_layoutAspect;


-(nullable NSArray<NSLayoutConstraint *> *) py_layoutAll;

@end

NS_ASSUME_NONNULL_END
