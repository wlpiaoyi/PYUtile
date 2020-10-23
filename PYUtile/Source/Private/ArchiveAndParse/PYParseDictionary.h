//
//  PYParseDictionary.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYParseDictionary : NSObject

+(BOOL)getTypeEncoding:(char * *) typeEncoding clazz:(Class) clazz key:(NSString *) key;
+(char *) getTypeEncodingFromeProperty:(objc_property_t) property ivar:(Ivar) ivar;
+(nullable id) instanceClazz:(Class) clazz dictionary:(NSObject*) dictionary;

@end

NS_ASSUME_NONNULL_END
