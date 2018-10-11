//
//  UIView+convenience.h
//
//  Created by Tjeerd in 't Veen on 12/1/11.
//  Copyright (c) 2011 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (Expand)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

/**
 x,y 距离中心点的距离
 w,h 宽度和高度
 top,left,bottom,right 边框距离
 topActive,leftActive,bottomActive,rightActive 是否在安全区
 topPoint,leftPoint,bottomPoint,rightPoint 边距参照对象
 */
-(NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> *) setAutotLayotDict:(NSDictionary<NSString *, id> *) autoLayoutDict;

/**
 获取相对于目标视图的位置
 */
-(CGPoint) getAbsoluteOrigin:(UIView * _Nonnull) superView;
/**
 添加单击事件
 */
-(UITapGestureRecognizer * _Nonnull) py_addTarget:(id _Nonnull) target action:(SEL _Nonnull)action;
/**
 图层的简单设置
 */
-(void)setCornerRadiusAndBorder:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor * _Nullable)color;
/**
 设置阴影层
 */
-(void) setShadowColor:(nonnull CGColorRef) shadowColor shadowRadius :(CGFloat) shadowRadius;
/**
 设置阴影层
 */
-(void) setShadowColor:(nonnull CGColorRef) shadowColor shadowRadius :(CGFloat) shadowRadius frame:(CGRect * _Nullable) frame;
/**
 从xib加载数据，序列号要和当前class名称相同
 */
+(instancetype _Nullable) loadXib;
-(UIImage * _Nullable) drawView;
-(UIImage * _Nullable) drawViewWithBounds:(CGRect) bounds;
-(UIImage * _Nullable) drawViewWithBounds:(CGRect) bounds scale:(short) scale;
@end
