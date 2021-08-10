//
//  NSString+Convenience.m
//  AKSL-189-Msp
//
//  Created by qqpiaoyi on 13-11-12.
//  Copyright (c) 2013年 AKSL. All rights reserved.
//

#import "NSString+PYExpand.h"
#import "NSString+__PY_Match.h"
#import "py_data_function.h"

static inline int py_str_compare_min(int a, int b) { return a < b ? a : b; }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation NSString (PYExpand)
-(BOOL) hasChinese:(nullable BOOL *) isAll{
    BOOL hasChinese = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            hasChinese = true;
            if(!isAll)break;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasChinese;
}
-(BOOL) hasASCII:(nullable BOOL *) isAll{
    BOOL hasASCll = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0x0 && a < 0xFF){
            hasASCll = true;
            if (!isAll) break;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasASCll;
}
-(BOOL) hasUnkown:(nullable BOOL *) isAll{
    BOOL hasUnkown = false;
    if(isAll)*isAll = true;
    for(int i=0; i< [self length];i++){
        int a = [self characterAtIndex:i];
        if( a > 0xFF && (a < 0x4e00 || a > 0x9fff)){
            hasUnkown = true;
            if(isAll)break;
        }else if(isAll){
            *isAll = false;
        }
    }
    return hasUnkown;
}
-(NSComparisonResult) compareVersion:(nullable NSString *) version{
    if (![NSString isEnabled:version]) {
        return true;
    }
    NSInteger currentValue = 0;
    NSInteger targetValue = 0;
    NSArray<NSString *> * currentArray = [self componentsSeparatedByString:@"."];
    NSArray<NSString *> * targetArray = [version componentsSeparatedByString:@"."];
    static const NSInteger value = 100;
    NSInteger count = MAX(currentArray.count, targetArray.count);
    for (NSString * _v_ in currentArray) {
        --count;
        currentValue += _v_.integerValue * pow(value, count);
    }
    
    count = MAX(currentArray.count, targetArray.count);
    for (NSString * _v_ in targetArray) {
        --count;
        targetValue += _v_.integerValue * pow(value, count);
    }
    if (targetValue > currentValue) {
        return NSOrderedDescending;
    }
    if (targetValue < currentValue) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}
-(NSDate*) dateFormateString:(NSString*) formatePattern{//
    if(formatePattern == nil || formatePattern.length == 0){
        if([NSString matchArg:self regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2})$"]){
            formatePattern = @"yyyy-MM-dd";
        }else if([NSString matchArg:self regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2} \\d{2})$"]){
            formatePattern = @"yyyy-MM-dd HH";
        }else if([NSString matchArg:self regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2} \\d{2}:\\d{2})$"]){
            formatePattern = @"yyyy-MM-dd HH:mm";
        }else if([NSString matchArg:self regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2} \\d{2}:\\d{2}:\\d{2})$"]){
            formatePattern = @"yyyy-MM-dd HH:mm:ss";
        }else if([NSString matchArg:self regex:@"^(\\d{4}\\-\\d{2}\\-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}\\+\\d{2}\\:\\d{2})$"]){
            formatePattern = @"yyyy-MM-dd'T'HH:mm:ss.SSSXXX";
        }else return nil;
    }
    NSDateFormatter *dft = [[NSDateFormatter alloc]init];
    [dft setDateFormat:formatePattern];
    return [dft dateFromString:self];
}
+(bool) isEnabled:(nullable id) target{
    if(!target||target==nil||target==[NSNull null]||[@"" isEqual:target])return NO;
    else return YES;
}
/**
 将64位的字符串装换成正常的Data数据
 */
-(nullable NSData *) toDataForBase64{
    NSData * tempData = [self toData];
    return [[NSData alloc] initWithBase64EncodedData:tempData options:0];
//    return [[self toData] base64EncodedDataWithOptions:0];
}
/**
 将字符串装换成Data数据
 */
-(nullable NSData *) toData{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}
/**
 0b10001,
 0xFFFFFF33,
 10001
 */
-(NSInteger) toInteger{
    
    if(self.length == 0) return 0;
    if(self.length > 2){
        NSString * head = [self substringWithRange:NSMakeRange(0, 2)];
        if([head isEqual:@"0x"]){
            return py_data_16_to_10(self.uppercaseString.UTF8String);
        }else if([head isEqual:@"0b"]){
            return py_data_2_to_10(self.uppercaseString.UTF8String);
        }
    }
    return self.integerValue;
}
-(NSString *)filterHTML
{
    NSString *html = self;
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO){
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
//    NSString * regEx = @"<([^>]*)>";
//    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
+ (nullable NSString*)base64forData:(nullable NSData *)theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}


/**
 比较字符串相似度
 */
- (float) likePercentForCompare:(NSString *)compare{
    
    int n = (int)compare.length;
    
    int m = (int)self.length;
    
    if (m==0) return n;
    
    if (n==0) return m;
    
    //Construct a matrix, need C99 support
    
    int matrix[n+1][m+1];
    
    memset(&matrix[0], 0, m+1);
    
    for(int i=1; i<=n; i++) {
        
        memset(&matrix[i], 0, m+1);
        
        matrix[i][0]=i;
        
    } for(int i=1; i<=m; i++) {
        
        matrix[0][i]=i;
        
    } for(int i=1;i<=n;i++) {
        
        unichar si = [compare characterAtIndex:i-1];
        
        for(int j=1;j<=m;j++)
            
        {
            
            unichar dj = [self characterAtIndex:j-1];
            
            int cost;
            
            if(si==dj){
                
                cost=0;
                
            }
            
            else{
                
                cost=1;
                
            }
            
            const int above=matrix[i-1][j]+1;
            
            const int left=matrix[i][j-1]+1;
            
            const int diag=matrix[i-1][j-1]+cost;
            
            matrix[i][j]=py_str_compare_min(above,py_str_compare_min(left,diag));
            NSLog(@"%d, %d  %d", i, j, matrix[i][j]);
            
        }
        
    }
    
    return 100.0 - 100.0*matrix[n][m]/self.length;
    
}

- (NSString *) pyEncodeToPercentEscapeString: (NSString *) input{
    input = input ? input : @"!*'();:@&=+$,/?%#[]";
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)input,
                                                              kCFStringEncodingUTF8));
    return outputStr;
}
 
- (NSString *) pyDecodeFromPercentEscapeString;{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                              (CFStringRef)self, CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return outputStr;
}
@end
#pragma clang diagnostic pop
