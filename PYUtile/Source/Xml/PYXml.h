//
//  PYXmlDocument.h
//  PYUtile
//
//  Created by wlpiaoyi on 2017/7/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYUtile.h"
/**
 xml元素
 */
@interface PYXmlElement:NSObject
/**
 当前元素深度
 */
kPNAR int deep;
/**
 父元素
 */
kPNARN PYXmlElement * parent;
/**
 元素名称
 */
kPNSNN NSString * elementName;
/**
 属性字典
 */
kPNSNA NSDictionary<NSString *, NSString *> * attributes;
/**
 子元素数组
 */
kPNCRNA NSArray<PYXmlElement *> * elements;
/**
 字符
 */
kPNSNA NSString * string;
/**
 数据
 */
kPNSNA NSData * cData;
/**
 装换成只字符串
 */
-(nullable NSString *) stringValue;
/**
 添加子节点
 */
-(void) addSubElement:(nonnull PYXmlElement *) element;
/**
 从父节点上移除
 */
-(void) removeFromParentElement;
@end

/**
 xml文档
 */
@interface PYXmlDocument : NSObject
kPNRNN NSString * version;
/**
 根节点元素
 */
kPNRNN PYXmlElement * rootElement;
/**
 初始化xml
 */
//==========================>
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString;
+(nullable instancetype) instanceWithRootElement:(nonnull PYXmlElement *) rootElement;
///<=========================
/**
 装换成只字符串
 */
-(nullable NSString *) stringValue;
@end
