//
//  UIButton+PYExpand.h
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/3.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton(PYExpand)
/**
 将button的image和title纵向显示
 #param offH:间距
 #param maxHeight:imageSize.height的最大高度，主要用于多个button的image 和 title 的协调
 #param direction:0 title在上 1 title在下
 */
-(void) parseImagetitleForOffH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction;
-(void) parseImagetitleForOffH:(CGFloat) offH maxHeight:(CGFloat) maxHeight offTop:(CGFloat) offTop direction:(short) direction;

@end

NS_ASSUME_NONNULL_END
