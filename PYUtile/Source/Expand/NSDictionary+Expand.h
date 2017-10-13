//
//  NSDictionary+Expand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Expand)
-(nullable NSData *) toData;
+(nullable id) checkDict:(nullable id) value;
@end
@interface NSMutableDictionary(Expand)
-(void) setWeakValue:(nullable id)value forKey:(nonnull NSString *)key;
-(nonnull id) weakValueForKey:(nonnull NSString *) key;
@end
