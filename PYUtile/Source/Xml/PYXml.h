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
kPNSNN NSString * elementName;
kPNSNN NSDictionary<NSString *, NSString *> * attributeDict;
kPNSNN id datas;
@end
@interface PYXml : NSObject
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString;
@end
