//
//  NSArray+PYAutolayout.h
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/5.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYConstraintMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray(PYAutolayout)

-(nullable NSArray<NSLayoutConstraint *> *) py_makeConstraints:(void(NS_NOESCAPE ^)(PYConstraintMaker *make))block;

@end

NS_ASSUME_NONNULL_END
