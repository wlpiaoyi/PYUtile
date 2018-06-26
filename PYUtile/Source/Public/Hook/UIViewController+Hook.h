//
//  UIViewController+Hook.h
//  FrameWork
//
//  Created by wlpiaoyi on 15/9/1.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIResponder+Hook.h"
/**
 hook Controller method 的基础实体
 */
@interface UIViewController(hook)
+(BOOL) canExcuHookMethod:(UIViewController *) target;
+(BOOL) hookMethodWithName:(NSString*) name;

@end

