//
//  NSObject+__PYHook_Private.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/5/20.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYUtile.h"

@interface __UIResponderHookParamPointerContext : NSObject
kPNSNA NSHashTable * delegateBase;
kPNSNA NSHashTable * delegateViews;
kPNSNA NSHashTable * delegateOrientations;
kPNSNA NSMutableArray * delegateViewsTemp;
kPNSNA NSMutableArray * delegateOrientationsTemp;
@end

@interface NSObject(__PYHook_Private)

+(nonnull __UIResponderHookParamPointerContext *) __paramsDictForHookExpand;

@end

