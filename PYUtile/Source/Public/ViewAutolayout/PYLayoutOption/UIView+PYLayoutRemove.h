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
-(nullable NSLayoutConstraint *) py_removeLayoutTopSafe API_AVAILABLE(ios(11.0),tvos(11.0));
-(nullable NSLayoutConstraint *) py_removeLayoutLeft;
-(nullable NSLayoutConstraint *) py_removeLayoutLeftSafe API_AVAILABLE(ios(11.0),tvos(11.0));
-(nullable NSLayoutConstraint *) py_removeLayoutBottom;
-(nullable NSLayoutConstraint *) py_removeLayoutBottomSafe API_AVAILABLE(ios(11.0),tvos(11.0));
-(nullable NSLayoutConstraint *) py_removeLayoutRight;
-(nullable NSLayoutConstraint *) py_removeLayoutRightSafe API_AVAILABLE(ios(11.0),tvos(11.0));
-(nullable NSLayoutConstraint *) py_removeLayoutLeading;
-(nullable NSLayoutConstraint *) py_removeLayoutLeadingSafe API_AVAILABLE(ios(11.0),tvos(11.0));
-(nullable NSLayoutConstraint *) py_removeLayoutTrailing;
-(nullable NSLayoutConstraint *) py_removeLayoutTrailingSafe API_AVAILABLE(ios(11.0),tvos(11.0));

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
