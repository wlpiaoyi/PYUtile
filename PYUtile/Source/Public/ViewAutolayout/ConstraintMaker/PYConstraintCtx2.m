//
//  PYConstraintCtx2.m
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/7.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "PYConstraintCtx2.h"
#import "UIView+PYLayoutGet.h"
#import "UIView+PYLayoutRemove.h"

@implementation PYConstraintCtx2{
    UIView * constraintsCtx;
}


-(instancetype) initTopWithView:(UIView *) view{
    self = [self init];
    self.firstTarget = view;
    self.secondTarget = view.superview;
    self.firstAttribute = NSLayoutAttributeTop;
    self.secondAttribute = NSLayoutAttributeTop;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutTop];
    return self;
}

-(instancetype) initSafeTopWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0)){
    self = [self init];
    self.firstTarget = view;
    self.secondAnchor = view.superview.safeAreaLayoutGuide.topAnchor;
    self.firstAttribute = NSLayoutAttributeTop;
    self.secondAttribute = NSLayoutAttributeTop;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutTopSafe];
    return self;
}

-(instancetype) initLeftWithView:(UIView *) view{
    self = [self init];
    self.firstTarget = view;
    self.secondTarget = view.superview;
    self.firstAttribute = NSLayoutAttributeLeft;
    self.secondAttribute = NSLayoutAttributeLeft;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutLeft];
//    [constraintsCtx py_removeLayoutLeading];
    return self;
}

-(instancetype) initSafeLeftWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0)){
    self = [self init];
    self.firstTarget = view;
    self.secondAnchor = view.superview.safeAreaLayoutGuide.leftAnchor;
    self.firstAttribute = NSLayoutAttributeLeft;
    self.secondAttribute = NSLayoutAttributeLeft;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutLeftSafe];
//    [constraintsCtx py_removeLayoutLeadingSafe];
    return self;
}

-(instancetype) initBottomWithView:(UIView *) view{
    self = [self init];
    self.firstTarget = view;
    self.secondTarget = view.superview;
    self.firstAttribute = NSLayoutAttributeBottom;
    self.secondAttribute = NSLayoutAttributeBottom;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutBottom];
    return self;
}

-(instancetype) initSafeBootomtWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0)){
    self = [self init];
    self.firstTarget = view;
    self.secondAnchor = view.superview.safeAreaLayoutGuide.bottomAnchor;
    self.firstAttribute = NSLayoutAttributeBottom;
    self.secondAttribute = NSLayoutAttributeBottom;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutBottomSafe];
    return self;
}

-(instancetype) initRightWithView:(UIView *) view{
    self = [self init];
    self.firstTarget = view;
    self.secondTarget = view.superview;
    self.firstAttribute = NSLayoutAttributeRight;
    self.secondAttribute = NSLayoutAttributeRight;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutRight];
//    [constraintsCtx py_removeLayoutTrailing];
    return self;
}

-(instancetype) initSafeRightWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0)){
    self = [self init];
    self.firstTarget = view;
    self.secondAnchor = view.superview.safeAreaLayoutGuide.rightAnchor;
    self.firstAttribute = NSLayoutAttributeRight;
    self.secondAttribute = NSLayoutAttributeRight;
//    constraintsCtx = view.superview;
//    [constraintsCtx py_removeLayoutRightSafe];
//    [constraintsCtx py_removeLayoutTrailingSafe];
    return self;
}


-(nullable NSLayoutConstraint *) layoutConstraint{
    NSLayoutConstraint * lc = [NSLayoutConstraint constraintWithItem:self.firstTarget ? : self.firstAnchor attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondTarget ? : self.secondAnchor attribute:self.secondAttribute multiplier:1 constant:self.constant];
    return lc;
}


@end
