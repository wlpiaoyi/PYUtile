//
//  PYConstraintMaker.m
//  PYUtile
//
//  Created by wlpiaoyi on 2020/8/5.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYConstraintMaker.h"

@interface PYConstraint()

kPNRNA UIView * toItem;
kPNAR CGFloat value;
kPNAR BOOL isSafe;
kPNAR BOOL isReversal;
kPNA BOOL isInstall;

kPNA PYConstraintMaker * maker;

@end

@implementation PYConstraint

@synthesize width, height,centerX, centerY, top, bottom, left, right;

+(instancetype) instanceWithMaker:(nonnull PYConstraintMaker *) maker{
    PYConstraint * contraint = [PYConstraint new];
    contraint.maker = maker;
    return contraint;
}

-(instancetype) init{
    if(self = [super init]){
        _value = 0;
        _isSafe = NO;
        _isInstall = NO;
        _isReversal = NO;
    }
    return self;
}

- (nonnull PYConstraintMaker* (^)(id value)) py_constant{
    kAssign(self);
    return ^PYConstraintMaker *(id value) {
        kStrong(self);
        self->_value = ((NSNumber *)value).doubleValue;
        [self __synConstraints];
        return self.maker;
    };
}

- (nonnull PYConstraint* (^)(id inArea)) py_inArea{
    kAssign(self);
    return ^PYConstraint *(id inArea) {
        kStrong(self);
        self->_isSafe = ((NSNumber *)inArea).boolValue;
        [self __synConstraints];
        return self;
    };
}


- (nonnull PYConstraint* (^)(UIView * toItem)) py_toItem{
    kAssign(self);
    return ^id(UIView * toItem) {
        kStrong(self);
        self->_toItem = toItem;
        [self __synConstraints];
        return self;
    };
}

#pragma mark 布局参考对象,反转
#pragma mark 布局参考对象,反转
- (nonnull PYConstraint* (^)(id isReversal)) py_toReversal;{
    kAssign(self);
    return ^id(id isReversal) {
        kStrong(self);
        self->_isReversal = isReversal && ((NSNumber *)isReversal).boolValue;
        [self __synConstraints];
        return self;
    };
}

-(NSMutableArray<PYConstraint *> *) __synConstraints{
    self.isInstall = YES;
    NSMutableArray<PYConstraint *> * constraints = [NSMutableArray new];
    PYConstraint * constrain = width;
    [self __synConstraint:constrain name:@"width" constraints:constraints];
    constrain = height;
    [self __synConstraint:constrain name:@"height" constraints:constraints];
    constrain = bottom;
    [self __synConstraint:constrain name:@"bottom" constraints:constraints];
    constrain = centerX;
    [self __synConstraint:constrain name:@"centerX" constraints:constraints];
    constrain = centerY;
    [self __synConstraint:constrain name:@"centerY" constraints:constraints];
    constrain = top;
    [self __synConstraint:constrain name:@"top" constraints:constraints];
    constrain = bottom;
    [self __synConstraint:constrain name:@"bottom" constraints:constraints];
    constrain = left;
    [self __synConstraint:constrain name:@"left" constraints:constraints];
    constrain = right;
    [self __synConstraint:constrain name:@"right" constraints:constraints];
    self.isInstall = NO;
    return constraints;
}

-(void) __synConstraint:(PYConstraint *) constrain name:(NSString *) name constraints:(NSMutableArray<PYConstraint *> *) constraints{
    if(!constrain) return;
    if(constrain == self) return;
    [self.maker setValue:constrain forKey:name];
    constrain->_value = self->_value;
    constrain->_toItem = self->_toItem;
    constrain->_isSafe = self->_isSafe;
    constrain->_isReversal = self->_isReversal;
    [constraints addObject:constrain];
}

-(PYConstraint *) width{
    if(!_isInstall && width == nil){
        width = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) height{
    if(!_isInstall && height == nil){
        height = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) centerY{
    if(!_isInstall && centerY == nil){
        centerY = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) centerX{
    if(!_isInstall && centerX == nil){
        centerX = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}


-(PYConstraint *) top{
    if(!_isInstall && top == nil){
        top = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) bottom{
    if(!_isInstall && bottom == nil){
        bottom = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) left{
    if(!_isInstall && left == nil){
        left = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

-(PYConstraint *) right{
    if(!_isInstall && right == nil){
        right = [PYConstraint instanceWithMaker:self.maker];
    }
    return self;
}

@end


@interface PYConstraintMaker()
kPNA BOOL isInstall;
@end

@implementation PYConstraintMaker

@synthesize width, height,centerX, centerY, top, bottom, left, right;

-(instancetype) init{
    if(self = [super init]){
        self.isInstall = NO;
    }
    return self;
}


-(PYConstraint *) width{
    if(!_isInstall && width == nil){
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
