//
//  UIResponder+Hook.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/7/11.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "UIResponder+Hook.h"
#import "PYUtile.h"
#import <objc/runtime.h>
#import <objc/message.h>

void * UIResponderHookParamDictPointer = &UIResponderHookParamDictPointer;

@implementation UIResponder(Hook)

-(void) myDealloc{
    
}

+(nonnull NSMutableDictionary *) paramsDictForHookExpand{
    NSMutableDictionary * paramsDict = objc_getAssociatedObject([UIResponder class], UIResponderHookParamDictPointer);
    if(paramsDict == nil) {
        paramsDict = [NSMutableDictionary new];
        objc_setAssociatedObject([UIResponder class], UIResponderHookParamDictPointer, paramsDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return paramsDict;
}
+(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    return [self paramsDictForHookExpand][@"delegateBase"];
}
+(void) setDelegateBase:(nullable NSHashTable<id<UIResponderHookBaseDelegate>> *) delegateBase{
    [self paramsDictForHookExpand][@"delegateBase"] = delegateBase;
}

-(void) exchangeDealloc{
    NSHashTable<id<UIResponderHookBaseDelegate>> * delegates = [self.class delegateBase];
    for (id<UIResponderHookBaseDelegate> delegate in delegates){
        if (delegate && [delegate respondsToSelector:@selector(beforeExcuteDeallocWithTarget:)]) {
            [delegate beforeExcuteDeallocWithTarget:self];
        }
    }
    objc_removeAssociatedObjects(self);
    if([self canResignFirstResponder])
        [self resignFirstResponder];
    [self exchangeDealloc];
}
///<== exchangeMethods
+(BOOL) hookWithMethodNames:(nullable NSArray<NSString *> *) methodNames{
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        SEL sel = sel_getUid("dealloc");
        Class responderClazz = [UIResponder class];
        IMP imp = class_getMethodImplementation(responderClazz, sel);
        IMP superImp = class_getMethodImplementation(class_getSuperclass(responderClazz), sel);
        if(imp == superImp){
            SEL mySel = @selector(myDealloc);
            IMP myImp = class_getMethodImplementation(responderClazz, mySel);
            Method myMethod = class_getInstanceMethod(responderClazz, mySel);
            class_replaceMethod(self, sel, myImp, method_getTypeEncoding(myMethod));
        }
        [UIResponder hookMethodWithName:@"dealloc"];
        [UIResponder setDelegateBase:[NSHashTable<id<UIResponderHookBaseDelegate>> weakObjectsHashTable]];
    });
    if (!methodNames) {
        return false;
    }
    @synchronized([self class]){
        for (NSString *methodName in methodNames) {
            if([self hookMethodWithName:methodName]){
                NSLog(@"%@ hook Success",methodName);
            }else{
                NSLog(@"%@ hook Faild",methodName);
            }
        }
    }
    return true;
}

+(BOOL) hookMethodWithName:(NSString*) name{
    SEL orgSel = sel_getUid(name.UTF8String);
    
    SEL exchangeSel =  sel_getUid([NSString stringWithFormat:@"exchange%@%@",[[name substringToIndex:1] uppercaseString], [name substringFromIndex:1]].UTF8String);
    IMP exchangeIMP = class_getMethodImplementation(self, exchangeSel);
    IMP orgIMP = class_getMethodImplementation(self, orgSel);
    IMP gmf = (IMP)_objc_msgForward;
    if(exchangeIMP == gmf || orgIMP == gmf){
        return false;
    }
    
    Class superClazz = class_getSuperclass(self);
    IMP superOrgIMP = class_getMethodImplementation(superClazz, orgSel);
    IMP superExchangeIMP = class_getMethodImplementation(superClazz, exchangeSel);
    
    if(superOrgIMP != gmf && superExchangeIMP != gmf && superOrgIMP == orgIMP){
        return [superClazz hookMethodWithName:name];;
    }
    
    Method orgMethod = class_getInstanceMethod(self, orgSel);
    Method exchangeMethod = class_getInstanceMethod(self, exchangeSel);
    class_replaceMethod(self, orgSel, exchangeIMP, method_getTypeEncoding(orgMethod));
    class_replaceMethod(self, exchangeSel, orgIMP, method_getTypeEncoding(exchangeMethod));
    return true;
}


@end
