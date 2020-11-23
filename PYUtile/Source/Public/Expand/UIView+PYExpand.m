//
//  UIView+convenience.m
//
//  Created by Tjeerd in 't Veen on 12/1/11.
//  Copyright (c) 2011 Vurig Media. All rights reserved.
//

#import "UIView+PYExpand.h"
#import "PYViewAutolayoutCenter.h"

@interface UIView(){
}
@end
@implementation UIView (PYExpand)

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}


-(CGPoint) getAbsoluteOrigin:(UIView*) superView{
    CGPoint origin = CGPointMake(0, 0);
    UIView *sv = self;
    while (sv) {
        CGPoint p = sv.frame.origin;
        origin.x += p.x;
        origin.y += p.y;
        if([sv isKindOfClass:[UIScrollView class]] && ![sv isKindOfClass:[UITextView class]]){
            CGPoint offset = [((UIScrollView*)sv) contentOffset];
            origin.x -= offset.x;
            origin.y -= offset.y;
        }
        sv = sv.superview;
        if (sv==superView) {
            sv = nil;
            break;
        }
    }
    return origin;
}
/**
 添加触控事件
 */
-(UITapGestureRecognizer*) addTapGestureWithTarget:(id)target action:(SEL)action{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tapGesture];
    return tapGesture;
}

-(void)setCornerRadiusAndBorder:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    self.layer.cornerRadius = radius;
    self.layer.borderWidth = width;
    if(color)self.layer.borderColor = color.CGColor;
    [self setClipsToBounds:YES];
}

/**
 设置阴影层
 */
-(void) setShadowColor:(nonnull CGColorRef) shadowColor shadowRadius :(CGFloat) shadowRadius {
    
    [self setClipsToBounds:NO];
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowColor = shadowColor;//shadowColor阴影颜色
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
}
/**
 设置阴影层
 */
-(void) setShadowColor:(nonnull CGColorRef) shadowColor shadowRadius :(CGFloat) shadowRadius frame:(CGRect * _Nullable) frame{
    [self setShadowColor:shadowColor shadowRadius:shadowRadius];
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    float addWH = 10;
    if (frame) {
        width = (*frame).size.width;
        height = (*frame).size.height;
        x = (*frame).origin.x;
        y = (*frame).origin.y;
    }
    
    CGPoint topLeft      = self.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}


/**
 从xib加载数据，序列号要和当前class名称相同
 */
+(instancetype) loadXib{
    UIView * owner = [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] .lastObject;
    return owner;
}
-(UIImage * _Nullable) drawView{
    return [self drawViewWithBounds:self.bounds];
}
-(UIImage * _Nullable) drawViewWithBounds:(CGRect) bounds{
    return [self drawViewWithBounds:bounds scale:[[UIScreen mainScreen] scale]];
}
-(UIImage * _Nullable) drawViewWithBounds:(CGRect) bounds scale:(short) scale{
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, .38);
    [self drawViewHierarchyInRect:bounds  afterScreenUpdates:NO];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma undefined
-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            return YES;
        }
    }
    return NO;
}


-(BOOL) containsSubViewOfClassType:(Class)clazz {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:clazz]) {
            return YES;
        }
    }
    return NO;
}

/**
 截屏
 */
+(UIImage * _Nullable) screenshot{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(UITapGestureRecognizer*) py_addTarget:(id)target action:(SEL)action{return [self addTapGestureWithTarget:target action:action];}-(NSDictionary<NSString *, NSDictionary<NSString *, NSLayoutConstraint *> *> *) setAutotLayotDict:(NSDictionary<NSString *, id> *) autoLayoutDict{NSNumber * x = autoLayoutDict[@"x"];NSNumber * y = autoLayoutDict[@"y"];NSNumber * w = autoLayoutDict[@"w"];NSNumber * h = autoLayoutDict [@"h"];NSNumber * top = autoLayoutDict [@"top"];NSNumber * topActive = autoLayoutDict [@"topActive"];UIResponder * topPoint = autoLayoutDict [@"topPoint"];NSNumber * left = autoLayoutDict [@"left"];NSNumber * leftActive = autoLayoutDict [@"leftActive"];UIResponder * leftPoint = autoLayoutDict [@"leftPoint"];NSNumber * bottom = autoLayoutDict [@"bottom"];NSNumber * bottomActive = autoLayoutDict [@"bottomActive"];UIResponder * bottomPoint = autoLayoutDict [@"bottomPoint"];NSNumber * right = autoLayoutDict [@"right"];NSNumber * rightActive = autoLayoutDict [@"rightActive"];UIResponder * rightPoint = autoLayoutDict [@"rightPoint"];NSDictionary * point = [PYViewAutolayoutCenter persistConstraint:self centerPointer:CGPointMake(x ? x.doubleValue : DisableConstrainsValueMAX, y ? y.doubleValue : DisableConstrainsValueMAX)];NSDictionary * size =[PYViewAutolayoutCenter persistConstraint:self size:CGSizeMake(w ? w.doubleValue : DisableConstrainsValueMAX, h ? h.doubleValue : DisableConstrainsValueMAX)];UIEdgeInsets e = UIEdgeInsetsZero;e.top = top ? top.doubleValue : DisableConstrainsValueMAX;e.left = left ? left.doubleValue : DisableConstrainsValueMAX;e.bottom = bottom ? bottom.doubleValue : DisableConstrainsValueMAX;e.right = right ? right.doubleValue : DisableConstrainsValueMAX;PYEdgeInsetsItem ei = PYEdgeInsetsItemNull();ei.top = topPoint ? ((__bridge void *)topPoint) : nil;ei.topActive = topActive ? topActive.boolValue : false;ei.left = leftPoint ? ((__bridge void *)leftPoint) : nil;ei.leftActive = leftActive ? leftActive.boolValue : false;ei.bottom = bottomPoint ? ((__bridge void *)bottomPoint) : nil;ei.bottomActive = bottomActive ? bottomActive.boolValue : false;ei.right = rightPoint ? ((__bridge void *)rightPoint) : nil;ei.rightActive = rightActive ? rightActive.boolValue : false;NSDictionary * margin = [PYViewAutolayoutCenter persistConstraint:self relationmargins:e relationToItems:ei];NSMutableDictionary * result = [NSMutableDictionary new];if(point.count) result[@"point"] = point;if(size.count) result[@"size"] = size;if(margin.count) result[@"margin"] = margin;return result;}

@end
