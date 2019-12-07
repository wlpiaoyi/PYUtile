//
//  PYKeyboardNotifyPointerContext.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/4.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pyutilea.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYKeyboardNotifyPointerContext : NSObject
kPNANA UIResponder * responder;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE showBeginKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedDoing showDoingKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE showEndKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE hiddenBeginKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedDoing hiddenDoingKeyboarAnimation;
@property (nonatomic, nullable, copy) BlockKeyboardAnimatedBE hiddenEndKeyboarAnimation;
-(instancetype) initWithResponder:(nullable UIResponder *) responder;
@end


NS_ASSUME_NONNULL_END
