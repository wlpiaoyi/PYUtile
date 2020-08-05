//
//  UIView+UIView_PYAutolayoutSet.m
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/4.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "UIView+PYAutolayout.h"
@interface PYConstraint()

kPNAR CGFloat value;
kPNAR BOOL isSafe;
kPNRNA UIView * toItem;

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
-(nullable UIView *) py_setAutolayoutRelationTop:(CGFloat) top toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe;

/**
 * 添加Bottom对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationBottom:(CGFloat) bottom toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe;

/**
 * 添加Left对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationLeft:(CGFloat) left toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe;

/**
 * 添加Right对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationRight:(CGFloat) right toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe;

@end

@implementation UIView (PYAutolayout)

- (nullable NSArray<NSLayoutConstraint *> *) py_makeConstraints:(void(NS_NOESCAPE ^)(PYConstraintMaker *make))block{
    if(block){
        PYConstraintMaker *make = [PYConstraintMaker instanceWithView:self];
        block(make);
        [make setValue:@(YES) forKey:@"isInstall"];
        if(make.width){
            if(make.width.toItem && [make.width.toItem isKindOfClass:[UIView class]]){
                [self py_setAutolayoutEqulesWidth:make.width.value toItem:make.width.toItem];
            }else{
                [self py_setAutolayoutWidth:make.width.value];
            }
        }
        if(make.height){
            if(make.height.toItem && [make.height.toItem isKindOfClass:[UIView class]]){
                [self py_setAutolayoutEqulesHeight:make.height.value toItem:make.height.toItem];
            }else{
                [self py_setAutolayoutHeight:make.height.value];
            }
        }
        if(make.centerX){
            PYConstraint * constraint = make.centerX;
            [self py_setAutolayoutCenterX:constraint.value toItem:constraint.toItem];
        }
        if(make.centerY){
            PYConstraint * constraint = make.centerY;
            [self py_setAutolayoutCenterY:constraint.value toItem:constraint.toItem];
        }
        
        if(make.top){
            PYConstraint * constraint = make.top;
            [self py_setAutolayoutRelationTop:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe];
        }
        if(make.bottom){
            PYConstraint * constraint = make.bottom;
            [self py_setAutolayoutRelationBottom:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe];
        }
        if(make.left){
            PYConstraint * constraint = make.left;
            [self py_setAutolayoutRelationLeft:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe];
        }
        if(make.right){
            PYConstraint * constraint = make.right;
            [self py_setAutolayoutRelationRight:constraint.value toItems:constraint.toItem isInSafe:constraint.isSafe];
        }
    }
    return [self py_getAllLayoutContarint];
}

@end

@implementation UIView (PYAutolayoutSet)

/**
 * 添加宽约束
 */
-(nonnull UIView *) py_setAutolayoutWidth:(CGFloat) width{
    [self py_removeAutolayoutEquelsWidth];
    NSLayoutConstraint * constraint = [self py_getAutolayoutWidth];
    if(constraint){
        constraint.constant = width;
    }else{
        [PYViewAutolayoutCenter persistConstraint:self size:CGSizeMake(width, DisableConstrainsValueMAX) ];
    }
    return self;
}

/**
 * 添加高约束
 */
-(nonnull UIView *) py_setAutolayoutHeight:(CGFloat) height{
    [self py_removeAutolayoutEquelsHeight];
    NSLayoutConstraint * constraint = [self py_getAutolayoutHeight];
     if(constraint){
         constraint.constant = height;
     }else{
         [PYViewAutolayoutCenter persistConstraint:self size:CGSizeMake(DisableConstrainsValueMAX, height)];
     }
    return self;
}
/**
 * 添加宽约束
 */
-(nonnull UIView *) py_setAutolayoutEqulesWidth:(CGFloat) width toItem:(nonnull UIView *) toItem{
    [self py_removeAutolayoutWidth];
    NSLayoutConstraint * constraint = [self py_getAutolayoutEqulesWidth];
    if(constraint){
        constraint.constant = width;
    }else{
        [PYViewAutolayoutCenter persistEqualsWithForView:self target:toItem multiplier:1 constant:width];
    }
    return self;
}

/**
 * 添加高约束
 */
-(nonnull UIView *) py_setAutolayoutEqulesHeight:(CGFloat) height toItem:(nonnull UIView *) toItem{
    [self py_removeAutolayoutHeight];
    NSLayoutConstraint * constraint = [self py_getAutolayoutEqulesHeight];
     if(constraint){
         constraint.constant = height;
     }else{
         [PYViewAutolayoutCenter persistEqualsHeightForView:self target:toItem multiplier:1 constant:height];
     }
    return self;
}

/**
 * 添加居中X约束
 */
