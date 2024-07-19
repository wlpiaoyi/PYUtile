//
//  PYXmlGetter.m
//  PYUtile
//
//  Created by piaoyi wl on 2024/6/28.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import "PYXmlGetter.h"
#import "NSArray+PYExpand.h"
#import "NSData+PYExpand.h"
#import "NSString+PYExpand.h"


@interface PYXmlGetter()

kPNRNN NSMutableDictionary<NSString * , PYXmlElement *> * xmlElementDict;
kPNRNN NSMutableDictionary * objectCaches;

@end


@implementation PYXmlGetter

-(instancetype) initWithXmlBaseDictPath:(nonnull NSString * )xmlBaseDictPath{
    if(![[NSFileManager defaultManager] fileExistsAtPath:xmlBaseDictPath]){
        return nil;
    }
    self = [super init];
    if(self){
        _xmlBaseDictPath = xmlBaseDictPath;
        _xmlElementDict = [NSMutableDictionary new];
        _objectCaches = [NSMutableDictionary new];
    }
    return self;
}


-(PYXmlElement *) getXmlElementByName:(NSString *) xmlName{
    PYXmlElement * subXml = [self.xmlElementDict valueForKey:xmlName];
    if(subXml != nil){
        return subXml;
    }
    NSString * xmlPath = kFORMAT(@"%@/%@.xml", self.xmlBaseDictPath, xmlName);
    if(![[NSFileManager defaultManager] fileExistsAtPath:xmlPath]){
        return nil;
    }
    NSData * xmlData = [NSData dataWithContentsOfFile:xmlPath];
    if(xmlData == nil || xmlData.length == 0){
        return nil;
    }
    PYXmlDocument * docXml = [PYXmlDocument instanceWithXmlString:[xmlData toString]];
    if(docXml == nil){
        return nil;
    }
    subXml = [docXml rootElement];
    [((NSMutableDictionary *) self.xmlElementDict) setValue:subXml forKey:xmlName];
    return subXml;
}

-(NSString *) getXmlElementStringAttr:(NSString *) attrName defaultValue:(NSString *) defalutValue xml:(PYXmlElement *) xml{
    NSString * attrValue = [xml.attributes valueForKey:attrName];
    if(attrValue == nil || attrValue.length == 0){
        return defalutValue;
    }
    if(attrValue.length > 3 && [[attrValue substringToIndex:2] isEqual:@"${"] && [[attrValue substringFromIndex:attrValue.length - 1] isEqual:@"}"]){
        NSString * linkPath = [attrValue substringToIndex:attrValue.length - 1];
        linkPath = [linkPath substringFromIndex:2];
        attrValue = [self getXmlElementStringAttr:@"value" defaultValue:nil path:linkPath];
    }
    return attrValue;
}

-(NSString *) getXmlElementStringAttr:(NSString *) attrName defaultValue:(NSString *) defalutValue path:(NSString *) path{
    PYXmlElement * xe = [self getXmlElementByPath:path];
    if(xe == nil){
        return defalutValue;
    }
    return [self getXmlElementStringAttr:attrName defaultValue:defalutValue xml:xe];
}

-(BOOL) getXmlElementBooleanAttr:(NSString *) attrName defaultValue:(BOOL) defalutValue xml:(PYXmlElement *) xml{
    NSString * attrValue = [self getXmlElementStringAttr:attrName defaultValue:nil xml:xml];
    if(attrValue == nil || attrValue.length == 0){
        return defalutValue;
    }
    if([attrValue matchInteger] || [attrValue matchFloat]){
        return attrValue.boolValue;
    }
    if([attrValue.lowercaseString isEqual:@"true"]){
        return true;
    }
    if([attrValue.lowercaseString isEqual:@"false"]){
        return false;
    }
    if([attrValue isEqual:@"T"]){
        return true;
    }
    if([attrValue isEqual:@"F"]){
        return false;
    }
    return defalutValue;
}

-(BOOL) getXmlElementBooleanAttr:(NSString *) attrName defaultValue:(BOOL) defalutValue path:(NSString *) path{
    PYXmlElement * xe = [self getXmlElementByPath:path];
    if(xe == nil){
        return defalutValue;
    }
    return [self getXmlElementBooleanAttr:attrName defaultValue:defalutValue xml:xe];
}

