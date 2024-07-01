//
//  PYCalenderDrawView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYCalendarParam.h"

@protocol PYCalenderDrawView<NSObject>
@optional
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds calendarRect:(PYCalendarRect) rect;
-(void) drawTextWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect[_Nullable 43]) locations;
-(void) drawOtherWithContext:(nullable CGContextRef) context bounds:(CGRect) bounds locationLength:(int) locationLength locations:(PYCalendarRect[_Nullable 43]) locations;
@end

@interface PYCalenderDrawView : UIView{
@public
    PYCalendarRect locations[43];
    int locationLength;
    PYSpesalInfo spesals[60];
    unsigned int spesalLength;
}
@property (nonatomic, assign, nullable) id<PYCalenderDrawView> delegate;
kPNSNN NSDate * dateEnableStart;
kPNSNN NSDate * dateEnableEnd;
kPNSNN NSDate * date;
kPNSNN UIFont * fontDay;
kPNSNN UIColor * colorDay;
kPNSNN UIFont * fontLunar;
kPNSNN UIColor * colorLunar;
kPNSNN UIColor * colorDisable;
kPNSNN UIColor * colorWeekend;
kPNSNN UIColor * colorSpecial;
kPNSNN UIFont * fontSpesal;
-(nonnull instancetype) initWithDate:(nonnull NSDate *) date DateStart:(nonnull NSDate *) dateStart dateEnd:(nonnull NSDate *) dateEnd;
-(void) reloadDate;
-(void) reloadOther;
@end
