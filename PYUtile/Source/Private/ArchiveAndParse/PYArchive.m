//
//  PYArchive.m
//  PYUtile
//
//  Created by wlpiaoyi on 2019/1/9.
//  Copyright © 2019 wlpiaoyi. All rights reserved.
//

#import "PYArchiveObject.h"
#import "PYInvoke.h"
#import "PYUtile.h"
#import "PYArchiveParse.h"
#import "NSString+Expand.h"

#import <objc/runtime.h>

static NSDictionary *PYObjectSuperPropertNameDict;
static char * PYObjectParsedictFailedKey = "pyobj_parsed_failed";
id _Nullable (^ _Nullable PYBlockValueParsetoObject) (NSObject * _Nonnull value, Class _Nonnull clazz) = nil;
@implementation PYArchiveObject

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PYObjectSuperPropertNameDict = @{@"hash":@YES,@"superclass":@YES,@"description":@YES,@"debugDescription":@YES};
    });
}
+(NSObject*) archvie:(nonnull NSObject *) object clazz:(nullable Class) clazz deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries{
    id result = [self valueArchive:object clazz:clazz];// [self __PY_NSOBJECT_EXPAND_OBJ_PARSET:object CLASS:clazz];
    if(result) return result;
    
    result = [self checkObject:object deep:deep fliteries:fliteries];// [self __PY_NSOBJECT_EXPAND_OBJ_CHECK:object DEEP:deep FILTERIRES:fliteries];
    if(result) return result;
    if(!clazz) clazz = [object class];
    
    if([object isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary * tempDict = [NSMutableDictionary new];
        for (NSString * key in (NSDictionary *)object) {
            NSObject * value = ((NSDictionary *)object)[key];
            if(!value) continue;
            if ([PYArchiveParse canParset:value.class]){
                value = [self valueArchive:value clazz:nil];// [NSObject __PY_NSOBJECT_EXPAND_OBJ_PARSET:value CLASS:clazz];
            }else{
                value = [self archvie:value clazz:nil deep:deep++ fliteries:fliteries]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:value CLAZZ:clazz DEEP:deep+1 FLITERIES:fliteries];
            }
            if(!value) continue;
            tempDict[key] = value;
        }
        if(tempDict.count == 0){
            NSMutableString * key = [NSMutableString new];
            [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
            [key appendString:@"_nodictvalue"];
            return @{key : [object debugDescription]};
        }
        return tempDict;
    }else if([object isKindOfClass:[NSArray class]]){
        NSMutableArray * tempArray = [NSMutableArray new];
        int tempDeep = deep + 1;
        for (id obj in (NSArray *)object) {
            [tempArray addObject:[self archvie:obj clazz:[obj class] deep:tempDeep fliteries:fliteries]];
        }
        return tempArray;
    }else if([object isKindOfClass:[NSSet class]]){
        NSMutableSet * tempSet = [NSMutableSet new];
        int tempDeep = deep + 1;
        for (id obj in (NSSet *)object) {
            [tempSet addObject:[self archvie:obj clazz:[obj class] deep:tempDeep fliteries:fliteries]];
        }
        return tempSet;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    unsigned int outCount2;
    Ivar *ivars = class_copyIvarList(clazz, &outCount2);
    @try {
        NSMutableString * removePName = [NSMutableString new];
        NSMutableArray<NSDictionary<NSString *, id> *> * archives = [NSMutableArray new];
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if(propertyName.length == 0) continue;
            const char * typeEncoding;
            bool flagCanExcute = true;
            unsigned int count;
            objc_property_attribute_t * attribute = property_copyAttributeList(property, &count);
            typeEncoding = attribute[0].value;
            char * ivarChars = "";
            for (int i = 0; i < count; i++) {
                if(strcasecmp("V", attribute[i].name) != 0) continue;
                ivarChars = (char *) attribute[i].value;
            }
            if(strcasecmp("", ivarChars) != 0){
                [removePName appendString:[NSString stringWithUTF8String:ivarChars]];
                [removePName appendString:@","];
            }
            unsigned long tedl = strlen(typeEncoding);
            if(strcasecmp(typeEncoding, @encode(id)) == 0
               || (tedl >= 4
                   && typeEncoding[0] == '@'
                   && typeEncoding[1] == '\"'
                   && typeEncoding[tedl - 1] == '\"')){
                   flagCanExcute = false;
                   for (int j = 0; j < count; j++) {//如果是弱连接则不会归档，因为指针值可能已经回收
                       if(strcasecmp(attribute[j].name, "&") == 0
                          || strcasecmp(attribute[j].name, "C") == 0){
                           flagCanExcute = true;
                           break;
                       }
                   }
               }
            if(!flagCanExcute){
                kPrintLogln("the property '%s' type '%s' is assign, we can't archived it", propertyName.UTF8String, typeEncoding);
                continue;
            }
            id returnValue = [PYArchiveObject archvieForDict:dict object:object varName:propertyName typeEncoding:typeEncoding];
            if(!returnValue) continue;
            [archives addObject:@{
                                  @"returnValue" : returnValue,
                                  @"dict":dict,
                                  @"varName":propertyName
                                  }];
        }
        
        for (int i = 0; i < outCount2; i++) {
            Ivar ivar = ivars[i];
            NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if([removePName containsString:ivarName]){
                continue;
            }
            if([dict valueForKey:ivarName] != nil) continue;
            const char * typeEncoding = ivar_getTypeEncoding(ivar);
            id returnValue = [PYArchiveObject archvieForDict:dict object:object varName:ivarName typeEncoding:typeEncoding];
            if(!returnValue) continue;
            [archives addObject:@{
                                  @"returnValue":returnValue,
                                  @"dict":dict,
                                  @"varName":ivarName
                                  }];
        }
        for (NSDictionary * arcDict in archives) {
            id returnValue = arcDict[@"returnValue"];
            id dict = arcDict[@"dict"];
            id varName = arcDict[@"varName"];
            if ([returnValue isKindOfClass:[NSArray class]]) {
                NSMutableArray * objs = [NSMutableArray new];
                for (id obj in (NSArray*)returnValue) {
                    int tempDeep = deep + 1;
                    id value = [self archvie:obj clazz:[obj class] deep:tempDeep fliteries:fliteries]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
                    if(value)[objs addObject:value];
                }
                returnValue = objs;
            }else if ([returnValue isKindOfClass:[NSSet class]]) {
                NSMutableArray * objs = [NSMutableArray new];
                for (NSObject * obj in (NSSet*)returnValue) {
                    int tempDeep = deep + 1;
                    NSObject * value = [self archvie:obj clazz:[obj class] deep:tempDeep fliteries:fliteries]; // [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
                    if(value)[objs addObject:value];
                }
                returnValue = objs;
            }else if ([returnValue isKindOfClass:[NSDictionary class]]) {
                returnValue = [self archvie:returnValue clazz:nil deep:deep + 1 fliteries:fliteries]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1 FLITERIES:fliteries];
            }else {
                id tempValue = [self archvie:returnValue clazz:clazz deep:deep + 1 fliteries:fliteries]; // [NSObject __PY_NSOBJECT_EXPAND_OBJ_PARSET:returnValue CLASS:clazz];
                if(tempValue) returnValue = tempValue;
                else returnValue = [self archvie:returnValue clazz:nil deep:deep + 1 fliteries:fliteries]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1  FLITERIES:fliteries];
            }
            if(!returnValue) continue;
            [dict setObject:returnValue forKey:[PYArchiveParse checkVarKey:varName]];
        }
    }
    @finally {
        free(properties);
        free(ivars);
    }
    if(dict.count == 0){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_properyandivar"];
        return @{key : [object debugDescription]};
    }
    return dict;
}

