//
//  PYGraphicsThumb.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/30.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYGraphicsThumb.h"

@interface PYGraphicsLayer: CALayer
@property (nonatomic, strong) id userInfo;
@property (nonatomic, copy) blockGraphicsLayerDraw block;
@property (nonatomic, strong) id synBlock;
-(void) setBlockGraphicsLayerDraw:(blockGraphicsLayerDraw) block;
@end


@interface PYGraphicsThumb()
@property (nonatomic, strong) UIImage * thumb;
@property (nonatomic, strong) CALayer *thumbLayer;
@property (nonatomic, strong) PYGraphicsLayer *graphicsLayer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, copy) blockGraphicsLayerDraw block;
@property (nonatomic, strong) id synBlock;
@end

@implementation PYGraphicsThumb
+(nonnull instancetype) graphicsThumbWithView:(nonnull UIView*) view block:(nullable blockGraphicsLayerDraw) block{
    PYGraphicsThumb *gt = [PYGraphicsThumb new];
    gt.view = view;
    gt.block = block;
    return gt;
}

-(instancetype) init{
    if(self=[super init]){
        self.synBlock = [NSObject new];
        [self setup];
    }
    return self;
}
-(nonnull CALayer *) executDisplay:(nullable id) userInfo{
    @synchronized(_synBlock) {
        [_view setNeedsLayout];
        if(self.graphicsLayer){
            [self.graphicsLayer removeFromSuperlayer];
        }else{
            self.graphicsLayer = [PYGraphicsLayer layer];
            [self.graphicsLayer setBlockGraphicsLayerDraw:self.block];
            
        }
        self.graphicsLayer.userInfo = userInfo;
        self.graphicsLayer.contentsScale = [UIScreen mainScreen].scale;
        self.graphicsLayer.frame = _view.bounds;
        self.graphicsLayer.masksToBounds = NO;
        self.graphicsLayer.backgroundColor = [[UIColor clearColor] CGColor];
        [_view.layer addSublayer:self.graphicsLayer];
        [self.graphicsLayer displayIfNeeded];
        [self.graphicsLayer setNeedsDisplay];
    }
    return self.graphicsLayer;
}


-(void)setup{
    _view.clipsToBounds = NO;
    CALayer *thumbLayer = [CALayer layer];
    thumbLayer.contentsScale = [UIScreen mainScreen].scale;
    thumbLayer.contents = (id) _thumb.CGImage;
    thumbLayer.frame = CGRectMake(_view.frame.size.width  - _thumb.size.width, 0, _thumb.size.width, _thumb.size.height);
    thumbLayer.hidden = YES;
    [_view.layer addSublayer:thumbLayer];
    self.thumbLayer = thumbLayer;
}

@end

@implementation PYGraphicsLayer
-(id) init{
    if(self=[super init]){
        self.synBlock = [NSObject new];
    }
    return self;
}
-(void) setBlockGraphicsLayerDraw:(blockGraphicsLayerDraw) block{
    @synchronized(_synBlock){
        self.block = block;
    }
}
-(void) drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    @synchronized(_synBlock){
        if (self.block) {
            _block(ctx,self.userInfo);
        }
    }
}
@end
