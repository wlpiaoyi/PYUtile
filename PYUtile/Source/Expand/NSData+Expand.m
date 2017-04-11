//
//  NSData+Expand.m
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import "NSData+Expand.h"

@implementation NSData(Expand)
-(id _Nullable) toDictionary{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSAssert(NO, error.domain);
    }
    return obj;
}
-(NSString * _Nullable) toString{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}
-(nullable NSString *) toBase64String{
    return [[NSString alloc] initWithData:[self base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
}
@end
