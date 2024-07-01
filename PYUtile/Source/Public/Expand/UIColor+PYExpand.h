
/****
 VOORBEELDEN
 
 [UIColor colorWithRGBHex:0xff00ff];
 [UIColor colorWithHexString:@"0xff00ff"]
 *******/



#define SUPPORTS_UNDOCUMENTED_API	0


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PYUtileMacro.h"

@interface UIColor (PYExpand)
@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 hexNumber;

- (NSString *)colorSpaceString;

- (NSArray *)arrayFromRGBAComponents;

- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;

- (UIColor *)colorByLuminanceMapping;

-(nullable UIColor *) copyForChangeAlpha:(CGFloat) alpha;
-(nullable UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
-(nullable UIColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
-(nullable UIColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
-(nullable UIColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

-(nullable UIColor *)colorByMultiplyingByColor:(nonnull UIColor *)color;
-(nullable UIColor *)       colorByAddingColor:(nonnull UIColor *)color;
-(nullable UIColor *) colorByLighteningToColor:(nonnull UIColor *)color;
-(nullable UIColor *)  colorByDarkeningToColor:(nonnull UIColor *)color;

-(nullable NSString *)stringFromColor;
-(nullable NSString *)hexStringFromColor;

+(nullable UIColor *)randomColor;

+(nullable UIColor *)  colorWithHexString:(nonnull NSString *)stringToConvert;
+(nullable UIColor *)     colorWithString:(nonnull NSString *)stringToConvert;
+(nullable UIColor *)  colorWithHexNumber:(UInt32)hex;//0xFFEEDDEE
+(nullable UIColor *)     colorWithRGBHex:(UInt32)hex API_DEPRECATED_WITH_REPLACEMENT("colorWithHexNumber:", ios(1.0, 2.0));
+(nullable UIColor *)       colorWithName:(nonnull NSString *)cssColorName;

@end

#if SUPPORTS_UNDOCUMENTED_API
// UIColor_Undocumented_Expanded
// Methods which rely on undocumented methods of UIColor
@interface UIColor (UIColor_Undocumented_Expanded)
- (NSString *)fetchStyleString;
- (UIColor *)rgbColor; // Via Poltras
@end
#endif // SUPPORTS_UNDOCUMENTED_API
