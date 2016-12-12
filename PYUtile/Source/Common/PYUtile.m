//
//  PYUtile.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/10/28.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "PYUtile.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>

#import <mach/mach.h>

NSString * documentDir;
NSString * cachesDir;
NSString * bundleDir;
NSString * systemVersion;
NSMutableDictionary<NSString*, NSDictionary*> *dictionaryInfoPlist;
double EARTH_RADIUS = 6378.137;//地球半径


NSObject *synProgressObj;

float boundsWidth(){
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}
float boundsHeight(){
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

UIDeviceOrientation parseInterfaceOrientationToDeviceOrientation(UIInterfaceOrientation interfaceOrientation){
    UIDeviceOrientation orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            orientation = UIDeviceOrientationPortrait;
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            orientation = UIDeviceOrientationLandscapeRight;
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            orientation = UIDeviceOrientationLandscapeLeft;
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            orientation = UIDeviceOrientationPortraitUpsideDown;
        }
            break;
        default:
            break;
    }
    return orientation;
}
UIInterfaceOrientation parseDeviceOrientationToInterfaceOrientation(UIDeviceOrientation deviceOrientation){
    UIInterfaceOrientation interfaceOrientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:{
            interfaceOrientation = UIInterfaceOrientationPortrait;
        }
            break;
        case UIDeviceOrientationLandscapeRight:{
            interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        }
            break;
        case UIDeviceOrientationLandscapeLeft:{
            interfaceOrientation = UIInterfaceOrientationLandscapeRight;
        }
            break;
        case UIDeviceOrientationFaceDown:{
            interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
        }
            break;
        default:
            break;
    }
    return interfaceOrientation;
}
//==>角度和弧度之间的转换
double parseDegreesToRadians(double degrees) {
    return ((degrees)*M_PI / 180.0);
}
double parseRadiansToDegrees(double radians) {
    return ((radians)*180.0 / M_PI);
}
///<==
/**
 生成UUID
 */
NSString * _Nullable PYUUID(NSUInteger length){
    if (length == 0) {
        return nil;
    }
    static char * args;
    static int argsLength;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        args = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        argsLength = 10 + 26 * 2 + 3;
    });
    NSMutableString * uuid = [NSMutableString new];
    for (int index = 0; index < length; index++) {
        int _index_ = arc4random() % argsLength;
        char arg = args[_index_];
        [uuid appendString:[NSString stringWithFormat:@"%c",arg]];
    }
    return uuid;
}
/**
 距离转换
 */
double parseCoordinateToDistance(double lat1, double lng1, double lat2, double lng2) {
    double radLat1 = parseDegreesToRadians(lat1);
    double radLat2 = parseDegreesToRadians(lat2);
    double a = radLat1 - radLat2;
    double b = parseDegreesToRadians(lng1) - parseDegreesToRadians(lng2);
    double s = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(radLat1) * cos(radLat2) * pow(sin(b/2), 2)));
    s = s * EARTH_RADIUS;
    s =  round(s * 10000) / 10000;
    return s;
}

float cpu_usage(){
    kern_return_t			kr = { 0 };
    task_info_data_t		tinfo = { 0 };
    mach_msg_type_number_t	task_info_count = TASK_INFO_MAX;
    
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t		basic_info = { 0 };
    thread_array_t			thread_list = { 0 };
    mach_msg_type_number_t	thread_count = { 0 };
    
    thread_info_data_t		thinfo = { 0 };
    thread_basic_info_t		basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long	tot_sec = 0;
    long	tot_usec = 0;
    float	tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    return tot_cpu;
}

@implementation PYUtile
+(void) load{
    documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    cachesDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    bundleDir = [NSBundle mainBundle].bundlePath;
    systemVersion = [UIDevice currentDevice].systemVersion;
    synProgressObj = [NSObject new];
    dictionaryInfoPlist = [NSMutableDictionary<NSString*, NSDictionary*> new];
}
/**
 获取plist文件的类容
 */