-(nullable UIView *) py_setAutolayoutCenterX:(CGFloat) x toItem:(nonnull UIView *) toItem{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterX];
     if(constraint){
         constraint.constant = x;
     }else{
         [PYViewAutolayoutCenter persistConstraint:self centerPointer:CGPointMake(x, DisableConstrainsValueMAX) toItem:toItem];
     }
    return self;
}

/**
 * 添加居中Y约束
 */
-(nullable UIView *) py_setAutolayoutCenterY:(CGFloat) y  toItem:(nonnull UIView *) toItem{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterY];
     if(constraint){
         constraint.constant = y;
     }else{
         [PYViewAutolayoutCenter persistConstraint:self centerPointer:CGPointMake(DisableConstrainsValueMAX, y) toItem:toItem];
     }
    return self;
}

/**
 * 添加居中Point约束
 */
-(nullable UIView *) py_setAutolayoutCenterPoint:(CGPoint) point{
    NSLayoutConstraint * constraintX = [self py_getAutolayoutCenterX];
    NSLayoutConstraint * constraintY = [self py_getAutolayoutCenterY];
    if(constraintX){
        constraintX.constant = point.x;
        point.x = DisableConstrainsValueMAX;
    }
    if(constraintY){
        constraintY.constant = point.y;
        point.y = DisableConstrainsValueMAX;
    }
    [PYViewAutolayoutCenter persistConstraint:self centerPointer:point];
    return self;
}


/**
 * 添加top对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationTop:(CGFloat) top toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterY];
    if(constraint) [self.superview removeConstraint:constraint];
    constraint = [self py_getAutolayoutRelationTop];
    if(!constraint) constraint = [self py_getAutolayoutRelationSaftTop];
    if(constraint){
        constraint.constant = top;
    }else{
        UIEdgeInsets relationmargins = UIEdgeInsetsMake(top, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX);
        PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
         eii.topActive = isInSafe;
         if(toItems) eii.top = (__bridge void * _Nullable)(toItems);
         [PYViewAutolayoutCenter persistConstraint:self relationmargins:relationmargins relationToItems:eii];
    }
    return self;
}

/**
 * 添加Bottom对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationBottom:(CGFloat) bottom toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterY];
    if(constraint) [self.superview removeConstraint:constraint];
    constraint = [self py_getAutolayoutRelationBottom];
    if(!constraint) constraint = [self py_getAutolayoutRelationSaftBottom];
    if(constraint){
        constraint.constant = -bottom;
    }else{
        UIEdgeInsets relationmargins = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX, bottom,  DisableConstrainsValueMAX);
         PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
         eii.bottomActive = isInSafe;
         if(toItems) eii.bottom = (__bridge void * _Nullable)(toItems);
         [PYViewAutolayoutCenter persistConstraint:self relationmargins:relationmargins relationToItems:eii];
    }
    return self;
}

/**
 * 添加Left对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationLeft:(CGFloat) left toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterX];
    if(constraint) [self.superview removeConstraint:constraint];
    constraint = [self py_getAutolayoutRelationLeft];
    if(constraint){
        constraint.constant = left;
    }else{
        UIEdgeInsets relationmargins = UIEdgeInsetsMake(DisableConstrainsValueMAX, left, DisableConstrainsValueMAX,  DisableConstrainsValueMAX);
        PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
        eii.leftActive = isInSafe;
         if(toItems) eii.left = (__bridge void * _Nullable)(toItems);
         [PYViewAutolayoutCenter persistConstraint:self relationmargins:relationmargins relationToItems:eii];
    }
    return self;
}

/**
 * 添加Right对其约束
*/
-(nullable UIView *) py_setAutolayoutRelationRight:(CGFloat) right toItems:(nullable UIView *) toItems isInSafe:(BOOL) isInSafe{
    NSLayoutConstraint * constraint = [self py_getAutolayoutCenterX];
    if(constraint) [self.superview removeConstraint:constraint];
    constraint = [self py_getAutolayoutRelationRight];
    if(constraint){
        constraint.constant = -right;
    }else{
        UIEdgeInsets relationmargins = UIEdgeInsetsMake(DisableConstrainsValueMAX, DisableConstrainsValueMAX,  DisableConstrainsValueMAX, right);
         PYEdgeInsetsItem eii = PYEdgeInsetsItemNull();
         eii.rightActive = isInSafe;
         if(toItems) eii.right = (__bridge void * _Nullable)(toItems);
         [PYViewAutolayoutCenter persistConstraint:self relationmargins:relationmargins relationToItems:eii];
    }
    return self;
}

@end


@implementation UIView (PYAutolayoutGet)