#pragma mark 归档数据
+(nullable NSObject *) archvieForDict:(nonnull NSMutableDictionary *) dict object:(nonnull NSObject *) object varName:(NSString *) varName typeEncoding:(const char *) typeEncoding{

    if(((NSNumber *)PYObjectSuperPropertNameDict[varName]).boolValue) return nil;//过滤Obj特殊属性
    NSObject * returnValue = nil;
    size_t tedl = strlen(typeEncoding);
    if(tedl == 0) return nil;
    
    if(typeEncoding[0] == '@' && typeEncoding[1] == '?'){//如果是block则不取值
        kPrintExceptionln("%s","block archiving is not supported at this time");
        return nil;
    }else if(((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}'))){//如果是未知结构体则不取值
        NSInvocation *invocation = [PYInvoke startInvoke:object action:sel_getUid(varName.UTF8String)];
        if(invocation == nil) return nil;
        if(strcasecmp(typeEncoding, @encode(CGRect)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGRectEdge)) == 0){
            CGRectEdge ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGSize)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGPoint)) == 0){
            CGRect ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(CGVector)) == 0){
            CGVector ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(NSRange)) == 0){
            NSRange ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(UIEdgeInsets)) == 0){
            UIEdgeInsets ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(strcasecmp(typeEncoding, @encode(UIOffset)) == 0){
            UIOffset ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
//        }else if(PYBlocktodictParsetStruct){
//            returnValue = PYBlocktodictParsetStruct(invocation,typeEncoding);
        }else return nil;
    }else if(strcasecmp(typeEncoding, @encode(SEL)) == 0){
        NSInvocation *invocation = [PYInvoke startInvoke:object action:sel_getUid(varName.UTF8String)];
        if(invocation == nil) return nil;
        SEL ptr;
        [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
        NSUInteger size = invocation.methodSignature.methodReturnLength;
        returnValue = [NSData dataWithBytes:&ptr length:size];
    }else{
        @try {
            returnValue = [object valueForKey:varName];
        } @catch (NSException *exception) {
            returnValue = nil;
            kPrintExceptionln("there has no value for propery or ivar that name is %s: [%s:%s]", varName.UTF8String, exception.name.UTF8String, exception.reason.UTF8String);
        }
    }
    
    if(!returnValue) return nil;
    id value = returnValue;
    Class clazz = [PYArchiveParse classFromTypeEncoding:typeEncoding];
    if(!(returnValue = [PYArchiveObject valueArchive:returnValue clazz:clazz])){
        return value;
    }
    
    [dict setObject:returnValue forKey:[PYArchiveParse checkVarKey:varName]];
    return nil;
}


+(nullable NSObject *) valueArchive:(nonnull NSObject *) value clazz:(nullable Class) clazz{
    NSObject * returnValue = nil;
    if(PYBlockValueParsetoObject && (returnValue = PYBlockValueParsetoObject(value, clazz))) return returnValue;
    return [PYArchiveParse valueArchive:value clazz:clazz];
}


+(nullable NSObject *) checkObject:(NSObject *) object deep:(int) deep fliteries:(nullable NSArray<Class> *) fliteries{
    
    if(fliteries && fliteries.count > 0 && [fliteries containsObject:object.class]){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_fliteries"];
        return @{key : [object debugDescription]};
    }
    
    if(deep > 10){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_deep"];
        return @{key : [object debugDescription]};
    }
    return nil;
}

@end