-(NSInteger) getXmlElementIntAttr:(NSString *) attrName defaultValue:(NSInteger) defalutValue xml:(PYXmlElement *) xml{
    NSString * attrValue = [self getXmlElementStringAttr:attrName defaultValue:nil xml:xml];
    if(attrValue == nil || attrValue.length == 0){
        return defalutValue;
    }
    if([attrValue matchInteger] || [attrValue matchFloat]){
        return attrValue.integerValue;
    }
    return defalutValue;
}
-(NSInteger) getXmlElementIntAttr:(NSString *) attrName defaultValue:(NSInteger) defalutValue path:(NSString *) path{
    PYXmlElement * xe = [self getXmlElementByPath:path];
    if(xe == nil){
        return defalutValue;
    }
    return [self getXmlElementIntAttr:attrName defaultValue:defalutValue xml:xe];
}

-(CGFloat) getXmlElementFloatAttr:(NSString *) attrName defaultValue:(CGFloat) defalutValue xml:(PYXmlElement *) xml{
    NSString * attrValue = [self getXmlElementStringAttr:attrName defaultValue:nil xml:xml];
    if(attrValue == nil || attrValue.length == 0){
        return defalutValue;
    }
    if([attrValue matchInteger] || [attrValue matchFloat]){
        return attrValue.doubleValue;
    }
    return defalutValue;
}
-(CGFloat) getXmlElementFloatAttr:(NSString *) attrName defaultValue:(CGFloat) defalutValue path:(NSString *) path{
    PYXmlElement * xe = [self getXmlElementByPath:path];
    if(xe == nil){
        return defalutValue;
    }
    return [self getXmlElementFloatAttr:attrName defaultValue:defalutValue xml:xe];
}


-(PYXmlElement *) getXmlElementByPath:(NSString *) path{
    NSArray<NSString *> * pathVas = [path componentsSeparatedByString:@"."];
    if(pathVas.count == 0){
        return nil;
    }
    NSString * rootXmlPath = [pathVas objectAtIndex:0];
    if(rootXmlPath == nil){
        return nil;
    }
    if(rootXmlPath.length == 0){
        return nil;
    }
    PYXmlElement * subXml = [self getXmlElementByName:rootXmlPath];
    if(subXml == nil){
        return nil;
    }
    if(pathVas.count == 1){
        return subXml;
    }

    NSMutableArray * subPathVas = [pathVas mutableCopy];
    [subPathVas removeObjectAtIndex:0];
    PYXmlElement * resXml;
    switch (subPathVas.count) {
        case 1:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0], nil];
            break;
        case 2:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1], nil];
            break;
        case 3:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2], nil];
            break;
        case 4:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3], nil];
            break;
        case 5:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4], nil];
            break;
        case 6:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5], nil];
            break;
        case 7:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6], nil];
            break;
        case 8:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7], nil];
            break;
        case 9:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8], nil];
            break;
        case 10:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9], nil];
            break;
        case 11:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9],[subPathVas objectAtIndex:10], nil];
            break;
        case 12:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9],[subPathVas objectAtIndex:10],[subPathVas objectAtIndex:11], nil];
            break;
        case 13:
            resXml = [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9],[subPathVas objectAtIndex:10],[subPathVas objectAtIndex:11],[subPathVas objectAtIndex:12], nil];
            break;
        default:
            @throw [NSException exceptionWithName:@"xml.element parse error" reason:kFORMAT(@"pathVas is not of max lenght, [%@]", [[subPathVas toData] toString]) userInfo:nil];
    }
    return resXml;
}

-(BOOL) isCurPrimaryByCurXml:(PYXmlElement *) curXml linkXml:(PYXmlElement *) linkXml{
    if([self getXmlElementBooleanAttr:@"primary" defaultValue:FALSE xml:curXml]){
        return true;
    }
    if([self getXmlElementBooleanAttr:@"primary" defaultValue:FALSE xml:linkXml]){
        return false;
    }
    return true;
}

