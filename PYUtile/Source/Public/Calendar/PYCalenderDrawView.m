//
//  PYCalenderDrawView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalenderDrawView.h"
#import "PYCalendarGraphics.h"
#import "PYCalendarLocation.h"
#import "PYCalendarParam.h"
#import "NSDate+Lunar.h"
#import "pyutilea.h"

static PYDate  PYCalenderDateMin;
static PYDate PYCalenderDateMax;
@interface PYCalenderDrawView()<PYCalendarLocation>{
    CGFloat heightFontDay;
    CGFloat heightFontLunar;
    PYGraphicsThumb * gtDate;
    PYGraphicsThumb * gtOther;
    PYGraphicsThumb * gtText;
    CGRect orgFrame;
    CALayer * layerDate;
    CALayer * layerOther;
    CALayer * layerText;
    int currentMonth;
}

@end

@implementation PYCalenderDrawView
+(void) initialize{
    PYCalenderDateMin = PYDateMake(1901, 1, 1);
    PYCalenderDateMax = PYDateMake(2099, 12, 31);
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
    self.dateEnableStart = [[NSDate new] offsetMonth:-6];
    self.dateEnableEnd = [self.dateEnableStart offsetMonth:12];
    self.date = [NSDate date];
    return self;
}
-(instancetype) initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self initParams];
    }
    self.dateEnableStart = [[NSDate new] offsetMonth:-6];
    self.dateEnableEnd = [self.dateEnableStart offsetMonth:12];
    self.date = [NSDate date];
    return self;
}
-(instancetype) initWithDate:(nonnull NSDate *) date DateStart:(nonnull NSDate *) dateStart dateEnd:(nonnull NSDate *) dateEnd{
    if(self = [super init]){
        [self initParams];
    }
    self.dateEnableStart = dateStart;
    self.dateEnableEnd = dateEnd;
    self.date = date;
    return self;
}
-(void) initParams{
    orgFrame = CGRectNull;
    self.fontDay = PYCalendarDayFont;
    self.colorDay = PYCalendarDayColor;
    self.fontLunar = PYCalendarLunarFont;
    self.colorLunar = PYCalendarLunarColor;
    self.colorDisable = PYCalendarDisableColor;
    self.colorWeekend = PYCalendarWeeakEndColor;
    self.colorSpecial = PYCalendarSpecial;
    self.fontSpesal = PYCalendarSpesalFont;
    @unsafeify(self);
    gtOther = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawOtherWithContext:ctx];
    }];
    gtDate = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        [self drawDateWithContext:ctx];
    }];
    gtText = [PYGraphicsThumb graphicsThumbWithView:self block:^(CGContextRef  _Nonnull ctx, id  _Nullable userInfo) {
        @strongify(self);
        if(PYCalendarHasWatermark)[self drawTextWithContext:ctx];
    }];
}

-(void) setFontDay:(UIFont *)fontDay{
    _fontDay = fontDay;
    heightFontDay = [PYUtile getFontHeightWithSize:_fontDay.pointSize fontName:fontDay.fontName];
}

-(void) setFontLunar:(UIFont *)fontLunar{
    _fontLunar = fontLunar;
    heightFontLunar = [PYUtile getFontHeightWithSize:_fontLunar.pointSize fontName:_fontLunar.fontName];
}

-(void) setDate:(NSDate *)date{
    int year,month;
    year = date.year;
    month = date.month;
    if(PYCalenderDateMin.year > year ||  (PYCalenderDateMin.year == year && PYCalenderDateMin.month > month) ){
        date = [NSDate dateWithYear:PYCalenderDateMax.year month:PYCalenderDateMax.month day:PYCalenderDateMax.day hour:0 munite:0 second:0];
    }else if(PYCalenderDateMax.year < year || (PYCalenderDateMax.year == year && PYCalenderDateMax.month < month) ){
        date = [NSDate dateWithYear:PYCalenderDateMin.year month:PYCalenderDateMin.month day:PYCalenderDateMin.day hour:0 munite:0 second:0];
    }
    _date = date;
    currentMonth = _date.month;
    [PYCalendarLocation locationMonthWithDate:_date bounds:self.bounds locationsLengthPointer:&locationLength iterator:self];
}

-(void) reloadDate{
    [self reloadOther];
    layerDate = [gtDate executDisplay:nil];
}

-(void) reloadOther{
    layerText = [gtText executDisplay:nil];
    layerOther = [gtOther executDisplay:nil];
}

-(void) iteratorDayIntMonth:(PYCalendarRect) rect{
    locations[rect.index] = rect;
    locations[rect.index].flagEnable = true;
}

