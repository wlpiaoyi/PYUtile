//
//  PYDataFunction.h
//  PYUtile
//
//  Created by piaoyi wl on 2024/4/30.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYDataFunction : NSObject


+(long) data16To10:(const char *) value;

+(long) data2To10:(const char *) value;

@end

NS_ASSUME_NONNULL_END