-(PYXmlElement *) getSubElementByElements:(NSArray<PYXmlElement *> *) elements keyId:(NSString *) keyId{
    for (PYXmlElement * subEle in elements) {
        NSString * curKeyId = [self getXmlElementStringAttr:@"id" defaultValue:nil xml:subEle];
        if(curKeyId == nil || curKeyId.length == 0){
            continue;
        }
        if([curKeyId isEqual:keyId]){
            return subEle;
        }
    }
    return nil;
}

-(PYXmlElement *) getPrimarySubElementByElements:(NSArray<PYXmlElement *> *) elements eleName:(NSString *) eleName{
    for (PYXmlElement * subEle in elements) {
        if(![subEle.elementName isEqual:eleName]){
            continue;
        }
        if(![self getXmlElementBooleanAttr:@"primary" defaultValue:FALSE xml:subEle]){
            continue;
        }
        return subEle;
    }
    return nil;
}

-(BOOL) mergeXmlAttributesByCurXml:(PYXmlElement *) curXml linkXml:(PYXmlElement *) linkXml{
    BOOL curPrimary = [self isCurPrimaryByCurXml:curXml linkXml:linkXml];
    NSDictionary * linkAttributes = [linkXml.attributes mutableCopy];
    if(linkAttributes == nil || linkAttributes.count == 0){
        return curPrimary;
    }
    NSMutableDictionary * curAttributes;
    if(curXml.attributes != nil){
        curAttributes = [curXml.attributes mutableCopy];
    }else{
        curAttributes = [NSMutableDictionary new];
    }
    for(NSString * key in linkAttributes){
        NSString * linkValue = [linkAttributes valueForKey:key];
        NSString * curValue = [curAttributes valueForKey:key];
        if(linkValue == nil || linkValue.length == 0){
            continue;
        }
        if(curPrimary){
            if(curValue == nil || curValue.length == 0){
                [curAttributes setValue:linkValue forKey:key];
            }else continue;
        }else{
            [curAttributes setValue:linkValue forKey:key];
        }
    }
    [curXml setAttributes:curAttributes];
    return curPrimary;
}

-(void) mergeXmlSubElementsByCurXml:(PYXmlElement *) curXml linkXml:(PYXmlElement *) linkXml{
    BOOL curPrimary = [self mergeXmlAttributesByCurXml:curXml linkXml:linkXml];
    NSArray<PYXmlElement *> * linkEles = [linkXml.elements mutableCopy];
    if(linkEles == nil || linkEles.count == 0){
        return;
    }
    NSArray<PYXmlElement *> * curSubElements = [curXml.elements mutableCopy];
    if(curSubElements == nil){
        curSubElements = [NSMutableArray new];
    }
    for(PYXmlElement * linkEle in linkEles){
        NSString * linkKeyId = [self getXmlElementStringAttr:@"id" defaultValue:nil xml:linkEle];
        if(linkKeyId == nil || linkKeyId.length == 0){
            PYXmlElement * curEle = [self getSubElementByElements:curSubElements keyId:linkKeyId];
            if(curEle == nil){
                [curXml addSubElement:[linkEle deepCopy]];
            }else{
                [self mergeXmlSubElementsByCurXml:curEle linkXml:linkEle];
            }
            continue;
        }
        
        if([self getXmlElementBooleanAttr:@"primary" defaultValue:FALSE xml:linkEle]){
            PYXmlElement * curEle = [self getPrimarySubElementByElements:curSubElements eleName:linkEle.elementName];
            if(curEle != nil){
                [self mergeXmlSubElementsByCurXml:curEle linkXml:linkEle];
                continue;
            }
        }
        [curXml addSubElement:linkEle];
    }
    NSLog(@"");
}

