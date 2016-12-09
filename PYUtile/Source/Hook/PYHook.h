//
//  PYHook.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/12/14.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYHook : NSObject
+(BOOL) mergeHookInstanceWithTarget:(nonnull Class) target action:(nonnull SEL) action blockBefore:(BOOL (^ _Nonnull) (NSInvocation * _Nonnull invoction)) blockBefore blockAfter:(void (^ _Nonnull) (NSInvocation * _Nonnull invoction)) blockAfter;
+(BOOL) removeHookInstanceWithTarget:(nonnull Class) target action:(nonnull SEL) action;
@end
