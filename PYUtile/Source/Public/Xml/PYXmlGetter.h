//
//  PYXmlGetter.h
//  PYUtile
//
//  Created by piaoyi wl on 2024/6/28.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYXml.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYXmlGetter : NSObject

kPNRNN NSString * xmlBaseDictPath;

/**
 Read xml data from a folder
 @param xmlBaseDictPath a folder with in xml
 */
-(instancetype) initWithXmlBaseDictPath:(nonnull NSString * )xmlBaseDictPath;

///-----------------------
/// @name Getting Xml eletement object
///-----------------------
-(PYXmlElement *) getXmlElementByPath:(NSString *) path;

///-----------------------
/// @name Getting Xml attribute value by type
///-----------------------
/**
 @param attrName Xml attribute name
 @param defalutValue Xml attribute default value
 @param path Xml element path for way, also containts link xml
 @return Xml attribute value by string
 */
-(nullable NSString *) getXmlElementStringAttr:(NSString *) attrName defaultValue:(nullable NSString *) defalutValue path:(NSString *) path;
-(nullable NSString *) getXmlElementStringAttr:(NSString *) attrName defaultValue:(nullable NSString *) defalutValue xml:(PYXmlElement *) xml;

-(BOOL) getXmlElementBooleanAttr:(NSString *) attrName defaultValue:(BOOL) defalutValue xml:(PYXmlElement *) xml;
-(BOOL) getXmlElementBooleanAttr:(NSString *) attrName defaultValue:(BOOL) defalutValue path:(NSString *) path;

/**
 @param attrName Xml attribute name
 @param defalutValue Xml attribute default value
 @param path Xml element path for way, also containts link xml
 @return Xml attribute value by integer
 */
-(NSInteger) getXmlElementIntAttr:(NSString *) attrName defaultValue:(NSInteger) defalutValue path:(NSString *) path;
-(NSInteger) getXmlElementIntAttr:(NSString *) attrName defaultValue:(NSInteger) defalutValue xml:(PYXmlElement *) xml;
/**
 @param attrName Xml attribute name
 @param defalutValue Xml attribute default value
 @param path Xml element path for way, also containts link xml
 @return Xml attribute value by cgfloat
 */
-(CGFloat) getXmlElementFloatAttr:(NSString *) attrName defaultValue:(CGFloat) defalutValue path:(NSString *) path;
-(CGFloat) getXmlElementFloatAttr:(NSString *) attrName defaultValue:(CGFloat) defalutValue xml:(PYXmlElement *) xml;

@end

NS_ASSUME_NONNULL_END
