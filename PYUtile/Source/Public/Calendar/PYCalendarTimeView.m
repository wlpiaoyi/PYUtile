//
//  PYCalendarTimeView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/16.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarTimeView.h"
#import "pyutilea.h"
#import "PYCalendarGraphics.h"

@implementation PYCalendarTimeView{
@private
    PYGraphicsThumb *gtTime;
    PYGraphicsThumb *gtPoint;
    PYGraphicsThumb *gtNum;
    CGRect orgFrame;
}
-(instancetype) init{
    if (self = [super init]) {
        [self initWithParam];
    }
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithParam];
    }
    return self;
}

-(void) initWithParam{
    orgFrame = CGRectNull;
    self.strokeWith = 10;
    self.time = PYTimeMake(3, 20, 36);
    @unsafeify(self);
    gtPoint = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [PYCalendarGraphics drawClockPointWithContext:ctx bounds:self.bounds];
    }];
    gtNum = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [PYCalendarGraphics drawClockNumWithContext:ctx bounds:self.bounds];
    }];
    
    gtTime = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [PYCalendarGraphics drawClockTimeWithContext:ctx bounds:self.bounds time:self.time strokeWith:self.strokeWith strokeColor:[UIColor orangeColor].CGColor fillColor:[UIColor clearColor].CGColor];
    }];
}

-(void) layoutSubviews{
    [super layoutSubviews];
    if(!CGRectEqualToRect(orgFrame, self.frame)){
        [gtPoint executDisplay:nil];
        [gtNum executDisplay:nil];
        [gtTime executDisplay:nil];
    }
    orgFrame = self.frame;
}

@end
