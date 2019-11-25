//
//  PYObjectCopy.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/4/19.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYObjectCopy.h"
#import "NSObject+PYExpand.h"
#import "PYArchiveParse.h"
#import "PYInvoke.h"
#import <objc/runtime.h>
#import "PYArchiveObject.h"

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
    
    if(![fromObj.class isMemberForClazz:clazz]) return nil;
    if(![toObj.class isMemberForClazz:clazz]) return nil;
    
    [PYArchiveObject iteratorWithObject:fromObj clazz:clazz userInfo:toObj blockExcute:^(NSObject * _Nonnull object, NSString * _Nonnull keyName, const char * _Nonnull typeEncoding, id  _Nonnull userInfo, BOOL isIvar) {
        NSObject * fromObj = object;
        NSObject * toObj = userInfo;
        id value = [fromObj valueForKey:keyName];
        if(!value){
            [toObj setValue:nil forKeyPath:keyName];
            return;
        }
        if([PYArchiveParse canParset:[value class]]){
            [toObj setValue:value forKeyPath:keyName];
            return;
        }
        if([value isKindOfClass:[NSDictionary class]]){
            NSDictionary * toValue = [toObj valueForKey:keyName];
            if(toValue == nil) toValue = [NSMutableDictionary new];
            toValue = (NSDictionary *)[PYObjectCopy copyValueWithClass:[value class] fromObj:value toObj:toValue];//[self copyValueFromObj:value toObj:toValue];
            [toObj setValue:toValue forKey:keyName];
            return;
        }
        if([value isKindOfClass:[NSArray class]]){
            NSArray * toValues = [toObj valueForKey:keyName];
            if(toValues == nil) toValues = [NSMutableArray new];
            toValues = [self copyArrayFromObjs:value toObjs:toValues];
            [toObj setValue:toValues forKeyPath:keyName];
            return;
        }
        if([value isKindOfClass:[NSSet class]]){
            NSSet * toValues = [toObj valueForKey:keyName];
            if(toValues == nil) toValues = [NSMutableSet new];
            toValues = [self copySetFromObjs:value toObjs:toValues];
            [toObj setValue:toValues forKeyPath:keyName];
            return;
        }
        id toValue = [toObj valueForKey:keyName];
        if(toValue == nil) toValue = [[value class] new];
        toValue = [self copyValueWithClass:[value class] fromObj:value toObj:toValue];
        [toObj setValue:toValue forKey:keyName];
    }];
//    unsigned int outCount2;
//    Ivar *ivars = class_copyIvarList(clazz, &outCount2);
//    for (int i = 0; i < outCount2; i++) {
//        Ivar ivar = ivars[i];
//        NSString * keyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
//        id value = [fromObj valueForKey:keyName];
//        if(!value) continue;
//        if([PYArchiveParse canParset:[value class]]){
//            [toObj setValue:value forKey:keyName];
//            continue;
//        }
//        if([value isKindOfClass:[NSDictionary class]]){
//            NSDictionary * toValue = [toObj valueForKey:keyName];
//            if(toValue == nil) toValue = [NSMutableDictionary new];
//            toValue = (NSDictionary *)[PYObjectCopy copyValueWithClass:[value class] fromObj:value toObj:toValue];//[self copyValueFromObj:value toObj:toValue];
//            [toObj setValue:toValue forKey:keyName];
//            continue;
//        }
//        if([value isKindOfClass:[NSArray class]]){
//            NSArray * toValues = [toObj valueForKey:keyName];
//            if(toValues == nil) toValues = [NSMutableArray new];
//            toValues = [self copyArrayFromObjs:value toObjs:toValues];
//            [toObj setValue:toValues forKey:keyName];
//            continue;
//        }
//        if([value isKindOfClass:[NSSet class]]){
//            NSSet * toValues = [toObj valueForKey:keyName];
//            if(toValues == nil) toValues = [NSMutableSet new];
//            toValues = [self copySetFromObjs:value toObjs:toValues];
//            [toObj setValue:toValues forKey:keyName];
//            continue;
//        }
//        id toValue = [toObj valueForKey:keyName];
//        if(toValue == nil) toValue = [[value class] new];
//        toValue = [self copyValueWithClass:[value class] fromObj:value toObj:toValue];
//        [toObj setValue:toValue forKey:keyName];
//    }
    return toObj;
}
+(nullable NSArray *) copyArrayFromObjs:(nonnull NSArray *) fromObjs toObjs:(nonnull NSArray *) toObjs{
    if(![fromObjs isKindOfClass:[NSArray class]]) return nil;
    if(![toObjs isKindOfClass:[NSArray class]]) return nil;
    while (toObjs.count > fromObjs.count && [toObjs isKindOfClass:[NSMutableArray class]]) {
        [((NSMutableArray *) toObjs)  removeObject:toObjs.lastObject];
    }
    
    for (int i = 0; i < fromObjs.count; i++) {
        if(i >= toObjs.count){
            if([toObjs isKindOfClass:[NSMutableArray class]]){
                [((NSMutableArray *)toObjs) addObject:[fromObjs[i] deepCopyObject]];
            }else break;
        }
        NSObject * toObj = toObjs[i];
        NSObject * fromObj = fromObjs[i];
        [NSObject copyValueFromObj:fromObj toObj:toObj];
    }
    return toObjs;
}
+(nullable NSSet *) copySetFromObjs:(nonnull NSSet *) fromObjs toObjs:(nonnull NSSet *) toObjs{
    if(![fromObjs isKindOfClass:[NSSet class]]) return nil;
    if(![toObjs isKindOfClass:[NSSet class]]) return nil;
    while (toObjs.count > fromObjs.count && [toObjs isKindOfClass:[NSMutableSet class]]) {
        [((NSMutableSet *) toObjs)  removeObject:toObjs.anyObject];
    }
    
    NSArray * array = toObjs.allObjects;
    int i = 0;
    for (id fromObj in fromObjs) {
        if(i >= toObjs.count){
            if([toObjs isKindOfClass:[NSMutableSet class]]){
                [((NSMutableSet *)toObjs) addObject:[fromObj deepCopyObject]];
            }else break;
        }
        NSObject * toObj = array[i];
        [NSObject copyValueFromObj:fromObj toObj:toObj];
        i++;
    }
    return toObjs;
}
@end
