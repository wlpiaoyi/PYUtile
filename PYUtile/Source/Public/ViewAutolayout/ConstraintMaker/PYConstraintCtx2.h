//
//  PYConstraintCtx2.h
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/7.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYConstraintCtx2 : NSObject

@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign, nullable) id firstTarget;
@property (nonatomic, assign, nullable) NSLayoutAnchor  * firstAnchor;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign, nullable) id secondTarget;
@property (nonatomic, assign, nullable) NSLayoutAnchor * secondAnchor;
@property (nonatomic, assign) CGFloat secondValue;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;

-(instancetype) initTopWithView:(UIView *) view;
-(instancetype) initSafeTopWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0));

-(instancetype) initLeftWithView:(UIView *) view;
-(instancetype) initSafeLeftWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0));

-(instancetype) initBottomWithView:(UIView *) view;
-(instancetype) initSafeBootomtWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0));

-(instancetype) initRightWithView:(UIView *) view;
-(instancetype) initSafeRightWithView:(UIView *) view API_AVAILABLE(ios(11.0),tvos(11.0));



-(nullable NSLayoutConstraint *) layoutConstraint;

@end

NS_ASSUME_NONNULL_END
