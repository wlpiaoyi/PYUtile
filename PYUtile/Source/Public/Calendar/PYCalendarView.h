//
//  PYCalendarView.h
//  PYCalendar
//
//  Created by wlpiaoyi on 2016/12/14.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYUtile.h"
#import "PYCalendarParam.h"

@interface PYCalendarView : UIView{
@public
    PYSpesalInfo spesals[60];
    unsigned int spesalLength;
}
@property (nonatomic, strong, nonnull) NSDate * date;
kPNSNN NSDate * dateEnableStart;
kPNSNN NSDate * dateEnableEnd;
@property (nonatomic, copy, nullable) void (^blockSelected) (PYCalendarView * _Nonnull view);
@property (nonatomic, copy, nullable) void (^blockChangeMonth) (PYCalendarView * _Nonnull view);
-(void) synSpesqlInfo;
@end
