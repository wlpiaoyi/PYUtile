//
//  NSData+PYExpand.h
//  UtileScourceCode
//
//  Created by wlpiaoyi on 15/11/26.
//  Copyright © 2015年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(PYExpand)
/**
 将数据转换成数据字典
 */
-(id _Nullable) toDictionary;
/**
 将数据转换成字符串
 */
-(nullable NSString *) toString;
/**
 将数据转换成Base64字符串
 */
-(nullable NSString *) toBase64String;
/**
 当前文件数据格式类型
 如果无法确定格式类型就返回空数据
 暂时只支持图片格式
 */
- (nullable NSString *) contentType;
@end
