//
//  UIButton+PYExpand.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/12/3.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "UIButton+PYExpand.h"
#import "NSString+PYExpand.h"
#import "UIImage+PYExpand.h"

@implementation UIButton(PYExpand)

/**
 将button的image和title纵向显示
 #param offH:间距
 #param maxHeight:imageSize.height的最大高度，主要用于多个button的image 和 title 的协调
 #param direction:0 title在上 1 title在下
 */
-(void) parseImagetitleForOffH:(CGFloat) offH maxHeight:(CGFloat) maxHeight direction:(short) direction{
    return [self parseImagetitleForOffH:offH maxHeight:maxHeight offTop:0 direction:direction];
}
-(void) parseImagetitleForOffH:(CGFloat) offH maxHeight:(CGFloat) maxHeight offTop:(CGFloat) offTop direction:(short) direction{
    UIImage * imageNormal;
    UIImage * imageSelected;
    UIImage * imageHigthlight;
    UIImage * imageDisabled;
    
    UIButton * button = self;
    UIControlState state = UIControlStateNormal;
    imageNormal = [UIButton PYIPAu_getImageForButton:button state:state offH:offH maxHeight:maxHeight offTop:offTop direction:direction];
    
    state = UIControlStateSelected;
    imageSelected = [UIButton PYIPAu_getImageForButton:button state:state offH:offH maxHeight:maxHeight offTop:offTop direction:direction];
    
    state = UIControlStateHighlighted;
    imageHigthlight = [UIButton PYIPAu_getImageForButton:button state:state offH:offH maxHeight:maxHeight offTop:offTop direction:direction];
    
    state = UIControlStateDisabled;
    imageDisabled = [UIButton PYIPAu_getImageForButton:button state:state offH:offH maxHeight:maxHeight offTop:offTop direction:direction];
    
    
    state = UIControlStateNormal;
    if(imageNormal){
        [button setTitle:@"" forState:state];
        [button setImage:imageNormal forState:state];
    }
    
    state = UIControlStateSelected;
    if(imageSelected){
        [button setTitle:@"" forState:state];
        [button setImage:imageSelected forState:state];
    }
    
    state = UIControlStateHighlighted;
    if(imageHigthlight){
        [button setTitle:@"" forState:state];
        [button setImage:imageHigthlight forState:state];
    }
    
    state = UIControlStateDisabled;
    if(imageDisabled){
        [button setTitle:@"" forState:state];
        [button setImage:imageDisabled forState:state];
    }

}

+(nullable UIImage *) PYIPAu_getImageForButton:(nonnull UIButton *) button state:(UIControlState) state offH:(CGFloat) offH maxHeight:(CGFloat) maxHeight offTop:(CGFloat) offTop direction:(short) direction{
    UIImage * image = [button imageForState:state];
    NSString * title = [button titleForState:state];
    if(!image || ![NSString isEnabled:title]){
        return nil;
    }
    if(state != UIControlStateNormal){
        UIImage * imagen = [button imageForState:UIControlStateNormal];
        NSString * titlen = [button titleForState:UIControlStateNormal];
        if(imagen == image && title == titlen) return nil;
    }
    image = [UIImage createImageWithTitle:title font:button.titleLabel.font color:[button titleColorForState:state] image:image offH:offH imageOffH:maxHeight - image.size.height offTop:offTop direction:direction];
    return image;
};

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
