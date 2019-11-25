//
//  NSData+PYExpand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSData+PYExpand.h"
#import "PYUtile.h"

@implementation NSData(PYExpand)
-(id _Nullable) toDictionary{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error) kPrintErrorln("Data to Dict erro:[%@]",error.debugDescription.UTF8String);
    return obj;
}
-(nullable NSString *) toString{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

-(nullable NSString *) toBase64String{
    return [[NSString alloc] initWithData:[self base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
}
/**
 当前数据格式类型
 如果无法确定格式类型就返回空数据
 */
- (nullable NSString *) contentType{
    uint8_t c;
    [self getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([self length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[self subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}
@end
