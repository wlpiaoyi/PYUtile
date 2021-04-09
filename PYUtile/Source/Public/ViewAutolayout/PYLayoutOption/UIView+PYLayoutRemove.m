//
//  UIView+PYLayoutRemove.m
//  PYUtile
//
//  Created by wlpiaoyi on 2021/4/4.
//  Copyright © 2021 wlpiaoyi. All rights reserved.
//

#import "UIView+PYLayoutRemove.h"
#import "UIView+PYLayoutGet.h"

@implementation UIView(PYLayoutRemove)


-(nullable NSLayoutConstraint *) py_removeLayoutTop{
    NSLayoutConstraint * lc = self.py_layoutTop;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutTopSafe{
    NSLayoutConstraint * lc = self.py_layoutTopSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutLeft{
    NSLayoutConstraint * lc = self.py_layoutLeft;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutLeftSafe{
    NSLayoutConstraint * lc = self.py_layoutLeftSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutBottom{
    NSLayoutConstraint * lc = self.py_layoutBottom;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutBottomSafe{
    NSLayoutConstraint * lc = self.py_layoutBottomSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutRight{
    NSLayoutConstraint * lc = self.py_layoutRight;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutRightSafe{
    NSLayoutConstraint * lc = self.py_layoutRightSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutLeading{
    NSLayoutConstraint * lc = self.py_layoutLeading;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutLeadingSafe{
    NSLayoutConstraint * lc = self.py_layoutLeadingSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutTrailing{
    NSLayoutConstraint * lc = self.py_layoutTrailing;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutTrailingSafe{
    NSLayoutConstraint * lc = self.py_layoutTrailingSafe;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}

-(nullable NSLayoutConstraint *) py_removeLayoutWidth{
    NSLayoutConstraint * lc = self.py_layoutWidth;
    if(!lc) return nil;
    [self removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutHeight{
    NSLayoutConstraint * lc = self.py_layoutHeight;
    if(!lc) return nil;
    [self removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutEqulesWidth{
    NSLayoutConstraint * lc = self.py_layoutEqulesWidth;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutEqulesHeight{
    NSLayoutConstraint * lc = self.py_layoutEqulesHeight;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}

-(nullable NSLayoutConstraint *) py_removeLayoutCenterX{
    NSLayoutConstraint * lc = self.py_layoutCenterX;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}
-(nullable NSLayoutConstraint *) py_removeLayoutCenterY{
    NSLayoutConstraint * lc = self.py_layoutCenterY;
    if(!lc) return nil;
    [self.superview removeConstraint:lc];
    return lc;
}

-(nullable NSLayoutConstraint *) py_removeLayoutAspect{
    NSLayoutConstraint * lc = self.py_layoutAspect;
    if(!lc) return nil;
    [self removeConstraint:lc];
    return lc;
}

-(nullable NSArray<NSLayoutConstraint *> *) py_removeAllLayout{
    NSMutableArray<NSLayoutConstraint *> * lcs = [NSMutableArray new];
    NSLayoutConstraint * lc;
    
    if (@available(iOS 11.0, *)) {
        
        lc = [self py_removeLayoutTopSafe];
        if(lc) [lcs addObject:lc];
        
        lc = [self py_removeLayoutLeftSafe];
        if(lc) [lcs addObject:lc];
        
        lc = [self py_removeLayoutBottomSafe];
        if(lc) [lcs addObject:lc];
        
        lc = [self py_removeLayoutRightSafe];
        if(lc) [lcs addObject:lc];
        
        lc = [self py_removeLayoutLeadingSafe];
        if(lc) [lcs addObject:lc];
        
        lc = [self py_removeLayoutTrailingSafe];
        if(lc) [lcs addObject:lc];
        
    }
    
    lc = [self py_removeLayoutTop];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutLeft];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutBottom];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutRight];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutLeading];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutTrailing];
    if(lc) [lcs addObject:lc];

    lc = [self py_removeLayoutWidth];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutHeight];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutEqulesWidth];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutEqulesHeight];
    if(lc) [lcs addObject:lc];
    

    lc = [self py_removeLayoutCenterX];
    if(lc) [lcs addObject:lc];
    
    lc = [self py_removeLayoutCenterY];
    if(lc) [lcs addObject:lc];
    

    lc = [self py_removeLayoutAspect];
    if(lc) [lcs addObject:lc];
    
    return lcs.count ? lcs : nil;
}

@end
