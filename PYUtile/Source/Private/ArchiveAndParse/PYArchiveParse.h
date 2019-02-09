//
//  PYArchiveParset.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYArchiveParse : NSObject
@property id (^block) (NSObject * value, Class clazz);
+(BOOL) canParset:(Class) clazz;
+(int) clazz:(nonnull Class) clazz isMemberForClazz:(nonnull Class) memberForClazz;
+(nullable NSObject *) parseValue:(nonnull NSObject *) value clazz:(nonnull Class) clazz;
+(nullable NSObject *) valueArchive:(nonnull NSObject *) value clazz:(nullable Class) clazz;
+(nullable Class) classFromTypeEncoding:(const char *) typeEncoding;
+(nonnull NSString *) checkVarKey:(nonnull NSString *) name;

@end

NS_ASSUME_NONNULL_END
