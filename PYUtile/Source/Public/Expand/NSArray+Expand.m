//
//  NSArray+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSArray+Expand.h"

@implementation NSArray(Expand)
-(NSData * _Nullable) toData{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSAssert(NO, error.domain);
    }
    return jsonData;
}

@end
