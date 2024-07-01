//
//  PYCalendarHeadView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarHeadView.h"
#import "PYGraphicsDraw.h"
#import "PYCalendarGraphics.h"

@implementation PYCalendarHeadView{
    PYGraphicsThumb * gtWeek;
    CGRect orgFrame;
}
-(instancetype) init{
    if(self = [super init]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self initParams];
    }
    return self;
}
-(void) initParams{
    orgFrame = CGRectNull;
    self.font  = PYCalendarWeekFont;
    self.color = PYCalendarWeekColor;
    @unsafeify(self);
    gtWeek = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawDateWithContext:ctx];
    }];
}

-(void) drawDateWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw drawTextWithContext:context attribute:[NSAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:true];
    [PYCalendarGraphics drawWeekWithContext:context bounds:self.bounds font:self.font color:self.color];
    CGPoint startP = CGPointMake(0, .25);
    CGPoint endP = CGPointMake(self.frameWidth, startP.y);
    [PYGraphicsDraw drawLineWithContext:context startPoint:startP endPoint:endP strokeColor:PYCalendarDisableColor.CGColor strokeWidth:.25 lengthPointer:nil length:0];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    if(!CGRectEqualToRect(orgFrame, self.frame)){
        [gtWeek executDisplay:nil];
    }
    orgFrame = self.frame;
}

@end
