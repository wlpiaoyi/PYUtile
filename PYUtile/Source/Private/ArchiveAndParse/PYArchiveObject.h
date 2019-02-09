//
//  PYArchiveObject.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYArchiveObject : NSObject
+(NSObject*) archvie:(nonnull NSObject *) object clazz:(nullable Class) clazz deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries;
@end

NS_ASSUME_NONNULL_END

