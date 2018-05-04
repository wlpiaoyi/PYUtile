//
//  UIResponder+pydealloc.m
//  PYUtile
//
//  Created by wlpiaoyi on 2018/4/28.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "UIResponder+pydealloc.h"
#import "UIResponder+Hook.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIResponder(pydealloc)
-(void) myDealloc{
    
}

-(void) exchangeDealloc{
    Class clazz = self.class;
    if([NSBundle bundleForClass:clazz] != [NSBundle mainBundle] && clazz != [UIView class]) {
        [self exchangeDealloc];
        return;
    }
    NSHashTable<id<UIResponderHookBaseDelegate>> * delegates = [self.class delegateBase];
    for (id<UIResponderHookBaseDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDeallocWithTarget:)]) {
            [delegate beforeExcuteDeallocWithTarget:self];
        }
    }
    objc_removeAssociatedObjects(self);
    if([self canResignFirstResponder]) [self resignFirstResponder];
    [self exchangeDealloc];
}
@end