-(void) drawDateWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw startDraw:&context];
    [PYGraphicsDraw drawTextWithContext:context attribute:[NSAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:true];
    NSDate * tempDate = [NSDate date];
    PYDate  today = PYDateMake(tempDate.year, tempDate.month, tempDate.day);
    int year = _dateEnableStart.year;
    int month = _dateEnableStart.month;
    int day = _dateEnableStart.day;
    PYDate dateStart = PYDateMake(year, month, day);
    year = _dateEnableEnd.year;
    month = _dateEnableEnd.month;
    day = _dateEnableEnd.day;
    PYDate dateEnd = PYDateMake(year, month, day);
    UIColor * __colorLunar = [UIColor colorWithRed:self.colorLunar.red green:self.colorLunar.green blue:self.colorLunar.blue alpha:self.colorLunar.alpha * 0.35];
    UIColor * __colorWeekend = [UIColor colorWithRed:self.colorWeekend.red green:self.colorWeekend.green blue:self.colorWeekend.blue alpha:self.colorWeekend.alpha * 0.35];
    UIColor * __colorSpecial = [UIColor colorWithRed:self.colorSpecial.red green:self.colorSpecial.green blue:self.colorSpecial.blue alpha:self.colorSpecial.alpha * 0.35];
    UIColor * __colorDay = [UIColor colorWithRed:self.colorDay.red green:self.colorDay.green blue:self.colorDay.blue alpha:self.colorDay.alpha * 0.35];
    for (int i = 0; i < locationLength; i++){
        PYCalendarRect cr = locations[i];
        if(self.delegate && [self.delegate respondsToSelector:@selector(drawTextWithContext:bounds:calendarRect:)]){
            [self.delegate drawTextWithContext:context bounds:self.bounds calendarRect:cr];
        }
        bool flagEnable = PYDateCompareDate(cr.date, dateStart) >= 0 && PYDateCompareDate(cr.date, dateEnd) <= 0;
        UIColor * colorDay = currentMonth == cr.date.month ? self.colorDay : self.colorDisable;
        UIColor * colorLunar = currentMonth == cr.date.month ? self.colorLunar : self.colorDisable;
        locations[i].flagEnable = flagEnable;
        UIColor * specalColoar;
        if(flagEnable){
            specalColoar = currentMonth == cr.date.month ? self.colorSpecial : __colorSpecial;
            if(i%7 == 0 || i%7 == 6){
                colorDay = currentMonth == cr.date.month ? self.colorWeekend : __colorWeekend;
            }else{
                colorDay = currentMonth == cr.date.month ? self.colorDay : __colorDay;
            }
            colorLunar = currentMonth == cr.date.month ? self.colorLunar : __colorLunar;
        }else{
            colorDay = self.colorDisable;
            colorLunar = self.colorDisable;
            specalColoar = self.colorDisable;
        }
        CGRect resultRect = [PYCalendarGraphics drawDayWithContext:context bounds:self.bounds borderWith:2 dateRect:&cr heightDay:heightFontDay heightLunar:heightFontLunar fontDay:_fontDay fontLunar:_fontLunar colorDay:colorDay colorLunar:colorLunar];

        if(PYDateCompareDate(today, cr.date) == 0){
            [PYCalendarGraphics drawMarkWithContext:context bounds:self.bounds mark:"今" markFont:self.fontLunar markColor:specalColoar resultRect:resultRect calendarRect:cr];
        }
        if(PYCalendarHasSpesal){
            for (int i = 0; i<spesalLength; i++) {
                PYSpesalInfo si = spesals[i];
                if(si.isLunar){
                    if(si.date.year <= 0)si.date.year = cr.lunarDate.year;
                    if(PYDateCompareDate(si.date, cr.lunarDate) == 0){
                        [PYCalendarGraphics drawSpecalWithContext:context bounds:self.bounds spesal:si.spesal specalColor:specalColoar specalFont:self.fontSpesal resultRect:resultRect calendarRect:cr heightFontLunar:heightFontLunar];
                        break;
                    }
                }else{
                    if(si.date.year <= 0)si.date.year = cr.date.year;
                    if(PYDateCompareDate(si.date, cr.date) == 0){
                        [PYCalendarGraphics drawSpecalWithContext:context bounds:self.bounds spesal:si.spesal specalColor:specalColoar specalFont:self.fontSpesal resultRect:resultRect calendarRect:cr heightFontLunar:heightFontLunar];
                        break;
                    }
                }
            }
        }
    }
    [PYGraphicsDraw endDraw:&context];
}

-(void) drawOtherWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw startDraw:&context];
    int num = locationLength / 7;
    CGFloat height = self.frameHeight / (CGFloat)num;
    CGPoint startP = CGPointMake(0, -.25);
    CGPoint endP = CGPointMake(self.frameWidth, -.25);
    for (int i = 0; i < num; i++) {
        startP.y += height;
        endP.y = startP.y;
        [PYGraphicsDraw drawLineWithContext:context startPoint:startP endPoint:endP strokeColor:self.colorDisable.CGColor strokeWidth:.25 lengthPointer:nil length:0];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(drawOtherWithContext:bounds:locationLength:locations:)]){
        [self.delegate drawOtherWithContext:context bounds:self.bounds locationLength:locationLength locations:locations];
    }
    [PYGraphicsDraw endDraw:&context];
    
}

-(void) drawTextWithContext:(nullable CGContextRef) context{
    [PYGraphicsDraw drawTextWithContext:context attribute:[NSAttributedString new] rect:self.bounds y:self.bounds.size.height scaleFlag:true];
    if(self.delegate && [self.delegate respondsToSelector:@selector(drawTextWithContext:bounds:locationLength:locations:)]){
        [self.delegate drawTextWithContext:context bounds:self.bounds locationLength:locationLength locations:locations];
    }
}
-(void) layoutSubviews{
    [super layoutSubviews];
    if(!CGRectEqualToRect(orgFrame, self.frame)){
        self.date = self.date;
        [self reloadDate];
    }
    orgFrame = self.frame;
}
@end
