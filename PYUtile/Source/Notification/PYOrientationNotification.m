//
//  OrientationsListener.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 16/1/18.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#import "PYOrientationNotification.h"
#import "PYUtile.h"
#import "UIViewController+HookView.h"
#import "UIViewController+HookOrientation.h"


@interface UIViewcontrollerHookViewSetController : NSObject <UIViewcontrollerHookViewDelegate>
@property (nonatomic, assign, nullable) PYOrientationNotification * listener;
-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target;
@end

@interface UIViewcontrollerHookOrientationSetController : NSObject <UIViewcontrollerHookOrientationDelegate>
@property (nonatomic, assign, nullable) PYOrientationNotification * listener;
-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target;
@end

static PYOrientationNotification *xPYOrientationNotification;

@interface PYOrientationNotification()
@property (nonatomic,strong) UIViewcontrollerHookOrientationSetController * delegateOrientation;
@property (nonatomic,strong) UIViewcontrollerHookViewSetController * delegateView;
@property (nonatomic,strong) NSHashTable<id<PYOrientationNotification>> *tableListeners;
-(void) setDeviceOrientation:(UIDeviceOrientation) deviceOrientation;
-(void) setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

@implementation PYOrientationNotification
+(nonnull instancetype) instanceSingle{
    @synchronized(self) {
        if (!xPYOrientationNotification) {
            xPYOrientationNotification = [PYOrientationNotification new];
        }
    }
    return xPYOrientationNotification;
}

-(id) init{
    if(self=[super init]){
        self.duration = 0.65100300312042236;
        self.tableListeners = [NSHashTable<id<PYOrientationNotification>> weakObjectsHashTable];
        UIDevice *device = [UIDevice currentDevice]; //Get the device object
        [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:device];//Get the notification centre for the app
        
        [UIViewController hookMethodView];
        self.delegateView = [UIViewcontrollerHookViewSetController new];
        self.delegateView.listener = self;
        [UIViewController addDelegateView:self.delegateView];
        
        [UIViewController hookMethodOrientation];
        self.delegateOrientation = [UIViewcontrollerHookOrientationSetController new];
        self.delegateOrientation.listener = self;
        [UIViewController addDelegateOrientation:self.delegateOrientation];
        
    }
    return self;
}
/**
 旋转当前装置
 */
-(void) attemptRotationToDeviceOrientation:(UIDeviceOrientation) deviceOrientation completion:(void (^)(void)) completion{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = deviceOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
        [UIViewController attemptRotationToDeviceOrientation];//这句是关键
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:self.duration];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion();
                }
            });
            
        });
    }
}
-(void) addListener:(id<PYOrientationNotification>) listener{
    @synchronized(self.tableListeners){
        if ([self.tableListeners containsObject:listener]) {
            return;
        }
        [self.tableListeners addObject:listener];
    }
}
-(void) removeListenser:(id<PYOrientationNotification>) listener{
    @synchronized(self.tableListeners){
        [self.tableListeners removeObject:listener];
    }
}

- (void)orientationChanged:(NSNotification *)note{
    @synchronized(self.tableListeners){
        UIDeviceOrientation _deviceOrientation_ = [[UIDevice currentDevice] orientation];
        BOOL isSupportOrientation = [PYOrientationNotification isSupportDeviceOrientation:_deviceOrientation_];
        _deviceOrientation = _deviceOrientation_;
        for (id<PYOrientationNotification> listener in self.tableListeners) {
            if (isSupportOrientation) {
                switch (_deviceOrientation) {
                    // Device oriented vertically, home button on the bottom
                    case UIDeviceOrientationPortrait:{
                        if([listener respondsToSelector:@selector(deviceOrientationPortrait)])[listener deviceOrientationPortrait];
                    }
                        break;
                    // Device oriented vertically, home button on the top
                    case UIDeviceOrientationPortraitUpsideDown:{
                        if([listener respondsToSelector:@selector(deviceOrientationPortraitUpsideDown)])[listener deviceOrientationPortraitUpsideDown];
                    }
                        break;
                    // Device oriented horizontally, home button on the right
                    case UIDeviceOrientationLandscapeLeft:{
                        if([listener respondsToSelector:@selector(deviceOrientationLandscapeLeft)])[listener deviceOrientationLandscapeLeft];
                    }
                        break;
                    // Device oriented horizontally, home button on the left
                    case UIDeviceOrientationLandscapeRight:{
                        if([listener respondsToSelector:@selector(deviceOrientationLandscapeRight)])[listener deviceOrientationLandscapeRight];
                    }
                        break;
                    default:{
                    }
                        break;
                }
            }else{
                if([listener respondsToSelector:@selector(deviceOrientationNotSupport:)])[listener deviceOrientationNotSupport:_deviceOrientation_];
            }
        }
    }
}

