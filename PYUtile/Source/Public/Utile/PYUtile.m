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
#import <sys/utsname.h>
#import <mach/mach.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach-o/dyld.h>
#include <mach/machine.h>
#import <CommonCrypto/CommonDigest.h>



NSString * documentDir;
NSString * cachesDir;
NSString * bundleDir;
NSString * systemVersion;
NSMutableDictionary<NSString*, NSDictionary*> *dictionaryInfoPlist;
double EARTH_RADIUS = 6378.137;//地球半径

bool py_isPrisonBreakByPath(){
    BOOL root = NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSArray *pathArray = @[@"/etc/ssh/sshd_config",
                           @"/usr/libexec/ssh-keysign",
                           @"/usr/sbin/sshd",
                           @"/usr/sbin/sshd",
                           @"/bin/sh",
                           @"/bin/bash",
                           @"/etc/apt",
                           @"/Application/Cydia.app/",
                           @"/Library/MobileSubstrate/MobileSubstrate.dylib"
                           ];
    for (NSString *path in pathArray) {
        root = [fileManager fileExistsAtPath:path];
        // 如果存在这些目录，就是已经越狱
        if (root) return YES;
    }
    return true;
}


bool py_isPrisonBreakByDyldimage(){
    NSMutableArray * dypaths = [NSMutableArray new];
    int count = _dyld_image_count();
    for (int i = 0; i < count; i++) {
        const char *dyld = _dyld_get_image_name(i);
        NSString *dylibPath = [[NSString alloc] initWithCString:dyld encoding:NSUTF8StringEncoding];
        if([dylibPath containsString:@"/DynamicLibraries"]) return YES;
//        [dypaths appendString:dylibPath];
//        [dypaths appendString:@"\n"];
    }
    
    return NO;
}

bool py_isPrisonBreakByScheme(){
    NSURL *scheme = [NSURL URLWithString:@"cydia://package/com.example.package"];
    if([[UIApplication sharedApplication] canOpenURL:scheme]){
        return YES;
    }
    return NO;
}

void threadJoinMain(dispatch_block_t block){
    dispatch_async(dispatch_get_main_queue(), block);
}
void threadJoinGlobal(dispatch_block_t block){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}
void threadCreateGlobal(const char *_Nullable label, dispatch_block_t _Nullable block){
    dispatch_queue_t concurrentQueue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, block);
}


void lockForSemaphore(dispatch_block_t block, dispatch_semaphore_t semaphore){
    @try {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
         block();
    }@finally{
        dispatch_semaphore_signal(semaphore);
    }
}

void lockForDefault(dispatch_block_t block){
    static dispatch_semaphore_t semaphore;
    kDISPATCH_ONCE_BLOCK(^{semaphore = dispatch_semaphore_create(1);});
    lockForSemaphore(block, semaphore);
}

float boundsWidth(void){
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}
float boundsHeight(void){
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}


UIDeviceOrientation parseInterfaceOrientationToDeviceOrientation(UIInterfaceOrientation interfaceOrientation){\
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
        default:{
            orientation = UIDeviceOrientationUnknown;
        }
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
        default:{
            interfaceOrientation = UIInterfaceOrientationUnknown;
        }
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
    static size_t argsLength;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        args = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        argsLength = strlen(args);
    });
    const size_t bufferMaxIndex = 63;
    char bufferc[bufferMaxIndex + 2] = {};
    NSMutableString * uuid = [NSMutableString new];
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < length; i++) {
        int _i_ = arc4random() % argsLength;
        char * arg = &(args[_i_]);
        index = i % argsLength;
        bufferc[index] = *arg;
        if(index == bufferMaxIndex){
            [uuid appendString:[NSString stringWithUTF8String:bufferc]];
        }
    }
    if(index != bufferMaxIndex){
        bufferc[index+1] = '\0';
        [uuid appendString:[NSString stringWithUTF8String:bufferc]];
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
/**
 app cup使用率
 */
float app_cpu_usage(void){
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

/**
 连续控制
 */
static NSTimeInterval static_controls_time = 0;
//void controlsUdptype(NSTimeInterval timeInterval, dispatch_block_t block){
//    threadJoinGlobal(^{
//        NSTimeInterval pre_time = static_controls_time;
//        static_controls_time = [NSDate timeIntervalSinceReferenceDate];
//        NSTimeInterval cur_time = static_controls_time;
//        while ([NSDate timeIntervalSinceReferenceDate] - timeInterval <= pre_time ) {
//            [NSThread sleepForTimeInterval:.05];
//            if(cur_time != static_controls_time) return;
//        }
//        block();
//    });
//}
id synProgressObj;
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

/**
 获取正在显示的window
 */
+(nullable UIWindow *) getCurrenWindow{
    
    UIWindow *topWindow = kKeyWindow;
    Class pywindow = NSClassFromString(@"PYInterflowWindow");
    if(pywindow && [topWindow isKindOfClass:pywindow]) topWindow = nil;
    if (topWindow)  return topWindow;
    
    NSArray *windows = [kApplication windows];
    for(topWindow in windows){
        if (topWindow.windowLevel == UIWindowLevelNormal)break;
    }
    return topWindow;
}

/**
 获取最顶层的View
 */
+(nonnull UIView *) getTopView:(nonnull UIView *) subView{
    if(subView.superview == nil) return subView;
    if([subView isKindOfClass:[UIWindow class]]) return subView;
    return [self getTopView:subView.superview];
}

/**
 获取当前正在显示的controller(直接从window遍历)
 */
+(nullable UIViewController*) getCurrentController{
    UIViewController *result = nil;
    UIWindow *topWindow = [self getCurrenWindow];
    if (!topWindow)  return nil;
    
    UIView *rootView = [topWindow subviews].firstObject;
    if (!rootView) return nil;
    
    id nextResponder = [rootView nextResponder];
    if (!nextResponder) return nil;
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else if([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }else{
        NSAssert(NO, @"ShareKit: Could not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    }
    
    return [self getCurrentController:result];
}




/**
 获取当前正在显示的controller(直接从指定controller遍历)
 */
+(nonnull UIViewController *) getCurrentController:(nonnull UIViewController *) parentVc{
    
    UIViewController * childVc = nil;
    if ([parentVc isKindOfClass:[UITabBarController class]]) {
        if(((UITabBarController*)parentVc).selectedViewController)
            childVc =  ((UITabBarController*)parentVc).selectedViewController;
    } else if ([parentVc isKindOfClass:[UINavigationController class]]
            && ((UINavigationController*)parentVc).viewControllers
           && ((UINavigationController*)parentVc).viewControllers.count > 0) {
           childVc =  ((UINavigationController*)parentVc).viewControllers.lastObject;
    }else if(parentVc.childViewControllers
       && parentVc.childViewControllers.count > 0){
        childVc = [self getCurrentController:parentVc.childViewControllers.lastObject];
    }else if(parentVc.presentedViewController){
        childVc = parentVc.presentedViewController;
    }
    
    if(!childVc) return parentVc;
    
    return [self getCurrentController:childVc];;
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
 手机型号
 */
+(nullable NSString *) getDeviceInfo{
    struct utsname systemInfo;
    uname(&systemInfo);
    return  [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
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

#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


//当音频播放完毕会调用这个函数
static void SoundFinished(SystemSoundID soundID,void* sample){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
//    CFRelease(sample);
//    CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
