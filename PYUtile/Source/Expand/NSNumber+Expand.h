//
//  NSNumber+Expand.h
//  Common
//
//  Created by wlpiaoyi on 15/2/2.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber(Expand)
/**
 将number转换成string
 @percision 精度控制
 */
-(NSString*) stringValueWithPrecision:(int) precision;

@end
