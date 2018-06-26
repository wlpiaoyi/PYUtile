//
//  NSNumber+Expand.m
//  Common
//
//  Created by wlpiaoyi on 15/2/2.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "NSNumber+Expand.h"
#import "NSString+Expand.h"

@implementation NSNumber(Expand)
/**
 将number转换成string 
 @percision 精度控制
 */
-(NSString*) stringValueWithPrecision:(int) precision{
    
    if(precision == 0){
        return [NSString stringWithFormat:@"%ld", self.integerValue];
    }
    
    NSMutableString * format = [NSMutableString new];
    [format appendString:@"%."];
    [format appendFormat:@"%if", precision];
    
    NSString * value = [NSString stringWithFormat:format, self.doubleValue];
    NSArray<NSTextCheckingResult *> * matches = [value matchesForRegex:@"\\.[0-9]{1,}"];
    
    if(matches.count != 1) return value;
    if(matches.firstObject.numberOfRanges < 1) return value;
    
    
    NSRange range = [matches.firstObject rangeAtIndex:0];
    NSString * component = [value substringWithRange:range];
    
    if([NSString matchArg:component regex:@"^\\.0{0,}$"]){
        value = [value stringByReplacingCharactersInRange:range withString:@""];
        return value;
    }
    
    NSArray<NSTextCheckingResult *> * cmatches = [component matchesForRegex:@"[1-9]{1,}0{1,}$"];
    
    if(cmatches.count != 1) return value;
    if(cmatches.firstObject.numberOfRanges < 1) return value;
    
    NSRange crange = [cmatches.firstObject rangeAtIndex:0];
    NSString * ccomponent = [component substringWithRange:crange];
    
    
    NSArray<NSTextCheckingResult *> * ccmatches = [ccomponent matchesForRegex:@"0{1,}$"];
    
    if(ccmatches.count != 1) return value;
    if(ccmatches.firstObject.numberOfRanges < 1) return value;
    
    NSRange ccrange = [ccmatches.firstObject rangeAtIndex:0];
    
    ccomponent = [ccomponent stringByReplacingCharactersInRange:ccrange withString:@""];
    component = [component stringByReplacingCharactersInRange:crange withString:ccomponent];
    value = [value stringByReplacingCharactersInRange:range withString:component];
    
    return  value;
}
@end
