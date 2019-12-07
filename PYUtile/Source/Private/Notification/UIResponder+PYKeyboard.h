//
//  UIResponder+PYKeyboard.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYKeyboardNotifyPointerContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder(PYKeyboard)
@property (nonatomic, readonly) PYKeyboardNotifyPointerContext * pykeyboroard_pointerContext;
-(void) addPYKeyboroard_pointerContext;
-(void) removePYKeyboroard_pointerContext;
@end

NS_ASSUME_NONNULL_END
