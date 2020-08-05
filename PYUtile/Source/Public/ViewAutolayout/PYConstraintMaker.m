//
//  PYConstraintMaker.m
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/5.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYConstraintMaker.h"

@interface PYConstraint()
kPNA PYConstraintMaker * maker;
@end

@implementation PYConstraint

+(instancetype) instanceWithMaker:(nonnull PYConstraintMaker *) maker{
    PYConstraint * contraint = [PYConstraint new];
    contraint.maker = maker;
    return contraint;
}

- (nonnull PYConstraintMaker* (^)(id value)) py_constant{
    kAssign(self);
    return ^PYConstraintMaker *(id value) {
        kStrong(self);
        self->_value = ((NSNumber *)value).doubleValue;
        return self.maker;
    };
}

- (nonnull PYConstraint* (^)(BOOL isSafe)) py_inSafe{
    kAssign(self);
    return ^PYConstraint *(BOOL isSafe) {
        kStrong(self);
        self->_isSafe = isSafe;
        return self;
    };
    
}

- (nonnull PYConstraint* (^)(UIView * toItem)) py_toItem{
    kAssign(self);
    return ^id(UIView * toItem) {
        kStrong(self);
        self->_toItem = toItem;
        return self;
    };
}

@end


@interface PYConstraintMaker()
kPNA UIView * view;
kPNA BOOL isInstall;
@end

@implementation PYConstraintMaker
@synthesize width, height,centerX, centerY, top, bottom, left, right;
+(instancetype) instanceWithView:(nonnull UIView *) view{
    PYConstraintMaker * maker = [PYConstraintMaker new];
    maker.view = view;
    maker.isInstall = NO;
    return maker;
}


-(PYConstraint *) width{
    if(!_isInstall &&  width == nil){
        width = [PYConstraint instanceWithMaker:self];
    }
    return width;
}

-(PYConstraint *) height{
    if(!_isInstall &&  height == nil){
        height = [PYConstraint instanceWithMaker:self];
    }
    return height;
}

-(PYConstraint *) centerY{
    if(!_isInstall &&  centerY == nil){
        centerY = [PYConstraint instanceWithMaker:self];
    }
    return centerY;
}

-(PYConstraint *) centerX{
    if(!_isInstall &&  centerX == nil){
        centerX = [PYConstraint instanceWithMaker:self];
    }
    return centerX;
}


-(PYConstraint *) top{
    if(!_isInstall &&  top == nil){
        top = [PYConstraint instanceWithMaker:self];
    }
    return top;
}

-(PYConstraint *) bottom{
    if(!_isInstall &&  bottom == nil){
        bottom = [PYConstraint instanceWithMaker:self];
    }
    return bottom;
}

-(PYConstraint *) left{
    if(!_isInstall &&  left == nil){
        left = [PYConstraint instanceWithMaker:self];
    }
    return left;
}

-(PYConstraint *) right{
    if(!_isInstall &&  right == nil){
        right = [PYConstraint instanceWithMaker:self];
    }
    return right;
}

@end
