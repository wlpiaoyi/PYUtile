//
//  PYArchiveObject.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PYArchiveObject : NSObject

+(void) iteratorWithObject:(nonnull NSObject *) object clazz:(nullable Class) clazz userInfo:(nullable id) userInfo blockExcute:(void (^_Nonnull)(NSObject * _Nonnull object, NSString * _Nonnull filedName, const char * _Nonnull typeEncoding, id _Nonnull userInfo, BOOL isIvar)) blockExcute;

+(nullable NSObject*) archvie:(nonnull NSObject *) object clazz:(nullable Class) clazz deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries;

@end


