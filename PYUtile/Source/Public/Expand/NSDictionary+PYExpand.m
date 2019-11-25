//
//  NSDictionary+PYExpand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSDictionary+PYExpand.h"
static char * NSDictionaryExpandWeakKey = "weakkey_";

@implementation NSDictionary(PYExpand)

+(nullable id) checkDict:(nullable id) value{
    if(!value) return nil;
    
    if([value isKindOfClass:[NSString class]]
       || [value isKindOfClass:[NSNumber class]]
       || [value isKindOfClass:[NSDate class]]
       || [value isKindOfClass:[NSData class]]){
        return value;
    }
    
    if([value isKindOfClass:[NSArray class]]){
        NSMutableArray * tempArray = [NSMutableArray new];
        for (id cv in value) {
            id tempValue = [self checkDict:cv];
            if(tempValue){
                [tempArray addObject:tempValue];
            }
        }
        if(tempArray.count) return tempArray;
    }else if([value isKindOfClass:[NSSet class]]){
        NSMutableSet * tempSet = [NSMutableSet new];
        for (id cv in value) {
            id tempValue = [self checkDict:cv];
            if(tempValue){
                [tempSet addObject:tempValue];
            }
        }
        if(tempSet.count) return tempSet;
    }else if([value isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * tempDict = [NSMutableDictionary new];
        for (NSString * key in value) {
            id tempValue = value[key];
            id setValue = [self checkDict:tempValue];
            if(setValue) tempDict[key] = setValue;
        }
        if(tempDict.count) return tempDict;
    }
    return nil;
}
-(NSData * _Nullable) toData{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSAssert(NO, error.domain);
    }
    return jsonData;
}
@end

@implementation NSMutableDictionary(PYExpand)
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
