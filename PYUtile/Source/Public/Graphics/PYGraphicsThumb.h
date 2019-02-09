//
//  PYGraphicsThumb.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/30.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockGraphicsLayerDraw)(CGContextRef _Nonnull ctx, id _Nullable userInfo);

@interface PYGraphicsThumb : NSObject
+(nonnull instancetype) graphicsThumbWithView:(nonnull UIView*) view block:(nullable blockGraphicsLayerDraw) block;
-(nonnull CALayer *) executDisplay:(nullable id) userInfo;
@end
