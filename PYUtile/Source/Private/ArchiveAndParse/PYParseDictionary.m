//
//  PYParseDictionary.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

//// 字符串拷贝函数的实现
//char *strcpy(char *dest, const char *src)
//{
//    if ( !dest || !src )
//    {
//        return "";
//    }
//
//    if ( dest == src)
//    {
//        return dest ;
//    }
//
//    char *temp = dest ;
//
//    while( (*src) != '/0')
//    {
//        *dest = *src;
//        src++;
//        dest++;
//    }
//
//    dest = temp;
//    return dest;
//}

#import "PYParseDictionary.h"
#import "PYArchiveParse.h"
#import "PYUtile.h"
#import "PYInvoke.h"
#import "NSString+PYExpand.h"
#import "NSObject+PYExpand.h"

#import <CoreLocation/CoreLocation.h>

#define PY_INIT_PDINVOCATION NSInvocation * invocation = [PYInvoke startInvoke:target action:[PYInvoke parseFieldKeyToSetSel:fieldKey]];
#define PY_EXCET_PDINVOCATION \
    if(invocation){\
        [PYInvoke setInvoke:&ptr index:2 invocation:invocation];\
        [PYInvoke excuInvoke:nil returnType:nil invocation:invocation];\
    }

@implementation PYParseDictionary

+(BOOL) copyTypeEncoding:(char * *) typeEncoding clazz:(Class) clazz key:(NSString *) key{
    const char * keyChars = key.UTF8String;
    objc_property_t property = class_getProperty(clazz, keyChars);
    Ivar ivar = class_getInstanceVariable(clazz, keyChars);
    if(property || ivar){
        char * chars = [self copyTypeEncodingFromeProperty:property ivar:ivar];
        *typeEncoding = chars;
        
    } else {
        return NO;
    }
    return YES;
}

+(char *) copyTypeEncodingFromeProperty:(objc_property_t) property ivar:(Ivar) ivar{
    if(property){
        unsigned int count;
        objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
        const char * typeEnoding =  attribute[0].value;
        size_t l = strlen(typeEnoding);
        char * chars = malloc(l);
        chars = strcpy(chars, typeEnoding);
        free(attribute);
        return chars;
    }else if(ivar){
        const char * typeEnoding  = ivar_getTypeEncoding(ivar);
        size_t l = strlen(typeEnoding);
        char * chars = malloc(l);
        chars = strcpy(chars, typeEnoding);
        return chars;
    }
    return "";
}

