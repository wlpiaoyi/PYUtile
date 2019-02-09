//
//  PYArchive.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern id _Nullable (^ _Nullable PYBlockValueParsetoObject) (NSObject * _Nonnull value, Class _Nonnull clazz);

@interface PYArchiveObject : NSObject
+(NSObject*) archvie:(nonnull NSObject *) object clazz:(nullable Class) clazz deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries;
+(nullable NSObject *) archvieForDict:(nonnull NSMutableDictionary *) dict object:(nonnull NSObject *) object varName:(NSString *) varName typeEncoding:(const char *) typeEncoding;
@end

NS_ASSUME_NONNULL_END
