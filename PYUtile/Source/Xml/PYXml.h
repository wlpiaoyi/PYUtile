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
PYPNSNN NSString * elementName;
PYPNSNN NSDictionary<NSString *, NSString *> * attributeDict;
PYPNSNN id datas;
@end
@interface PYXml : NSObject
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString;
@end
