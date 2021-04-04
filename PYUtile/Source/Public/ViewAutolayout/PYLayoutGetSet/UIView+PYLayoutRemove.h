//
//  UIView+PYLayoutRemove.h
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/4.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView(PYLayoutRemove)

-(nullable NSLayoutConstraint *) py_removeLayoutTop;
-(nullable NSLayoutConstraint *) py_removeLayoutTopSafe;
-(nullable NSLayoutConstraint *) py_removeLayoutLeft;
-(nullable NSLayoutConstraint *) py_removeLayoutLeftSafe;
-(nullable NSLayoutConstraint *) py_removeLayoutBottom;
-(nullable NSLayoutConstraint *) py_removeLayoutBottomSafe;
-(nullable NSLayoutConstraint *) py_removeLayoutRight;
-(nullable NSLayoutConstraint *) py_removeLayoutRightSafe;
-(nullable NSLayoutConstraint *) py_removeLayoutLeading;
-(nullable NSLayoutConstraint *) py_removeLayoutLeadingSafe;
-(nullable NSLayoutConstraint *) py_removeLayoutTrailing;
-(nullable NSLayoutConstraint *) py_removeLayoutTrailingSafe;

-(nullable NSLayoutConstraint *) py_removeLayoutWidth;
-(nullable NSLayoutConstraint *) py_removeLayoutHeight;
-(nullable NSLayoutConstraint *) py_removeLayoutEqulesWidth;
-(nullable NSLayoutConstraint *) py_removeLayoutEqulesHeight;

-(nullable NSLayoutConstraint *) py_removeLayoutCenterX;
-(nullable NSLayoutConstraint *) py_removeLayoutCenterY;

-(nullable NSLayoutConstraint *) py_removeLayoutAspect;

-(nullable NSArray<NSLayoutConstraint *> *) py_removeAllLayout;

@end
NS_ASSUME_NONNULL_END
