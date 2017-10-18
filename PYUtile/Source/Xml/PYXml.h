//
//  PYXml.h
//  PYUtile
//
//  Created by wlpiaoyi on 2017/7/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PYUtile.h"

@interface PYXmlDom:NSObject
kPNARN PYXmlDom * parent;
kPNAR int deep;
kPNSNN NSString * elementName;
kPNSNN NSDictionary<NSString *, NSString *> * attributes;
kPNSNA id items;
-(nonnull NSString *) xmlString;
@end
@interface PYXml : NSObject
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString;
@end
