//
//  NSNumber+Expand.m
//  Common
//
//  Created by wlpiaoyi on 15/2/2.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "NSNumber+Expand.h"

@implementation NSNumber(Expand)
/**
 将number转换成string 
 @percision 精度控制
 */
-(NSString*) stringValueWithPrecision:(int) precision{
    NSString *result = [self stringValue];
    NSArray *resultArray = [result componentsSeparatedByString:@"."];
    if (![resultArray count]) {
        return @"0";
    }
    
    result = resultArray.firstObject;
    
    if ([result isEqualToString:@""]) {
        return @"0";
    }
    
    if ([resultArray count]==1) {
        return result;
    }
    
    result = resultArray.firstObject;
    NSString *precisionStr = resultArray.lastObject;
    if ([precisionStr isEqualToString:@""]||precisionStr==nil) {
        return result;
    }
    
    
    const char *precisionChar = [precisionStr UTF8String];
    
    int strlenght = (int)strlen(precisionChar);
    if (precision>0) {
        int zeroCount = strlenght;
        for (int index = strlenght; index > 0 ;index--) {
            if (precisionChar[index]!='0') {
                break;
            }
            zeroCount--;
        }
        
        for (int index = 0; index < strlen(precisionChar); index++) {
            if (index>=zeroCount) {
                break;
            }
            if (index>=precision) {
                break;
            }
            if (index == 0) {
                result = [result stringByAppendingString:@"."];
            }
            result = [result stringByAppendingFormat:@"%c",precisionChar[index]];
        }
    }else if(precision<0){
        const char *values = [result UTF8String];
        result = @"";
        int lengthValues = (int)strlen(values)+precision;
        for (int index = 0; index < strlen(values); index++) {
            if (index>=lengthValues) {
                result = [result stringByAppendingString:@"0"];
            }else{
                result = [result stringByAppendingFormat:@"%c",values[index]];
            }
        }
    }
    return  result;
}
@end
