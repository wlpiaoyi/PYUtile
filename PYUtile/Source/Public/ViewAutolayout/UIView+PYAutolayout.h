//
//  UIView+UIView_PYAutolayoutSet.h
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/4.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYConstraintMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (PYAutolayout)

-(nullable NSArray<NSLayoutConstraint *> *) py_makeConstraints:(void(NS_NOESCAPE ^)(PYConstraintMaker *make))block;

@end

@interface UIView (PYAutolayoutGet)

/**
 * 获取top对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationSaftTop;
/**
 * 获取top对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationTop;
/**
 * 获取bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationSaftBottom;

/**
 * 获取bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationBottom;

/**
 * 获取left对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationLeft;

/**
 * 获取right对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationRight;

/**
 * 获取宽约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutWidth;

/**
 * 获取高约束
 */
-(nonnull NSLayoutConstraint *) py_getAutolayoutHeight;

/**
 * 获取宽约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutEqulesWidth;

/**
 * 获取高约束
 */
-(nonnull NSLayoutConstraint *) py_getAutolayoutEqulesHeight;
/**
 * 获取居中X约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutCenterX;

/**
 * 获取居中Y约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutCenterY;

-(nullable NSArray<NSLayoutConstraint *> *) py_getAllLayoutContarint;

@end

@interface UIView (PYAutolayoutRemove)

/**
 * 删除top对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationSaftTop;
/**
 * 删除top对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationTop;


/**
 * 删除bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationSaftBottom;

/**
 * 删除bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationBottom;

/**
 * 删除left对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationLeft;

/**
 * 删除right对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationRight;

/**
 * 删除宽约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutWidth;

/**
 * 删除高约束
 */
-(nonnull NSLayoutConstraint *) py_removeAutolayoutHeight;

/**
 * 删除宽约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutEquelsWidth;

/**
 * 删除高约束
 */
-(nonnull NSLayoutConstraint *) py_removeAutolayoutEquelsHeight;

/**
 * 删除居中X约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutCenterX;

/**
 * 删除居中Y约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutCenterY;

-(nullable NSArray<NSLayoutConstraint *> *) py_removeAllLayoutContarint;

@end

NS_ASSUME_NONNULL_END
