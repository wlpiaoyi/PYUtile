//
//  PYUncaughtExceptionHandler.m
//  PYUEH
//
//  Created by wlpiaoyi on 16/5/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYUncaughtExceptionHandler.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "PYUtile.h"
#import "NSData+Expand.h"

NSString * PYUncaughtExceptionHandlerLogUrl;

PYUncaughtExceptionHandler * xPYUncaughtExceptionHandler;

NSString * const PYUncaughtExceptionHandlerSignalExceptionName = @"PYUncaughtExceptionHandlerSignalExceptionName";
NSString * const PYUncaughtExceptionHandlerSignalKey = @"PYUncaughtExceptionHandlerSignalKey";
NSString * const PYUncaughtExceptionHandlerAddressesKey = @"PYUncaughtExceptionHandlerAddressesKey";
NSString * const PYUncaughtExceptionHandlerLogpathKey = @"PYUncaughtExceptionHandlerLogpathKey";

volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

@implementation PYUncaughtExceptionHandler{
@private
    bool dismissed;
}
+(void) initialize{
#ifdef DEBUG
    PYUncaughtExceptionHandlerLogUrl = (NSString *)documentDir;
#else
    PYUncaughtExceptionHandlerLogUrl = [NSString stringWithFormat:@"%@/erro",cachesDir];
    BOOL isDirectory;
    if (![[NSFileManager defaultManager] fileExistsAtPath:PYUncaughtExceptionHandlerLogUrl isDirectory:&isDirectory] || !isDirectory) {
        NSError * error;
        [[NSFileManager defaultManager] createDirectoryAtPath:PYUncaughtExceptionHandlerLogUrl withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSAssert(NO, @"%@",error);
        }
    }
#endif
}
+(nonnull NSString *) getExceptionPath{
    return PYUncaughtExceptionHandlerLogUrl;
}

+ (NSArray *)backtrace{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0;  i <   frames; i++){
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex{
    if (anIndex == 0){
        dismissed = YES;
    }
}

- (void)handleException:(NSException *)exception{
    if(self.blockExceptionHandle){
        self.blockExceptionHandle(exception, &dismissed);
    }else{
        NSMutableString * callStackSymbolMutable = [NSMutableString stringWithFormat:@"%@:%@\n{\n",exception.name, exception.reason];
        for (NSString * callStackSymbol in exception.callStackSymbols) {
            [callStackSymbolMutable appendString:callStackSymbol];
            [callStackSymbolMutable appendString:@"\n"];
        }
        [callStackSymbolMutable appendString:@"}"];
        kPrintErrorln("%s",callStackSymbolMutable.UTF8String);
        NSString * message = [NSString stringWithFormat:NSLocalizedString(
                                                                          @"非常抱歉您可以继续使用，但是程序可能出问题\n\n原因如下:\n%@\n%@", nil),
                              callStackSymbolMutable,
                              [[exception userInfo] objectForKey:PYUncaughtExceptionHandlerAddressesKey]];
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:NSLocalizedString(@"程序异常", nil)
         message: message
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"退出", nil)
         otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
        [alert show];
    }
    
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed){
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:PYUncaughtExceptionHandlerSignalExceptionName]){
        kill(getpid(), [[[exception userInfo] objectForKey:PYUncaughtExceptionHandlerSignalKey] intValue]);
    }else{
        [exception raise];
    }
}
@end

void PYHandleException(NSException *exception){
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum){
        return;
    }
    NSMutableString * callStackSymbolMutable = [NSMutableString stringWithFormat:@"%@:%@\n{\n",exception.name, exception.reason];
    for (NSString * callStackSymbol in exception.callStackSymbols) {
        [callStackSymbolMutable appendString:callStackSymbol];
        [callStackSymbolMutable appendString:@"\n"];
    }
    [callStackSymbolMutable appendString:@"}"];
    NSString *logUrl = [NSString stringWithFormat:@"%@/%@_Detail.log",PYUncaughtExceptionHandlerLogUrl, [NSString stringWithFormat:@"crash%@",[NSDate date]]];
    FILE *f = fopen(logUrl.UTF8String,"wb+");
    const char * callStackSymbolChars = callStackSymbolMutable.UTF8String;
    NSUInteger length = callStackSymbolMutable.length;
    for (int i = 0; i < length; i++) {
        char c = callStackSymbolChars[i];
        fputc(c, f);
    }
    fclose(f);
    [xPYUncaughtExceptionHandler
     performSelectorOnMainThread:@selector(handleException:)
     withObject:exception
     waitUntilDone:YES];
}

void PYSignalHandler(int signal){
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum){
        return;
    }
    
    NSMutableDictionary *userInfo =
    [NSMutableDictionary
    dictionaryWithObject:[NSNumber numberWithInt:signal]
     forKey:PYUncaughtExceptionHandlerSignalKey];
//    NSString *logName = [NSString stringWithFormat:@"crash%@",[NSDate date]];;
    NSArray *callStack = [PYUncaughtExceptionHandler backtrace];
    [userInfo
     setObject:callStack
     forKey:PYUncaughtExceptionHandlerAddressesKey];
    
    [xPYUncaughtExceptionHandler
     performSelectorOnMainThread:@selector(handleException:)
     withObject:
     [NSException
      exceptionWithName:PYUncaughtExceptionHandlerSignalExceptionName
      reason:
      [NSString stringWithFormat:
       NSLocalizedString(@"Signal %d was raised.", nil),
       signal]
      userInfo:
      [NSDictionary
       dictionaryWithObject:[NSNumber numberWithInt:signal]
       forKey:PYUncaughtExceptionHandlerSignalKey]]
     waitUntilDone:YES];
}

PYUncaughtExceptionHandler * PYInstallUncaughtExceptionHandler(void){
    xPYUncaughtExceptionHandler = [PYUncaughtExceptionHandler new];
    NSSetUncaughtExceptionHandler(&PYHandleException);
    signal(SIGABRT, PYSignalHandler);
    signal(SIGILL, PYSignalHandler);
    signal(SIGSEGV, PYSignalHandler);
    signal(SIGFPE, PYSignalHandler);
    signal(SIGBUS, PYSignalHandler);
    signal(SIGPIPE, PYSignalHandler);
    return xPYUncaughtExceptionHandler;
}
