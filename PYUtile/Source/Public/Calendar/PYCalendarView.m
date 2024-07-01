//
//  PYCalendarView.m
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYCalendarView.h"
#import "PYCalendarHeadView.h"
#import "PYCalenderDrawView.h"
#import "PYViewAutolayoutCenter.h"
#import "PYCalendarLocation.h"
#import "PYGraphicsDraw.h"
#import "NSDate+Lunar.h"
#import "calendar_lunar.h"
#import "PYUtile.h"

static PYSpesalInfo PYCV_SPESALLINFO[60];
static int  PYCV_SPESALLLENGTH = 0;

@interface PYCalendarView()<PYCalenderDrawView>
@end

@implementation PYCalendarView{
@private
    PYCalenderDrawView * dateView;
    PYCalendarHeadView * weeakView;
    NSLayoutConstraint * lcWeekTop;
    CGSize orgSize;
    PYCalendarRect * crs;
    int crsLength;
    NSDate * currentMonth;
    CGPoint currentTouch;
}

+(void) initialize{
    kDISPATCH_ONCE_BLOCK(^{
        PYSpesalInfo spesals[60];
        int  spesalLength = 0;
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 1), "元旦节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 2), "世界湿地日",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 14), "情人节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 3, 8), "妇女节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 3, 12), "植树节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 1), "劳动节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 4, 1), "愚人节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 4, 7), "世界卫生日",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 4, 22), "世界地球日",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 4), "青年节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 6, 1), "儿童节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 1), "建党节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 1), "建党节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 8, 1), "建军节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 8, 12), "国际青年节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 9, 10), "教师节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 10, 1), "国庆节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 11, 1), "万圣节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 11, 11), "光棍节",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 24), "平安夜",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 25), "圣诞夜",false);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 1), "春节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 1), "中和节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 2), "春龙节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 2, 12), "花朝节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 3, 15), "(文)财神生日",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 5, 5), "端午节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 7), "七夕节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 15), "中原节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 7, 22), "(武)财神生日",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 8, 15), "中秋节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 9, 9), "重阳节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 8), "腊八节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 23), "祭灶节",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 12, 30), "除夕夜",true);
        spesals[spesalLength++] = PYSpesalInfoMake(PYDateMake(0, 1, 15), "元宵节",true);
        for (int i = 0; i < spesalLength; i++) {
            PYCV_SPESALLINFO[i] = spesals[i];
            PYCV_SPESALLLENGTH++;
        }
    });
}

