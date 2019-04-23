//
//  PYObjectCopy.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/4/19.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYObjectCopy : NSObject

+(nullable NSObject *) copyValueWithClass:(Class) clazz fromObj:(nonnull NSObject *) fromObj toObj:(nonnull NSObject *) toObj;
+(nullable NSArray *) copyArrayFromObjs:(nonnull NSArray *) fromObjs toObjs:(nonnull NSArray *) toObjs;
+(nullable NSSet *) copySetFromObjs:(nonnull NSSet *) fromObjs toObjs:(nonnull NSSet *) toObjs;
@end

NS_ASSUME_NONNULL_END
