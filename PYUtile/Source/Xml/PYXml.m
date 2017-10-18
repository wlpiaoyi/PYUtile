//
//  PYXml.m
//  PYUtile
//
//  Created by wlpiaoyi on 2017/7/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYXml.h"

@interface PYXmlDom(){
@public
    NSString * _endstr;
}
-(instancetype) initWithDeep:(int) deep parent:(PYXmlDom *) parent;
@end
@interface PYXml()<NSXMLParserDelegate>
kPNSNN PYXmlDom * xmlDom;
kPNANN PYXmlDom * cXmlDom;
kPNA unsigned int deep;
kPNA BOOL ispreEnd;
kPNA BOOL iscurEnd;
@end

@implementation PYXml
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString{
    PYXml * xml = [PYXml new];
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    xml.xmlDom = [[PYXmlDom alloc] initWithDeep:0 parent:nil];
    [par setDelegate:xml];
    [par parse];
    return xml;
}
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"init====================>%@",NSStringFromSelector(_cmd) );
    self.deep = 0;
    _ispreEnd = true;
    _iscurEnd = false;
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    PYXmlDom * xd;
    if(self.cXmlDom == nil){
        self.cXmlDom = self.xmlDom;
        xd = self.xmlDom;
    }else{
        xd = [[PYXmlDom alloc] initWithDeep:self.deep parent:self.cXmlDom];
        NSMutableArray * cs = [NSMutableArray new];
        if(self.cXmlDom.items == nil || ![self.cXmlDom.items isKindOfClass:[NSMutableArray class]]){
            cs = [NSMutableArray new];
            self.cXmlDom.items = cs;
        }else{
            cs = self.cXmlDom.items;
        }
        [cs addObject:xd];
    }
    xd.elementName = elementName;
    xd.attributes = attributeDict;
    self.cXmlDom = xd;
    
}
//step 3:获取尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
    _iscurEnd = true;
    self.cXmlDom->_endstr = string;
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}

//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
@end

@implementation PYXmlDom
-(instancetype) initWithDeep:(int) deep parent:(PYXmlDom *) parent{
    if(self = [super init]){
        _deep = deep;
        _parent = parent;
    }
    return self;
}
-(nonnull NSString *) xmlString{
    return _endstr;
}
@end