-(void) iteratorLinkXml:(PYXmlElement *) curXml{
    if(curXml == nil){
        return;
    }
    void * pointerCurXml = (__bridge void *)(curXml);
    NSString * culXmlPointerKey = kFORMAT(@"__xml_pointer_%ld", ((long) pointerCurXml));
    if([self.objectCaches valueForKey:culXmlPointerKey]){
        return;
    }
    [self.objectCaches setValue:@1 forKey:culXmlPointerKey];
    if(curXml.attributes != nil && [curXml.attributes valueForKey:@"link_xml_paths"]){
        NSString * linkXmlPaths = [curXml.attributes valueForKey:@"link_xml_paths"];
        if(linkXmlPaths == nil || linkXmlPaths.length == 0){
            return;
        }
        for(NSString * linkXmlPath in [linkXmlPaths componentsSeparatedByString:@","]){
            if(linkXmlPath == nil || linkXmlPath.length == 0){
                return;
            }
            PYXmlElement * linkXml = [self getXmlElementByPath:linkXmlPath];
            if(linkXml == nil){
                return;
            }
            [self mergeXmlSubElementsByCurXml:curXml linkXml:linkXml];
        }
    }
}


-(PYXmlElement *) getXmlElement:(PYXmlElement *) xml pathVas:(NSString *) path,...NS_REQUIRES_NIL_TERMINATION{
    if(path == nil){
        return nil;
    }
    if(path.length == 0){
        return nil;
    }
    if(xml == nil){
        return nil;;
    }
    [self iteratorLinkXml:xml];
    NSArray<PYXmlElement *> * elements = [xml elements];
    if(elements == nil){
        return nil;
    }
    if(elements.count == 0){
        return nil;
    }
    NSString * elementName = path;
    NSString * elementId = nil;
    int elementIndex = -1;
    if([path containsString:@"["]){
        NSUInteger index = [path rangeOfString:@"["].location;
        elementName = [path substringToIndex:index];
        NSString * value = [path substringFromIndex:index + 1];
        if(![[value substringFromIndex:value.length - 1] isEqual:@"]"]){
            @throw [NSException exceptionWithName:@"xml.element parse error" reason:kFORMAT(@"%@ has not end for ']'", value) userInfo:nil];
        }
        value = [value substringToIndex:value.length - 1];
        if([[value substringToIndex:1] isEqual:@"@"]){
            elementId = [value substringFromIndex:1];
        }else if([[value substringToIndex:1] isEqual:@"#"]){
            elementIndex = [[value substringFromIndex:1] intValue];
        }else{
            
        }
    }
    PYXmlElement * subXml = nil;
    int eleIndex = -1;
    for(PYXmlElement * ele in elements){
        if(![elementName isEqual:[ele elementName]]){
            continue;
        }
        eleIndex ++;
        subXml = ele;
        if(eleIndex != -1 && (eleIndex + 1) == elementIndex){
            break;
        }
        if(elementId != nil && [elementId isEqual:[ele.attributes valueForKey:@"id"]]){
            break;
        }
    }
    
    NSMutableArray<NSString *> * subPathVas = [NSMutableArray new];
    int vas_index = 2;
    va_list vas_list;
    va_start(vas_list, path);
    NSString * vas_item = nil;
    while ((vas_item = va_arg(vas_list, NSString *))) {
        vas_index ++;
        [subPathVas addObject:vas_item];
    }
    va_end(vas_list);
    [self iteratorLinkXml:subXml];
    if(subPathVas.count == 0){
        return subXml;
    }
    if(subXml == nil){
        return nil;
    }
    switch (subPathVas.count) {
        case 1:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0], nil];
        case 2:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1], nil];
        case 3:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2], nil];
        case 4:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3], nil];
        case 5:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4], nil];
        case 6:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5], nil];
        case 7:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6], nil];
        case 8:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7], nil];
        case 9:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8], nil];
        case 10:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9], nil];
        case 11:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9],[subPathVas objectAtIndex:10], nil];
        case 12:
            return [self getXmlElement:subXml pathVas:[subPathVas objectAtIndex:0],[subPathVas objectAtIndex:1],[subPathVas objectAtIndex:2],[subPathVas objectAtIndex:3],[subPathVas objectAtIndex:4],[subPathVas objectAtIndex:5],[subPathVas objectAtIndex:6],[subPathVas objectAtIndex:7],[subPathVas objectAtIndex:8],[subPathVas objectAtIndex:9],[subPathVas objectAtIndex:10],[subPathVas objectAtIndex:11], nil];
        default:
            @throw [NSException exceptionWithName:@"xml.element parse error" reason:kFORMAT(@"pathVas is not of max lenght, [%@]", [[subPathVas toData] toString]) userInfo:nil];
    }
}

@end
