//
//  NSDictionary+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSDictionary+Expand.h"
static char * NSDictionaryExpandWeakKey = "weakkey_";

@implementation NSDictionary(Expand)
-(NSData * _Nullable) toData{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSAssert(NO, error.domain);
    }
    return jsonData;
}
@end

@implementation NSMutableDictionary(Expand)
-(void) setWeakValue:(nullable id)value forKey:(nonnull NSString *)key{
    NSString * weakKey = [NSString stringWithFormat:@"%s%@",NSDictionaryExpandWeakKey, key];
    if(value == nil) [self setValue:nil forKey:weakKey];
    void * pointer = (__bridge void *)(value);
    long pointerLong = (long)pointer;
    [self setValue:@(pointerLong) forKey:weakKey];
}
-(nonnull id) weakValueForKey:(nonnull NSString *) key{
    NSString * weakKey = [NSString stringWithFormat:@"%s%@",NSDictionaryExpandWeakKey, key];
    NSNumber * pointerNumber = [self valueForKey:weakKey];
    if(pointerNumber == nil) return nil;
    void * pointer = (void *)(pointerNumber.longValue);
    return (__bridge id)(pointer);
}
@end
