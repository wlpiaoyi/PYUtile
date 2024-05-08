//
//  PYHookEncodeType.h
//  PYUtile
//
//  Created by piaoyi wl on 2024/4/28.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYHookEncodeType : NSObject

+(char *) copyChars:(const char *) charCopy startIndex:(size_t) startIndex endIndex:(size_t) endIndex;

@end

NS_ASSUME_NONNULL_END