/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportDeviceOrientation:(UIDeviceOrientation) _deviceOrientation_{
    UIViewController *vc = [PYUtile getCurrentController];
    
    if (!vc) {
        return false;
    }
    
    return [self isSupportDeviceOrientation:_deviceOrientation_ targetController:vc];
}
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportDeviceOrientation:(UIDeviceOrientation) orientation targetController:(nonnull UIViewController *) targetController{
    UIInterfaceOrientationMask interfaceOrientationMask = 1 << orientation;
    return [self isSupportInterfaceOrientationMask:interfaceOrientationMask targetController:targetController];
}
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation targetController:(nonnull UIViewController *) targetController{
    UIInterfaceOrientationMask interfaceOrientationMask = 1 << interfaceOrientation;
    return [self isSupportInterfaceOrientationMask:interfaceOrientationMask targetController:targetController];
    return true;
}
/**
 是否支持旋转到当前方向
 */
+(BOOL) isSupportInterfaceOrientationMask:(UIInterfaceOrientationMask) interfaceOrientationMask targetController:(nonnull UIViewController *) targetController{
    
    UIInterfaceOrientationMask supportedInterfaceOrientations = [[UIApplication sharedApplication].keyWindow.rootViewController supportedInterfaceOrientations];
    if (!(supportedInterfaceOrientations & interfaceOrientationMask)) {
        return false;
    }
    
    supportedInterfaceOrientations = [targetController supportedInterfaceOrientations];
    if (!(supportedInterfaceOrientations & interfaceOrientationMask)) {
        return false;
    }
    
    return true;
}

-(void) setDeviceOrientation:(UIDeviceOrientation) deviceOrientation{
    _deviceOrientation = deviceOrientation;
}
-(void) setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    _interfaceOrientation = interfaceOrientation;
}

-(void) dealloc{
    [self.tableListeners removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation UIViewcontrollerHookViewSetController
-(void) afterExcuteViewWillAppearWithTarget:(nonnull UIViewController *) target{
    UIDeviceOrientation deviceOrientation = [PYOrientationNotification instanceSingle].deviceOrientation;
    if ([PYOrientationNotification isSupportDeviceOrientation:deviceOrientation targetController:target]) {
        deviceOrientation = parseInterfaceOrientationToDeviceOrientation([target preferredInterfaceOrientationForPresentation]);
    }
    if (![PYOrientationNotification isSupportInterfaceOrientation:self.listener.interfaceOrientation targetController:target]) {
        self.listener.interfaceOrientation = [target preferredInterfaceOrientationForPresentation];
    }
}
-(void) dealloc{
    [[UIViewController delegateViews] removeObject:self];
}
@end

@implementation UIViewcontrollerHookOrientationSetController

-(void) afterExcuteWillRotateToInterfaceOrientation:(UIInterfaceOrientation) toInterfaceOrientation duration:(NSTimeInterval)duration target:(nonnull UIViewController *) target{
    self.listener.interfaceOrientation = toInterfaceOrientation;
}
-(void) dealloc{
    [[UIViewController delegateOrientations] removeObject:self];
}
@end
