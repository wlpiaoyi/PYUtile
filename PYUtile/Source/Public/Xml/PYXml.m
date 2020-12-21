//
//  PYXmlDocument.m
//  PYUtile
//
//  Created by wlpiaoyi on 2017/7/18.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "PYXml.h"
#import "NSData+PYExpand.h"

static NSMutableDictionary * TSZF_DICT_TO;
static NSMutableDictionary * TSZF_DICT_FR;

@interface PYXmlElement(){
}
-(instancetype) initWithDeep:(int) deep parent:(PYXmlElement *) parent;
@end
@interface PYXmlDocument()<NSXMLParserDelegate>
kPNANA PYXmlElement * curElement;
kPNA unsigned int deep;
@end

@implementation PYXmlDocument

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, (^{
        TSZF_DICT_TO = [NSMutableDictionary dictionaryWithDictionary:@{
            @"&":@"#A#AND#A#"
        }];
        TSZF_DICT_FR = [NSMutableDictionary new];
        for (NSString * key in TSZF_DICT_TO) {
            TSZF_DICT_FR[TSZF_DICT_TO[key]] = key;
        }
    }));
}

+(NSString *) TSZF_DICT_TO:(NSString *) string{
    for (NSString * key in TSZF_DICT_TO) {
        if(![string containsString:key]) continue;
            string = [string stringByReplacingOccurrencesOfString:key withString:TSZF_DICT_TO[key]];
    }
    return string;
}
+(NSString *) TSZF_DICT_FR:(NSString *) string{
    for (NSString * key in TSZF_DICT_FR) {
        if(![string containsString:key]) continue;
            string = [string stringByReplacingOccurrencesOfString:key withString:TSZF_DICT_FR[key]];
    }
    return string;
}

+(nullable instancetype) instanceWithXmlString:(nonnull NSString *) xmlString{
    PYXmlDocument * xml = [PYXmlDocument new];
    xmlString = [PYXmlDocument TSZF_DICT_TO:xmlString];
    NSXMLParser *par = [[NSXMLParser alloc] initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]];
    [par setDelegate:xml];
    [par parse];
    return xml;
}
+(nullable instancetype) instanceWithRootElement:(nonnull PYXmlElement *) rootElement{
    PYXmlDocument * xml = [PYXmlDocument new];
    xml->_rootElement = rootElement;
    return xml;
    
}

-(nullable NSString *) stringValue{
    NSMutableString * stringValue = [NSMutableString new];
    [stringValue appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [stringValue appendString:[_rootElement stringValue]];
    [stringValue appendString:@"</xml>"];
    return stringValue;
}
#pragma mark xmlparser
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    _curElement = nil;
    _deep = 0;
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    _deep++;
    PYXmlElement * xd = [[PYXmlElement alloc] initWithDeep:_deep parent:_curElement];
    if(_rootElement == nil){
        _rootElement = xd;
        self.curElement = _rootElement;
    }else{
        [self.curElement addSubElement:xd];
    }
    xd.elementName = elementName;
    xd.attributes = attributeDict;
    _curElement = xd;
    
}
//step 3:获取头节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    PYXmlElement * stringNode = [[PYXmlElement alloc] initWithDeep:_deep parent:_curElement];
    stringNode.elementName = @"PYNode";
    stringNode.string = string;
    [_curElement addSubElement:stringNode];
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    _curElement = _curElement.parent;
    _deep--;
}

//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    _curElement.cData = CDATABlock;
}
//step 5；解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
//    NSLog([self stringValue]);
}
-(void) dealloc{
    
}
@end

@implementation PYXmlElement
-(instancetype) initWithDeep:(int) deep parent:(PYXmlElement *) parent{
    if(self = [super init]){
        _deep = deep;
        _parent = parent;
    }
    return self;
}
-(void) addSubElement:(nonnull PYXmlElement *) element{
    @synchronized(self){
        element->_parent = self;
        NSMutableArray<PYXmlElement *> * elements = [NSMutableArray new];
        if(_elements && _elements.count){
            [elements addObjectsFromArray:_elements];
        }
        [elements addObject:element];
        _elements = [NSArray arrayWithArray:elements];
    }
}
-(void) removeFromParentElement{
    @try{
        if(!self.parent || !self.parent.elements || !self.parent.elements.count){
            self.parent->_elements = nil;
            return;
        }
        @synchronized(self.parent){
            NSMutableArray<PYXmlElement *> * elements = [NSMutableArray arrayWithArray:self.parent.elements];
            [elements removeObject:self];
            self.parent->_elements = [NSArray arrayWithArray:elements];
        }
    }@finally{
        _parent = nil;
    }
}


-(nullable NSString *) stringValue{
    NSMutableString * stringValue = [NSMutableString new];
    [PYXmlElement stringValue:stringValue xmlDom:self];
    return stringValue;
}

+(void) stringValue:(NSMutableString *) stringValue xmlDom:(PYXmlElement *) xmlDom{
    if([xmlDom.elementName isEqual:@"PYNode"]){
        [stringValue appendString:[PYXmlDocument TSZF_DICT_FR:xmlDom.string]];
        return;
    }
    [stringValue appendString:@"<"];
    [stringValue appendString:xmlDom.elementName];
    if(xmlDom.attributes.count){
        for (NSString * key in xmlDom.attributes) {
            NSString * ky = [PYXmlDocument TSZF_DICT_FR:key];
            [stringValue appendFormat:@" %@=\"%@\"", ky, [PYXmlDocument TSZF_DICT_FR:xmlDom.attributes[ky]]];
        }
    }
    [stringValue appendString:@">"];
    if(xmlDom.elements && xmlDom.elements.count){
        for (PYXmlElement * item in xmlDom.elements) {
            [self stringValue:stringValue xmlDom:item];
        }
    }
    if(xmlDom.string){
        [stringValue appendString:[PYXmlDocument TSZF_DICT_FR:xmlDom.string]];
    }
    if(xmlDom.cData){
        [stringValue appendFormat:@"<![CDATA[%@]]>",[xmlDom.cData toString]];
    }
    [stringValue appendFormat:@"</%@>", xmlDom.elementName];
}
-(void) dealloc{
    
}
@end
