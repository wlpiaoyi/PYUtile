//
//  PYXml.m
//  PYUtile
//
//  Created by wlpiaoyi on 2017/7/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYXml.h"

@interface PYXmlDom()
@end
@interface PYXml()<NSXMLParserDelegate>
kPNSNN PYXmlDom * xmlDom;
kPNA unsigned int deep;
kPNA unsigned int index;
@end

@implementation PYXml
+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString{
    PYXml * xml = [PYXml new];
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    xml.xmlDom = [PYXmlDom new];
    [par setDelegate:xml];
    [par parse];
    return xml;
}
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
    self.deep = self.index = -1;
}
+(PYXmlDom *) SynXmlDom:(PYXmlDom *) xmlDom deep:(unsigned int) deep{
    if(deep == 0){
        return xmlDom;
    }
    PYXmlDom * nextDom = nil;
    deep--;
    if(xmlDom.datas == nil){
        xmlDom.datas = [PYXmlDom new];
        nextDom = xmlDom.datas;
    }else{
        if([xmlDom.datas isKindOfClass:[PYXmlDom class]]){
            xmlDom.datas = [NSMutableArray arrayWithObject:xmlDom.datas];
        }
        if([xmlDom.datas isKindOfClass:[NSMutableArray class]]){
            [((NSMutableArray *)xmlDom.datas) addObject:[PYXmlDom new]];
        }
        nextDom = ((NSMutableArray *)xmlDom.datas).lastObject;
    }
    return [self SynXmlDom:nextDom deep:deep];
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _deep++;
    NSLog(@"%@",NSStringFromSelector(_cmd) );
    self.xmlDom.elementName = elementName;
    self.xmlDom.attributeDict = attributeDict;
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
    
}

//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    NSLog(@"%@",NSStringFromSelector(_cmd) );
}
@end

@implementation PYXmlDom
@end
