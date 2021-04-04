//
//  UIView+PYLayoutGet.m
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/4.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "UIView+PYLayoutGet.h"
#import "UIView+PYLayoutGetSet.h"



@implementation UIView(PYLayoutGet)

-(nullable NSLayoutConstraint *) py_layoutTop{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeTop;
    id firstItem = self;
    id secondItem = nil;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutTopSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.topAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeTop firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutLeft{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeLeft;
    id firstItem = self;
    id secondItem = nil;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutLeftSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.leftAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeLeft firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutBottom{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeBottom;
    id firstItem = self;
    id secondItem = nil;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}
-(nullable NSLayoutConstraint *) py_layoutBottomSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.bottomAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeBottom firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutRight{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeRight;
    id firstItem = self;
    id secondItem = nil;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutRightSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.rightAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeRight firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutLeading{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeLeading;
    id firstItem = self;
    id secondItem = nil;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutLeadingSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.leadingAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeLeading firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutTrailing{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeTrailing;
    id firstItem = self;
    id secondItem = self.superview;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:secondItem constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutTrailingSafe{
    id firstItem = self;
    id secondAnchor = self.superview.safeAreaLayoutGuide.trailingAnchor;
    return [self py_getAnchorLayoutWithFirstAttribute:NSLayoutAttributeTrailing firstItem:firstItem secondAnchor:secondAnchor constraints:self.superview.constraints];
}


-(nullable NSLayoutConstraint *) py_layoutWidth{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeWidth;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutEqulesWidth{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeWidth;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutHeight{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeHeight;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutEqulesHeight{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeHeight;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutCenterX{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeCenterX;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutCenterY{
    NSLayoutAttribute firstAttribute = NSLayoutAttributeCenterY;
    id firstItem = self;
    return [self py_getItemLayoutWithFirstAttribute:firstAttribute firstItem:firstItem secondItem:nil constraints:self.superview.constraints];
}

-(nullable NSLayoutConstraint *) py_layoutAspect{
    id firstItem = self;
    id secondItem = self;
    NSLayoutRelation relation = NSLayoutRelationEqual;
    return [self py_getLayoutRelationWithFirstAttribute:NSLayoutAttributeNotAnAttribute firstAnchor:nil firstItem:firstItem secondAttribute:NSLayoutAttributeNotAnAttribute secondAnchor:nil secondItem:secondItem relation:relation constraints:self.constraints];
}


@end
