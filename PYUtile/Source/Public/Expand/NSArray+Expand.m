//
//  NSArray+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSArray+Expand.h"
#import "NSObject+Expand.h"

@implementation NSArray(Expand)
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
