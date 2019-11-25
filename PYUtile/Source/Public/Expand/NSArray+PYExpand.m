//
//  NSArray+PYExpand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSArray+PYExpand.h"
#import "NSObject+PYExpand.h"

@implementation NSArray(PYExpand)
-(NSData * _Nullable) toData{
    NSMutableArray * toDatas = [NSMutableArray new];
    for (NSObject * obj in self) {
        if([obj isKindOfClass:[NSDictionary class]]){
            [toDatas addObject:obj];
        }else [toDatas addObject:[obj objectToDictionary]];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:toDatas options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSAssert(NO, error.domain);
    }
    return jsonData;
}

@end
