//
//  UIView+convenience.h
//
//  Created by Tjeerd in 't Veen on 12/1/11.
//  Copyright (c) 2011 Vurig Media. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (PYExpand)

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
 获取相对于目标视图的位置
 */
-(CGPoint) getAbsoluteOrigin:(UIView * _Nonnull) superView;
/**
 添加触控事件
 */
-(nullable UITapGestureRecognizer*) addTapGestureWithTarget:(nonnull id)target action:(nonnull SEL)action;
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
/**
 截屏
 */
+(UIImage * _Nullable) screenshot;


-(UITapGestureRecognizer * _Nonnull) py_addTarget:(id _Nonnull) target action:(SEL _Nonnull)action API_DEPRECATED_WITH_REPLACEMENT("addTapGestureWithTarget:action", ios(1.0, 2.0));

-(nonnull NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> *) setAutotLayotDict:(nonnull NSDictionary<NSString *, id> *) autoLayoutDict NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, "NO Use");
@end
