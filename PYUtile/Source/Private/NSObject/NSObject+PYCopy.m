//
//  NSObject+PYCopy.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/4/30.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "NSObject+PYCopy.h"
#import "PYObjectCopy.h"
#import <objc/runtime.h>
#import "NSObject+PYExpand.h"

@implementation NSObject(PYCopy)
/**
 复制对象
 */
-(nullable instancetype) deepCopyObject;{
    id objCopy = [self.class new];
    objCopy = [self.class copyValueFromObj:self toObj:objCopy];
    return objCopy;
}

/**
 复制同一类型 对象值到另一个对象
 */
+(nullable NSObject *) copyValueFromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj{
    Class clazz = toObj.class;
    int isM = 0;
    while ((isM = [clazz isMemberForClazz:self]) && clazz != [NSObject class]) {
        if(![fromObj isKindOfClass:clazz] || ! [toObj isKindOfClass:clazz]) continue;
        toObj = [PYObjectCopy copyValueWithClass:clazz fromObj:fromObj toObj:toObj];
        if(isM <= 1) break;
        clazz = class_getSuperclass(clazz);
    }
    return toObj;
}

@end
