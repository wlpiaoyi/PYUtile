//
//  UIView+NoUse.h
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/7.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


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


@interface UIView(PYAutolayoutSet)

/**
 * 添加宽约束
 */
-(nonnull UIView *) py_setAutolayoutWidth:(CGFloat) width;

/**
 * 添加高约束
 */
-(nonnull UIView *) py_setAutolayoutHeight:(CGFloat) height;

/**
 * 添加宽约束
 */
-(nonnull UIView *) py_setAutolayoutEqulesWidth:(CGFloat) width toItem:(nonnull UIView *) toItem;

/**
 * 添加高约束
 */
-(nonnull UIView *) py_setAutolayoutEqulesHeight:(CGFloat) height toItem:(nonnull UIView *) toItem;

/**
 * 添加居中X约束
 */
-(nullable UIView *) py_setAutolayoutCenterX:(CGFloat) x  toItem:(nonnull UIView *) toItem;

/**
 * 添加居中Y约束
 */
-(nullable UIView *) py_setAutolayoutCenterY:(CGFloat) y  toItem:(nonnull UIView *) toItem;

/**
 * 添加居中Point约束
 */
-(nullable UIView *) py_setAutolayoutCenterPoint:(CGPoint) point;

/**
 * 添加top对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationTop:(CGFloat) top toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe isReverse:(BOOL) isReverse;

/**
 * 添加Bottom对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationBottom:(CGFloat) bottom toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe isReverse:(BOOL) isReverse;

/**
 * 添加Left对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationLeft:(CGFloat) left toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe isReverse:(BOOL) isReverse;

/**
 * 添加Right对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationRight:(CGFloat) right toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe isReverse:(BOOL) isReverse;

@end


NS_ASSUME_NONNULL_END