kINITPARAMS{
    _dateEnableStart = [[NSDate date] offsetMonth:-3];
    _dateEnableEnd = [self.dateEnableStart offsetMonth:6];
    _date = [[NSDate date] setCompentsWithBinary:0b111000];
    dateView = [[PYCalenderDrawView alloc] initWithDate:self.date DateStart:self.dateEnableStart dateEnd:self.dateEnableEnd];
    weeakView = [PYCalendarHeadView new];
    self.date = self.date;
    orgSize = CGSizeZero;
    [self addSubview:weeakView];
    [self addSubview:dateView];
    
    [PYViewAutolayoutCenter persistConstraint:weeakView size:CGSizeMake(DisableConstrainsValueMAX, [PYUtile getFontHeightWithSize:weeakView.font.pointSize fontName:weeakView.font.fontName] + 5)];
    [PYViewAutolayoutCenter persistConstraint:weeakView relationmargins:UIEdgeInsetsMake(DisableConstrainsValueMAX, 0, DisableConstrainsValueMAX, 0) relationToItems:PYEdgeInsetsItemNull()];
    lcWeekTop = [PYViewAutolayoutCenter persistConstraint:weeakView relationmargins:UIEdgeInsetsMake(20, DisableConstrainsValueMAX, DisableConstrainsValueMAX, DisableConstrainsValueMAX) relationToItems:PYEdgeInsetsItemNull()].allValues.firstObject;
    PYEdgeInsetsItem e = PYEdgeInsetsItemNull();
    e.top = (__bridge void * _Nullable)(weeakView);
    [PYViewAutolayoutCenter persistConstraint:dateView relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:e];
    dateView.delegate = self;
    for (int i = 0; i < PYCV_SPESALLLENGTH; i++) {
        spesals[i] = PYCV_SPESALLINFO[i];
    }
    spesalLength = PYCV_SPESALLLENGTH;
    [self synSpesqlInfo];
}
-(void) setDate:(NSDate *)date{
    _date = date;
    currentMonth = [NSDate dateWithYear:_date.year month:_date.month day:1 hour:0 munite:0 second:0];
    dateView.date = currentMonth;
    [dateView reloadDate];
}
-(void) setDateEnableStart:(NSDate *)dateEnableStart{
    _dateEnableStart = dateEnableStart;
    dateView.dateEnableStart = dateEnableStart;
}
-(void) setDateEnableEnd:(NSDate *)dateEnableEnd{
    _dateEnableEnd = dateEnableEnd;
    dateView.dateEnableEnd = dateEnableEnd;
}
-(void) synSpesqlInfo{
    dateView->spesalLength = spesalLength;
    for (int i = 0; i < spesalLength; i++) {
        dateView->spesals[i] = spesals[i];
    }
}
-(void) drawOtherWithContext:(CGContextRef)context bounds:(CGRect)bounds locationLength:(int)locationLength locations:(PYCalendarRect *)locations{
    crs = locations;
    crsLength = locationLength;
    int year,month,day;
    year = self.date.year;
    month = self.date.month;
    day = self.date.day;
    PYDate currentDate = PYDateMake(year, month, day);
    year = _dateEnableStart.year;
    month = _dateEnableStart.month;
    day = _dateEnableStart.day;
    PYDate dateStart = PYDateMake(year, month, day);
    year = _dateEnableEnd.year;
    month = _dateEnableEnd.month;
    day = _dateEnableEnd.day;
    PYDate dateEnd = PYDateMake(year, month, day);
    if(PYDateCompareDate(currentDate, dateStart) < 0){
        currentDate = dateStart;
    }else if(PYDateCompareDate(currentDate, dateEnd) > 0){
        currentDate = dateEnd;
    }
    PYCalendarRect  pcr = PYCalendarRectMake(-1, CGRectNull, PYDateMake(0, 0, 0));
    for (int i = 0; i < locationLength; i++) {
        PYCalendarRect cr = locations[i];
        if(cr.flagEnable && PYDateCompareDate(currentDate, cr.date) == 0){
            pcr = cr;
            break;
        }
    }
    if(pcr.index != -1){
        CGFloat borderW = 2;
        CGPoint startP = CGPointMake(pcr.frame.origin.x, pcr.frame.origin.y + pcr.frame.size.height - borderW/2);
        CGPoint endP = CGPointMake(startP.x + pcr.frame.size.width, startP.y);
        [PYGraphicsDraw drawLineWithContext:context startPoint:startP endPoint:endP strokeColor:[UIColor redColor].CGColor strokeWidth:borderW lengthPointer:nil length:0];
    }
}
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect *)locations{
    crs = locations;
    crsLength = locationLength;
    
    UIFont *f1 = [UIFont italicSystemFontOfSize:MIN(60, self.frameHeight/6)];
    UIColor *c1 = [UIColor colorWithRed:.7 green:.7 blue:.7 alpha:.2];
    NSAttributedString * attribute = [[NSAttributedString alloc] initWithString:[self.date dateFormateDate:@"yy年MM月"] attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    CGSize s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    CGFloat bw = (bounds.size.height - s.height * 3)/4;
    CGRect r = bounds;
    r.origin = CGPointMake((bounds.size.width - s.width)/2,  bw);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
    attribute = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@年",self.date.lunarYearName, self.date.lunarYearZodiac] attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    
    s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    r.origin = CGPointMake((bounds.size.width - s.width)/2, r.origin.y + s.height + bw);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
    f1 = [UIFont italicSystemFontOfSize:f1.pointSize * .8];
    NSMutableString * arg = [NSMutableString new];
    [arg appendFormat:@"%@ %@",self.date.lunarMonthName,self.date.lunarDayName];
    attribute = [[NSAttributedString alloc] initWithString:arg attributes:@{NSForegroundColorAttributeName:c1,NSFontAttributeName:f1}];
    CGFloat h = r.origin.y + s.height;
    s = CGSizeMake(999, [PYUtile getFontHeightWithSize:f1.pointSize fontName:f1.fontName]);
    s = [PYUtile getBoundSizeWithAttributeTxt:attribute size:s];
    r.origin = CGPointMake((bounds.size.width - s.width)/2, h +  (bounds.size.height  - h - s.height)/2);
    r.size = bounds.size;
    [PYGraphicsDraw drawTextWithContext:context attribute:attribute rect:r y:bounds.size.height scaleFlag:false];
    
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    currentTouch = [touches.anyObject locationInView:self];
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if(!CGPointEqualToPoint(currentTouch, [touches.anyObject locationInView:self])){
        return;
    }
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:dateView];
    for (int i = 0; i < crsLength; i++) {
        PYCalendarRect  cr = crs[i];
        if(cr.frame.origin.x > touchPoint.x || cr.frame.origin.y > touchPoint.y) continue;
        if(cr.frame.origin.x + cr.frame.size.width < touchPoint.x || cr.frame.origin.y + cr.frame.size.height < touchPoint.y) continue;
        if(cr.flagEnable == false) return;
        _date = [NSDate dateWithYear:cr.date.year month:cr.date.month day:cr.date.day hour:0 munite:0 second:0];
        break;
    }
    [dateView reloadOther];
    if(self.blockSelected){
        _blockSelected(self);
    }
}
-(void) layoutSubviews{
    [super layoutSubviews];
    if(IOS9_OR_LATER){
        if(!CGSizeEqualToSize(orgSize, self.frameSize)){
            lcWeekTop.constant = self.frameHeight / 20;
        }
        orgSize = self.frameSize;
    }
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
