//
//  NSObject+PYDictionary.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/3.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+PYDictionary.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "PYInvoke.h"
#import "PYUtile.h"
#import "PYArchiveObject.h"
#import "PYArchiveParse.h"
#import "PYParseDictionary.h"
#import "NSString+PYExpand.h"

//id _Nullable (^ _Nullable PYBlocktodictParsetStruct) (NSInvocation * _Nonnull invocatioin, const char * _Nonnull typeEncoding) = nil;

@implementation NSObject(PYDictionary)

/**
 支持的property类型有:Object对象 ,CGSize,CGPoint,CGRect,NSRange,UIEdgeInsets,CGVector,UIOffset,CLLocationCoordinate2D
 @param dictionary
 */
#pragma mark 通过JSON初始化对象
+(instancetype) objectWithDictionary:(NSObject*) dictionary{
    return [self objectWithDictionary:dictionary clazz:self];
}

/**
 @param dictionary
 @param clazz
 */
#pragma mark 通过JSON初始化对象
+(nullable id) objectWithDictionary:(NSObject*) dictionary clazz:(Class) clazz{
    return [PYParseDictionary instanceClazz:clazz dictionary:dictionary];
}

-(NSObject*) objectToDictionary{
    return [self objectToDictionaryWithClass:nil];
}

-(nullable NSObject*) objectToDictionaryWithClass:(nullable Class) clazz{
    return [PYArchiveObject archvie:self clazz:clazz deep:0];
}

/**
 通过对象生成JSON
 */
-(nullable NSObject*) objectToDictionaryWithDeepClass:(Class) deepClass{
    NSMutableDictionary *  result = [NSMutableDictionary new];
    Class clazz = [self class];
    while (true)  {
        if(clazz == [NSObject class]) break;
        NSDictionary * dict = (NSDictionary *)[PYArchiveObject archvie:self clazz:clazz deep:0];
        if([dict isKindOfClass:[NSDictionary class]]){
            for (NSString * key in dict) {
                result[key] = dict[key];
            }
        }else if(result.count > 0){
            continue;
        }else{
            return dict;
        }
        if(clazz == deepClass) break;
        clazz = class_getSuperclass(clazz);
    }
    return result ;
}

/**
 通过dictionary解析出实体结构
 */
+(nullable NSString *) dictionaryAnalysisForClass:(nonnull NSDictionary*) dictionary{
    NSMutableArray * otherStructs = [NSMutableArray new];
    [self __PY_DICT_ANALYSIS:dictionary KEY:nil CLASSNAME:@"BASE" otherStructs:otherStructs];
    NSMutableString * structStr = [NSMutableString new];
    for (NSString * oss in otherStructs) {
        [structStr appendString:oss];
    }
    return structStr;
}


+(nullable NSString *) __PY_DICT_ANALYSIS:(nonnull NSObject *) obj KEY:(nullable NSString *) key CLASSNAME:(nullable NSString *) className otherStructs:(nullable NSMutableArray *) otherStructs{
    if(!key && className){
        if([obj isKindOfClass:[NSDictionary class]]){
            NSMutableString * structStr = [NSMutableString new];
            [structStr appendFormat:@"@interface PYDA%@ : NSObject\n\n", className];
            for (NSString * k in (NSDictionary *)obj) {
                id value = ((NSDictionary *)obj)[k];
                [structStr appendString:[self __PY_DICT_ANALYSIS:value KEY:k CLASSNAME:nil otherStructs:otherStructs]];
            }
            [structStr appendString:@"\n@end\n\n\n"];
            [otherStructs addObject:structStr];
        }else if([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSSet class]]){
            if(((NSArray *)obj).count > 0){
                [self __PY_DICT_ANALYSIS:((NSArray *)obj).firstObject KEY:nil CLASSNAME:className otherStructs:otherStructs];
            }
        }
    }else if (key){
        key = [PYArchiveParse parseKeyToVar:key];
        if([obj isKindOfClass:[NSString class]]){
            return kFORMAT(@"kPNSNA NSString * %@;//%@\n", key, [obj description]);
        }else if([obj isKindOfClass:[NSNumber class]]){
            if(((kInt64)(((NSNumber *)obj).doubleValue * 10)) % 10 != 0){
                return kFORMAT(@"kPNA CGFloat %@;//%@\n", key, [obj description]);
            }else{
                return kFORMAT(@"kPNA NSInteger %@;//%@\n", key, [obj description]);
            }
        }else if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSSet class]]){
            if(((NSArray *)obj).count > 0){
                [self __PY_DICT_ANALYSIS:((NSArray *)obj).firstObject KEY:nil CLASSNAME:key otherStructs:otherStructs];
            }
            return kFORMAT(@"kPNSNA NSArray * %@;\nkPNSNA PYDA%@ * property_%@;\n", key, key, key);
        }else if([obj isKindOfClass:[NSDictionary class]]){
            [self __PY_DICT_ANALYSIS:obj KEY:nil CLASSNAME:key otherStructs:otherStructs];
            return kFORMAT(@"kPNSNA PYDA%@ * %@;\n", key, key);
        }else{
            return kFORMAT(@"kPNSNA id %@;\n", key);
        }
    }
    return nil;
}
@end
