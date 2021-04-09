//
//  UIView+PYLayoutOption.m
//  PYUtile
//
//  Created by wlpiaoyi on 2021/3/29.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "UIView+PYLayoutOption.h"
#import "PYConstraintMaker.h"

@implementation UIView(PYLayoutOption)

-(nullable NSLayoutConstraint *) py_getLayoutRelationWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstAnchor:(nullable NSLayoutAnchor *)firstAnchor
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondAttribute:(NSLayoutAttribute) secondAttribute
                                                              secondAnchor:(nullable NSLayoutAnchor *)secondAnchor
                                                              secondItem:(nullable UIView *) secondItem
                                                              relation:(NSLayoutRelation) relation
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints{
    for (NSLayoutConstraint * constraint in constraints) {
        if(firstAttribute != NSLayoutAttributeNotAnAttribute){
            if(constraint.firstAttribute != firstAttribute) continue;
        }
        if(secondAttribute != NSLayoutAttributeNotAnAttribute){
            if(constraint.secondAttribute != secondAttribute) continue;
        }
        if(firstItem){
            if([firstItem isKindOfClass:[NSNull class]]){
                if(constraint.firstItem != nil) continue;
            }else if(constraint.firstItem != firstItem) continue;
        }
        if(secondItem){
            if([secondItem isKindOfClass:[NSNull class]]){
                if(constraint.secondItem != nil) continue;
            }else if(constraint.secondItem != secondItem) continue;
        }
        if(firstAnchor){
            if(constraint.firstAnchor != firstAnchor) continue;
        }
        if(secondAnchor){
            if(constraint.secondAnchor != secondAnchor) continue;
        }
        if(constraint.relation != relation) continue;
        return constraint;
    }
    return nil;
}

-(nullable NSLayoutConstraint *) py_getItemLayoutWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondItem:(nullable UIView *) secondItem
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints{
    NSLayoutConstraint * layoutConstraint = [self py_getLayoutRelationWithFirstAttribute:firstAttribute firstAnchor:nil firstItem:firstItem secondAttribute:NSLayoutAttributeNotAnAttribute secondAnchor:nil secondItem:secondItem relation:NSLayoutRelationEqual constraints:constraints];
    if(layoutConstraint) return layoutConstraint;
    
    layoutConstraint = [self py_getLayoutRelationWithFirstAttribute:NSLayoutAttributeNotAnAttribute firstAnchor:nil firstItem:secondItem secondAttribute:firstAttribute secondAnchor:nil secondItem:firstItem relation:NSLayoutRelationEqual constraints:constraints];
    if(layoutConstraint) return layoutConstraint;
    
    return nil;

}

-(nullable NSLayoutConstraint *) py_getAnchorLayoutWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondAnchor:(nullable NSLayoutAnchor *) secondAnchor
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints{
    NSLayoutConstraint * layoutConstraint = [self py_getLayoutRelationWithFirstAttribute:firstAttribute firstAnchor:nil firstItem:firstItem secondAttribute:firstAttribute secondAnchor:secondAnchor secondItem:nil relation:NSLayoutRelationEqual constraints:constraints];
    if(layoutConstraint) return layoutConstraint;
    
    layoutConstraint = [self py_getLayoutRelationWithFirstAttribute:firstAttribute firstAnchor:secondAnchor firstItem:nil secondAttribute:firstAttribute secondAnchor:nil secondItem:firstItem relation:NSLayoutRelationEqual constraints:constraints];
    if(layoutConstraint) return layoutConstraint;
    
    return nil;
}

@end

