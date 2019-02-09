//
//  PYUncaughtExceptionHandler.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/5/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull const PYUncaughtExceptionHandlerSignalExceptionName;
extern NSString * _Nonnull const PYUncaughtExceptionHandlerSignalKey;
extern NSString * _Nonnull const PYUncaughtExceptionHandlerAddressesKey;

@interface PYUncaughtExceptionHandler : NSObject
@property (nonatomic, copy, nullable) void (^blockExceptionHandle)(NSException * _Nonnull exception, bool * _Nonnull dismissedPointer);
+(nonnull NSString *) getExceptionPath;
@end
PYUncaughtExceptionHandler * _Nonnull PYInstallUncaughtExceptionHandler(void);
