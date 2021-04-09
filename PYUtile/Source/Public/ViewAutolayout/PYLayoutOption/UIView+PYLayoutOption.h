//
//  UIView+PYLayoutOption.h
//  PYUtile
//
//  Created by wlpiaoyi on 2021/3/29.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+PYLayoutGet.h"
#import "UIView+PYLayoutRemove.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView(PYLayoutOption)

-(nullable NSLayoutConstraint *) py_getLayoutRelationWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstAnchor:(nullable NSLayoutAnchor *)firstAnchor
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondAttribute:(NSLayoutAttribute) secondAttribute
                                                              secondAnchor:(nullable NSLayoutAnchor *)secondAnchor
                                                              secondItem:(nullable UIView *) secondItem
                                                              relation:(NSLayoutRelation) relation
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints;

-(nullable NSLayoutConstraint *) py_getItemLayoutWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondItem:(nullable UIView *) secondItem
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints;

-(nullable NSLayoutConstraint *) py_getAnchorLayoutWithFirstAttribute:(NSLayoutAttribute) firstAttribute
                                                              firstItem:(nullable UIView *) firstItem
                                                              secondAnchor:(nullable NSLayoutAnchor *) secondAnchor
                                                              constraints:(NSArray<__kindof NSLayoutConstraint *> *) constraints;

@end

NS_ASSUME_NONNULL_END