+(nullable id) instanceClazz:(Class) clazz dictionary:(NSObject*) dictionary {
    
    if(dictionary == nil) return nil;
    
    id result = [PYArchiveParse parseValue:dictionary clazz:clazz];
    if(result) return result;
    
    if(![dictionary isKindOfClass:[NSDictionary class]]) return nil;
    if([clazz isKindOfClass:[NSDictionary class]] || [clazz isSubclassOfClass:[NSDictionary class]]) return dictionary;
    
    id target = [[clazz alloc] init];
    if (!target)  return nil;
    
    NSDictionary<NSString*, NSString *> * keyTypes = nil;
    if(class_getClassMethod(clazz, @selector(pyObjectGetKeysType))){
        keyTypes = [clazz performSelector:@selector(pyObjectGetKeysType)];
    }
    
    for (NSString *key in ((NSDictionary *)dictionary)) {
        NSString * fieldKey = [PYArchiveParse parseKeyToVar:key];
        id value = ((NSDictionary *)dictionary)[key];
        if (value == nil || value == [NSNull null]) {
            continue;
        }
        bool hasFree = YES;
        char * typeEncoding = NULL;
        if(keyTypes.count > 0){
            id obj = keyTypes[key];
            if(obj){
                hasFree = NO;
                if([obj isKindOfClass:[NSString class]]){
                    NSString * type = obj;
                    if(type.length){
                        typeEncoding = type.UTF8String;
                    }
                }else{
                    Class clazz = obj;
                    typeEncoding = kFORMAT(@"@\"%@\"",NSStringFromClass(clazz)).UTF8String;
                }
            }
        }
        
        if((typeEncoding == NULL || strlen(typeEncoding) == 0) && ![PYParseDictionary  copyTypeEncoding:&typeEncoding clazz:clazz key:fieldKey]){
            fieldKey = [NSString stringWithFormat:@"_%@",fieldKey];
            if(![PYParseDictionary  copyTypeEncoding:&typeEncoding clazz:clazz key:fieldKey]){
                kPrintLogln("the class [%s] has no ivar [%s] type [%s]", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String, NSStringFromClass([value class]).UTF8String);
                continue;
            }
        }
        if(typeEncoding == NULL){
            kPrintExceptionln("the class [%s]'s ivar [%s] has not found typeEncoding", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String);
            continue;
        }
        @try {
            size_t tedl = strlen(typeEncoding);
            if(tedl > 3 && typeEncoding[0] == '@' && typeEncoding[1] == '\"' && typeEncoding[tedl-1] == '\"'){
                Class cClazz = [PYArchiveParse classFromTypeEncoding:typeEncoding];
                if(cClazz == nil){
                    value = nil;
                    continue;
                }
                if ([cClazz isSubclassOfClass:[NSArray class]] || [cClazz isSubclassOfClass:[NSSet class]]) {
                    objc_property_t cproperty = class_getProperty(clazz, [NSString stringWithFormat:@"property_%@",fieldKey].UTF8String);
                    Ivar civar = class_getInstanceVariable(clazz, [NSString stringWithFormat:@"ivar_%@",fieldKey].UTF8String);
                    Class valuesClazz = nil;
                    if(cproperty || civar){
                        char * teding = [PYParseDictionary copyTypeEncodingFromeProperty:cproperty ivar:civar];
                        valuesClazz = [PYArchiveParse classFromTypeEncoding:teding];
                        free(teding);
                    }

                    if(valuesClazz == nil){
                        valuesClazz  = keyTypes[[NSString stringWithFormat:@"ivar_%@",fieldKey]];
                    }
                    if(valuesClazz){
                        value = [self forEachValue:value clazz:valuesClazz];
                    }else{
                        value = value;
                    }
                }else if([PYArchiveParse canParset:cClazz]){
                    value = [PYArchiveParse parseValue:value clazz:cClazz];
                }else{
                    
                    NSString * clazzName = [NSString stringWithUTF8String:typeEncoding];
                    clazzName = [clazzName substringWithRange:NSMakeRange(2, clazzName.length - 3)];
                    Class  cClazz = NSClassFromString(clazzName);
                    value = [self instanceClazz:cClazz dictionary:value];
                }
            }else if((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}')){//结构体赋
                if(strcasecmp(typeEncoding, @encode(CGSize)) == 0){
                    CGSize ptr = CGSizeFromString(value);
                    value = [NSValue valueWithCGSize:ptr];
                }else if(strcasecmp(typeEncoding, @encode(CGPoint)) == 0){
                    CGPoint ptr = CGPointFromString(value);
                    value = [NSValue valueWithCGPoint:ptr];
                }else if(strcasecmp(typeEncoding, @encode(CGRect)) == 0){
                    CGRect ptr = CGRectFromString(value);
                    value = [NSValue valueWithCGRect:ptr];
                }else if(strcasecmp(typeEncoding, @encode(NSRange)) == 0){
                    NSRange ptr = NSRangeFromString(value);
                    value = [NSValue valueWithRange:ptr];
                }else if(strcasecmp(typeEncoding, @encode(UIEdgeInsets)) == 0){
                    UIEdgeInsets ptr = UIEdgeInsetsFromString(value);
                    value = [NSValue valueWithUIEdgeInsets:ptr];
                }else if(strcasecmp(typeEncoding, @encode(CGVector)) == 0){
                    CGVector ptr = CGVectorFromString(value);
                    value = [NSValue valueWithCGVector:ptr];
                }else if(strcasecmp(typeEncoding, @encode(UIOffset)) == 0){
                    UIOffset ptr = UIOffsetFromString(value);
                    value = [NSValue valueWithUIOffset:ptr];
                }else if(strcasecmp(typeEncoding, @encode(CLLocationCoordinate2D)) == 0){
                    NSInvocation * invocation = [PYInvoke startInvoke:target action:[PYInvoke parseFieldKeyToSetSel:fieldKey]];
                    CLLocationCoordinate2D ptr = CLLocationCoordinate2DMake(((NSNumber *)value[@"latitude"]).doubleValue, ((NSNumber *)value[@"longitude"]).doubleValue);
                    if(invocation){
                        [PYInvoke setInvoke:&ptr index:2 invocation:invocation];
                        [PYInvoke excuInvoke:nil returnType:nil invocation:invocation];
                    }
                    value = nil;
                }else value = nil;
            }else if (strcasecmp(typeEncoding, @encode(SEL)) == 0){
                NSInvocation *invocation = [PYInvoke startInvoke:target action:[PYInvoke parseFieldKeyToSetSel:fieldKey]];
                if (invocation && [value isKindOfClass:[NSString class]]){
                    NSData * tempData = [((NSString *) value) toData];
                    value = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
                    value = [NSValue valueWithBytes:((NSData*)value).bytes objCType:typeEncoding];
                    SEL ptr;
                    [value getValue:&ptr];
                    [PYInvoke setInvoke:&ptr index:2 invocation:invocation];
                    [PYInvoke excuInvoke:nil returnType:nil invocation:invocation];
                }
                value = nil;
            }
            if(value){
                @try {
                    [target setValue:value forKey:fieldKey];
                } @catch (NSException *exception) {
                    kPrintExceptionln("%s:%s [key:%@ value:%@]",exception.name.UTF8String, exception.reason.UTF8String, fieldKey, value);
                }
            }
        } @finally {
            if(hasFree) free(typeEncoding);
        }
    }
    
    return target;
}


+(NSObject *) forEachValue:(NSObject *) value clazz:(Class) clazz{
    
    if(value == nil) return nil;
    if([value isKindOfClass:[NSArray class]]){
        NSMutableArray * result = [NSMutableArray new];
        for (NSObject * obj in (NSArray *)value) {
            id addObj = [self forEachValue:obj clazz:clazz];
            if(addObj)[result addObject: addObj];
            else kPrintExceptionln("the add value is null obj:[%@] class:[%@]", obj, NSStringFromClass(clazz));
        }
        return result;
    }else if([value isKindOfClass:[NSSet class]]){
        NSMutableSet * result = [NSMutableSet new];
        for (NSObject * obj in (NSSet *)value) {
            id addObj = [self forEachValue:obj clazz:clazz];
            if(addObj)[result addObject: addObj];
            else kPrintExceptionln("the add value is null obj:[%@] class:[%@]", obj, NSStringFromClass(clazz));
        }
        return result;
    }else{
        return [self instanceClazz:clazz dictionary:value];
    }
    
}

@end