/**
 * 获取top对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationSaftTop{
    if (@available(iOS 11.0, *)) {
        for (NSLayoutConstraint * constraint in self.superview.constraints) {
            if(constraint.secondAnchor == self.superview.safeAreaLayoutGuide.topAnchor &&
               constraint.firstItem == self){
                return constraint;
            }
        }
    }
    return nil;
}
/**
 * 获取top对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationTop{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeTop relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}


/**
 * 获取bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationSaftBottom{
    if (@available(iOS 11.0, *)) {
        for (NSLayoutConstraint * constraint in self.superview.constraints) {
            if(constraint.secondAnchor == self.superview.safeAreaLayoutGuide.bottomAnchor &&
               constraint.firstItem == self ){
                return constraint;
            }
        }
    }
    return nil;
}

/**
 * 获取bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationBottom{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeBottom relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取left对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationLeft{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeLeft relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取right对其约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutRelationRight{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeRight relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取宽约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutWidth{
    return [self py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual firstItem:self secondItem:nil];
}

/**
 * 获取高约束
 */
-(nonnull NSLayoutConstraint *) py_getAutolayoutHeight{
    return [self py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationEqual firstItem:self secondItem:nil];
}

/**
 * 获取宽约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutEqulesWidth{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeWidth relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取高约束
 */
-(nonnull NSLayoutConstraint *) py_getAutolayoutEqulesHeight{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeHeight relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取居中X约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutCenterX{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeCenterX relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}

/**
 * 获取居中Y约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutCenterY{
    return [self.superview py_getAutolayoutContraintWithFirstAttribute:NSLayoutAttributeCenterY relation:NSLayoutRelationEqual firstItem:self secondItem:self.superview];
}


/**
 * 获取约束
 */
-(nullable NSLayoutConstraint *) py_getAutolayoutContraintWithFirstAttribute:(NSLayoutAttribute) firstAttribute relation:(NSLayoutRelation) relation firstItem:(nullable UIView *) firstItem secondItem:(nullable UIView *) secondItem {
    for (NSLayoutConstraint * constraint in self.constraints) {
        if(constraint.firstAttribute == firstAttribute &&
           constraint.relation == relation &&
           constraint.firstItem == firstItem){
            return constraint;
        }
    }
    return nil;
}

-(NSArray<NSLayoutConstraint *> *) py_getAllLayoutContarint{
    NSMutableArray * layoutContarints = [NSMutableArray new];
    NSLayoutConstraint * layoutContarint = [self py_getAutolayoutWidth];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutHeight];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutEqulesWidth];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutEqulesHeight];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutCenterX];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutCenterY];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationTop];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationSaftTop];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationLeft];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationBottom];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationSaftBottom];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    layoutContarint = [self py_getAutolayoutRelationRight];
    if(layoutContarint) [layoutContarints addObject:layoutContarint];
    return layoutContarints;
}

@end


@implementation UIView (PYAutolayoutRemove)


-(NSArray<NSLayoutConstraint *> *) py_removeAllLayoutContarint{
    NSArray<NSLayoutConstraint *> * layoutContarints = [self py_getAllLayoutContarint];
    for (NSLayoutConstraint * layoutContarint in layoutContarints) {
        [self removeConstraint:layoutContarint];
        [self.superview removeConstraint:layoutContarint];
    }
    return layoutContarints;
}

/**
 * 删除top对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationSaftTop{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationSaftTop];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}
/**
 * 删除top对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationTop{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationTop];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}


/**
 * 删除bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationSaftBottom{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationSaftBottom];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除bottom对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationBottom{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationBottom];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除left对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationLeft{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationLeft];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除right对其约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutRelationRight{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutRelationRight];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除宽约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutWidth{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutWidth];
    if(layoutConstraint) [self removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除高约束
 */
-(nonnull NSLayoutConstraint *) py_removeAutolayoutHeight{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutHeight];
    if(layoutConstraint) [self removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除宽约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutEquelsWidth{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutEqulesWidth];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除高约束
 */
-(nonnull NSLayoutConstraint *) py_removeAutolayoutEquelsHeight{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutEqulesHeight];
    if(layoutConstraint) [self.superview removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除居中X约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutCenterX{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutCenterX];
    if(layoutConstraint) [self removeConstraint:layoutConstraint];
    return layoutConstraint;
}

/**
 * 删除居中Y约束
 */
-(nullable NSLayoutConstraint *) py_removeAutolayoutCenterY{
    NSLayoutConstraint * layoutConstraint = [self py_getAutolayoutCenterY];
    if(layoutConstraint) [self removeConstraint:layoutConstraint];
    return layoutConstraint;
}

@end


