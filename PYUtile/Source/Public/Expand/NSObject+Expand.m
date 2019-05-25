//
//  NSobject+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/5.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSObject+Expand.h"
#import "PYArchiveParse.h"

//常见警告的名称
//1, 声明变量未使用  "-Wunused-variable"
//2, 方法定义未实现  "-Wincomplete-implementation"
//3, 未声明的选择器  "-Wundeclared-selector"
//4, 参数格式不匹配  "-Wformat"
//5, 废弃掉的方法     "-Wdeprecated-declarations"
//6, 不会执行的代码  "-Wunreachable-code"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation NSObject(toDictionary)
/**
 当前Class是否是指定的class
 0：不是
 1：同类型
 2：子类
 */
+(int) isMemberForClazz:(nonnull Class) memberForClazz{
    return [PYArchiveParse clazz:self isMemberForClazz:memberForClazz];
}
/**
 是否是本地库的Class
 */
+(BOOL) isNativelibraryClass{
   return  [NSBundle bundleForClass:self] != NSBundle.mainBundle;
}


@end

#pragma clang diagnostic pop
