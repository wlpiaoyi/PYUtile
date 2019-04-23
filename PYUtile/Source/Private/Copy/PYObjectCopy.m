//
//  PYObjectCopy.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/4/19.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYObjectCopy.h"
#import "NSObject+Expand.h"
#import "PYArchiveParse.h"
#import "PYInvoke.h"
#import <objc/runtime.h>

@implementation PYObjectCopy

/**
 复制同一类型 对象值到另一个对象
 */
+(nullable NSObject *) copyValueWithClass:(Class) clazz fromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj{
    if([fromObj isKindOfClass:[NSArray class]]){
        if(![toObj isKindOfClass:[NSArray class]]) return nil;
        return [self copyArrayFromObjs:(NSArray *)fromObj toObjs:(NSArray *)toObj];
    }
    if([fromObj isKindOfClass:[NSSet class]]){
        if(![toObj isKindOfClass:[NSSet class]]) return nil;
        return [self copySetFromObjs:(NSSet *)fromObj toObjs:(NSSet *)toObj];
    }
    if([fromObj isKindOfClass:[NSDictionary class]]){
        if(![toObj isKindOfClass:[NSDictionary class]]) return nil;
        if(![toObj isKindOfClass:[NSMutableDictionary class]]) toObj = [NSMutableDictionary new];
        [((NSMutableDictionary *) toObj) setDictionary:(NSDictionary *)fromObj];
        return toObj;
    }
    if([PYArchiveParse canParset:fromObj.class]) return nil;
    
    if(fromObj.class != clazz && ![fromObj.class isMemberForClazz:clazz]) return nil;
    if(toObj.class != clazz && ![toObj.class isMemberForClazz:clazz]) return nil;
    
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(clazz, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString * keyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        id value = [fromObj valueForKey:keyName];
        if(!value) continue;
        if([PYArchiveParse canParset:[value class]]){
            [toObj setValue:value forKey:keyName];
            continue;
        }
        if([value isKindOfClass:[NSDictionary class]]){
            NSDictionary * toValue = [toObj valueForKey:keyName];
            if(toValue == nil) toValue = [NSMutableDictionary new];
            toValue = (NSDictionary *)[self copyValueFromObj:value toObj:toValue];
            [toObj setValue:toValue forKey:keyName];
            continue;
        }
        if([value isKindOfClass:[NSArray class]]){
            NSArray * toValues = [toObj valueForKey:keyName];
            if(toValues == nil) toValues = [NSMutableArray new];
            toValues = [self copyArrayFromObjs:value toObjs:toValues];
            [toObj setValue:toValues forKey:keyName];
            continue;
        }
        if([value isKindOfClass:[NSSet class]]){
            NSSet * toValues = [toObj valueForKey:keyName];
            if(toValues == nil) toValues = [NSMutableSet new];
            toValues = [self copySetFromObjs:value toObjs:toValues];
            [toObj setValue:toValues forKey:keyName];
            continue;
        }
        id toValue = [toObj valueForKey:keyName];
        if(toValue == nil) toValue = [[value class] new];
        toValue = [self copyValueWithClass:[value class] fromObj:value toObj:toValue];
        [toObj setValue:toValue forKey:keyName];
    }
    return toObj;
}
+(nullable NSArray *) copyArrayFromObjs:(nonnull NSArray *) fromObjs toObjs:(nonnull NSArray *) toObjs{
    if(![fromObjs isKindOfClass:[NSArray class]]) return nil;
    if(![toObjs isKindOfClass:[NSArray class]]) return nil;
    NSInteger index = 0;
    for (NSObject * fromObj in fromObjs) {
        NSObject * toObj = nil;
        if(toObjs.count <= index){
            toObj = [fromObj.class new];
            if(![toObjs isKindOfClass:[NSMutableArray class]]){
                toObjs = [toObjs mutableCopy];
            }
        }
        BOOL isContained = NO;
        if(!toObj){
            isContained = YES;
            toObj = toObjs[index];
        }
        NSObject * objResult = [fromObj.class copyValueFromObj:fromObj toObj:toObj];
        if(!isContained) [((NSMutableArray *) toObjs) addObject:objResult];
        else if(objResult != toObj){
            [((NSMutableArray *) toObjs) removeObject:toObj];
            [((NSMutableArray *) toObjs) addObject:objResult];
        }
        index ++;
    }
    return toObjs;
}
+(nullable NSSet *) copySetFromObjs:(nonnull NSSet *) fromObjs toObjs:(nonnull NSSet *) toObjs{
    if(![fromObjs isKindOfClass:[NSSet class]]) return nil;
    if(![toObjs isKindOfClass:[NSSet class]]) return nil;
    NSMutableSet * contains = [NSMutableSet new];
    for (NSObject * fromObj in fromObjs) {
        NSObject * toObj = nil;
        if(toObjs.count < fromObjs.count){
            if(![toObjs isKindOfClass:[NSMutableSet class]]){
                toObjs = [toObjs mutableCopy];
            }
            for (NSObject * obj in toObjs) {
                if([contains containsObject:obj]) continue;
                toObj = obj;
                break;
            }
        }
        BOOL isContained = YES;
        if(!toObj){
            toObj = [fromObj.class new];
            isContained = NO;
        }
        NSObject * objResult = [fromObj.class copyValueFromObj:fromObj toObj:toObj];
        [contains addObject:objResult];
        if(!isContained) [((NSMutableSet *) toObjs) addObject:objResult];
        else if(objResult != toObj){
            [((NSMutableSet *) toObjs) removeObject:toObj];
            [((NSMutableSet *) toObjs) addObject:objResult];
        }
    }
    return toObjs;
}
@end