+(NSDictionary*) getInfoPlistWithName:(NSString*) name{
    NSDictionary* dictInfoPlist;
    @synchronized(dictionaryInfoPlist) {
        dictInfoPlist = dictionaryInfoPlist[name];
        if (!dictInfoPlist) {
            NSString* fileInfoPlist = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
            dictInfoPlist = [[NSDictionary alloc] initWithContentsOfFile:fileInfoPlist];
            dictionaryInfoPlist[name] = dictInfoPlist;
        }
    }
    return dictInfoPlist;
}
+(nullable UIViewController*) getCurrentController{
    UIViewController *result;
    // Try to find the root view controller programmically
    // Find the top window (that is not an alert view or other window)
    
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (!topWindow) {
        return nil;
    }
    if (topWindow.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)break;
        }
    }
    
    UIView *rootView = [topWindow subviews].firstObject;
    if (!rootView) {
        return nil;
    }
    id nextResponder = [rootView nextResponder];
    if (!nextResponder) {
        return nil;
    }
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else if([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    }
    
    return [self getCurrentController:result];
}
+(nonnull UIViewController *) getCurrentController:(nonnull UIViewController *) result{
    
    if ([result isKindOfClass:[UINavigationController class]]) {
        if(!( ((UINavigationController*)result).viewControllers) ||  ((UINavigationController*)result).viewControllers.count == 0){
            return result;
        }
        result =  ((UINavigationController*)result).viewControllers.lastObject;
    }
    
    if ([result isKindOfClass:[UITabBarController class]]) {
        if(!( ((UITabBarController*)result).viewControllers) ||  ((UITabBarController*)result).viewControllers.count == 0){
            return result;
        }
        result =  ((UITabBarController*)result).viewControllers.lastObject;
    }
    
    if([result isKindOfClass:[UINavigationController class]] || [result isKindOfClass:[UITabBarController class]]){
        return [self getCurrentController:result];
    }
    
    return result;
}
//==>
//计算文字占用的大小
+(CGSize) getBoundSizeWithTxt:(NSString*) txt font:(UIFont*) font size:(CGSize) size{
    if (IOS7_OR_LATER) {
        NSDictionary<NSString*,id> *attribute = @{NSFontAttributeName: font};
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine|
        NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
        return [txt boundingRectWithSize:size options: options attributes:attribute context:nil].size;
    }else{
        return [txt sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    }
}
//计算文字占用的大小
+(CGSize) getBoundSizeWithAttributeTxt:(nonnull NSAttributedString *) attributeTxt size:(CGSize) size{
    if (IOS7_OR_LATER) {
        NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine|
        NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading;
        return [attributeTxt boundingRectWithSize:size options:options context:nil].size;
    }else{
        NSAssert(false, @"不支持文字排列空间计算");
        return CGSizeZero;
    }
}
/**
 计算指定字体大小对应的高度
 */
+(CGFloat) getFontHeightWithSize:(CGFloat) size fontName:(NSString*) fontName{
    CGFontRef customFont = CGFontCreateWithFontName((CFStringRef)(fontName));
    CGRect bbox = CGFontGetFontBBox(customFont); // return a box that can contain any char with this font
    int units = CGFontGetUnitsPerEm(customFont); // return how many glyph unit represent a system device unit
    CGFontRelease(customFont);
    CGFloat height = (((float)bbox.size.height)/((float)units))*size;
    return height;
}
/**
 计算指定高度对应的字体大小
 */
+(CGFloat) getFontSizeWithHeight:(CGFloat) height fontName:(NSString*) fontName{
    CGFontRef customFont = CGFontCreateWithFontName((CFStringRef)(fontName));
    if (!customFont) {
        return 0;
    }
    CGRect bbox = CGFontGetFontBBox(customFont); // return a box that can contain any char with this font
    int units = CGFontGetUnitsPerEm(customFont); // return how many glyph unit represent a system device unit
    CGFontRelease(customFont);
    CGFloat suffx = CGFLOAT_MAX;
    for (int i=1; i<100; i++) {
        CGFloat _height = (((float)bbox.size.height)/((float)units))*i;
        _height = height-_height;
        if (suffx<ABS(_height)) {
            suffx = i-1;
            break;
        }
        suffx = _height;
    }
    return suffx;
}
///<==

/**
 汉字转拼音
 */
+ (NSString *) chineseToSpell:(NSString*)sourceString{
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

/**
 添加不向服务器备份的Document下的路径
 */
+(BOOL) addSkipBackupAttributeToItemAtURL:(NSString *)url{
    assert([[NSFileManager defaultManager] fileExistsAtPath: url]);
    NSURL *URL = [NSURL fileURLWithPath:url];
    NSError *error = nil;
    BOOL success = [URL setResourceValue: @YES
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
/**
 简易发声
 */
+(BOOL) soundWithPath:(NSString*) path isShake:(BOOL) isShake{
    
    if(isShake){
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, SoundFinished,nil);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (!path || [path isKindOfClass:[NSNull class]] || !path.length) {
        return false;
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        return false;
    }
    SystemSoundID shortSound;
    // Create a file URL with this path
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // Register sound file located at that URL as a system sound
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,
                                                    &shortSound);
    if (err != kAudioServicesNoError){
        NSLog(@"Could not load %@, error code: %d", url, (int)err);
        return false;
    }else{
        /*添加音频结束时的回调*/
        AudioServicesAddSystemSoundCompletion(shortSound, NULL, NULL, SoundFinished,nil);
        AudioServicesPlaySystemSound(shortSound);
    }
    return true;
    
}

//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
//    CFRelease(sample);
//    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
