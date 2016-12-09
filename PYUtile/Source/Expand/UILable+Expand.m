//
//  UILable+Convenience.m
//  超级考研
//
//  Created by wlpiaoyi on 14-9-11.
//  Copyright (c) 2014年 wlpiaoyi. All rights reserved.
//

#import "UILable+Expand.h"
#import "UIView+Expand.h"
#import "PYUtile.h"
@implementation  UILabel(Expand)

-(void) automorphismHeight{
    self.numberOfLines = 0;
    CGSize s = self.frameSize;
    CGSize sx = [PYUtile getBoundSizeWithTxt:self.text font:self.font size:CGSizeMake(s.width, 9999)];
    sx.width = s.width;
    int width = sx.width;
    int height = sx.height+1;
    sx.width = width;
    sx.height = height;
    self.frameSize = sx;
}
-(void) automorphismWidth{
    CGSize s = self.frameSize;
    CGSize sx = CGSizeMake(0, 0);
    NSArray<NSString*> *massegeArray = [self.text componentsSeparatedByString:@"\n"];
    if (massegeArray && [massegeArray count]  > 1) {
        for (NSString *message in massegeArray) {
            CGSize _sx_ = [PYUtile getBoundSizeWithTxt:message font:self.font size:CGSizeMake(9999, s.height)];
            if (_sx_.width > sx.width) {
                sx = _sx_;
            }
        }
    }else{
        sx = [PYUtile getBoundSizeWithTxt:self.text font:self.font size:CGSizeMake(9999, s.height)];
    }
    sx.height = s.height;
    int width = sx.width+1;
    int height = sx.height;
    sx.width = width;
    sx.height = height;
    self.frameSize = sx;
}

@end
