//
//  PYParseDictionary.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYParseDictionary.h"
#import "PYArchiveParse.h"
#import "PYUtile.h"
#import "PYInvoke.h"
#import "NSString+PYExpand.h"

@implementation PYParseDictionary

+(BOOL)getTypeEncoding:(const char * *) typeEncoding clazz:(Class) clazz key:(NSString *) key{
    objc_property_t property = class_getProperty(clazz, key.UTF8String);
    Ivar ivar = class_getInstanceVariable(clazz, key.UTF8String);
    if(property || ivar){
        *typeEncoding = [self getTypeEncodingFromeProperty:property ivar:ivar];
    } else {
        return NO;
    }
    return YES;
}

+(const char *) getTypeEncodingFromeProperty:(objc_property_t) property ivar:(Ivar) ivar{
    if(property){
        unsigned int count;
        objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
        return attribute[0].value;
    }else if(ivar){
        return ivar_getTypeEncoding(ivar);
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
    
    for (NSString *key in ((NSDictionary *)dictionary)) {
        NSString * fieldKey = [PYArchiveParse parseKeyToVar:key];
        id value = ((NSDictionary *)dictionary)[key];
        if (value == nil || value == [NSNull null]) {
            continue;
        }
        __block const char * typeEncoding = "";
        if(![PYParseDictionary getTypeEncoding:&typeEncoding clazz:clazz key:fieldKey]){
            fieldKey = [NSString stringWithFormat:@"_%@",fieldKey];
            if(![PYParseDictionary getTypeEncoding:&typeEncoding clazz:clazz key:fieldKey]){
                kPrintLogln("the class [%s] has no ivar [%s] type [%s]", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String, NSStringFromClass([value class]).UTF8String);
                continue;
            }
        }
        
        if(strlen(typeEncoding) <= 0){
            kPrintExceptionln("the class [%s]'s ivar [%s] has not found typeEncoding", NSStringFromClass(clazz).UTF8String, fieldKey.UTF8String);
            continue;
        }
        
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
                    const char * teding = [PYParseDictionary getTypeEncodingFromeProperty:cproperty ivar:civar];
                    valuesClazz = [PYArchiveParse classFromTypeEncoding:teding];
                }
                if(valuesClazz){
                    value = [self forEachValue:value clazz:valuesClazz];
                }else{
                    value = value;
                }
            }else if([PYArchiveParse canParset:cClazz]){
                value = [PYArchiveParse parseValue:value clazz:cClazz];
            }else{
                Class  cClazz = NSClassFromString([[[NSString stringWithUTF8String:typeEncoding] substringToIndex:tedl-1] substringFromIndex:2]);
                value = [self instanceClazz:cClazz dictionary:value];
            }
        }else if((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}')){//结构体赋值
//            NSData * tempData = value;
//            value = [NSValue valueWithBytes:tempData.bytes objCType:typeEncoding];
        }else if (strcasecmp(typeEncoding, @encode(SEL)) == 0){
            NSString * setActionName = [NSString stringWithFormat:@"set%@%@:", [[fieldKey uppercaseString] substringToIndex:1], [fieldKey substringFromIndex:1]];
            NSInvocation *invocation = [PYInvoke startInvoke:target action:sel_getUid(setActionName.UTF8String)];
            if (invocation
                && [value isKindOfClass:[NSString class]]){
                NSData * tempData = [((NSString *) value) toData];
                value = [[NSData alloc] initWithBase64EncodedData:tempData options:0];
                value = [NSValue valueWithBytes:((NSData*)value).bytes objCType:typeEncoding];
                SEL v;
                [value getValue:&v];
                [PYInvoke setInvoke:&v index:2 invocation:invocation];
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
