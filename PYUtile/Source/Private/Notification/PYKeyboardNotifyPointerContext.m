//
//  PYKeyboardNotifyPointerContext.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYKeyboardNotifyPointerContext.h"
#import "PYKeyboardNotificationObject.h"

@implementation PYKeyboardNotifyPointerContext

-(instancetype) initWithResponder:(nullable UIResponder *) responder{
    self = [super init];
    self.responder = responder;
    return self;
}

-(void) dealloc{
    [[PYKeyboardNotificationObject shareObject] removeNoitfyContext:self];
}
@end
