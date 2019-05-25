//
//  NSObject+PYCopy.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/4/30.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(PYCopy)

#pragma 复制对象=========================================>
/**
 复制对象
 */
-(nullable instancetype) deepCopyObject;
/**
 (同一类型)复制对象值到另一个对象
 */
+(nullable NSObject *) copyValueFromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj;
#pragma 复制对象=========================================<

@end

