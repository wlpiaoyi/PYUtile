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

#import "NSObject+PYDictionary.h"
#import "NSObject+PYExpand.h"
#import "NSData+PYExpand.h"
#import "NSString+PYExpand.h"

#import <objc/runtime.h>
#import <CoreLocation/CoreLocation.h>



NSDictionary * PY_OBJ_PROPER_NAME_DICT;
NSDictionary * PY_OBJ_IVAR_NAME_DICT;

static char * PYObjectParsedictFailedKey = "pyobj_parsed_failed";
id _Nullable (^ _Nullable PYBlockValueParsetoObject) (NSObject * _Nonnull value, Class _Nonnull clazz) = nil;

@implementation PYArchiveObject

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PY_OBJ_PROPER_NAME_DICT = @{@"hash":@YES,@"superclass":@YES,@"description":@YES,@"debugDescription":@YES};
        PY_OBJ_IVAR_NAME_DICT = @{@"_hash":@YES,@"_superclass":@YES,@"_description":@YES,@"_debugDescription":@YES};
    });
}

+(void) iteratorWithObject:(nonnull NSObject *) object clazz:(nullable Class) clazz hasGoDeep:(BOOL) hasGoDeep userInfo:(nullable id) userInfo
     blockExcute:(void (^_Nonnull)(NSObject * object, NSString * filedName, const char * typeEncoding, id userInfo, BOOL isIvar)) blockExcute{
 
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
    
    unsigned int outCount2;
    Ivar *ivars = class_copyIvarList(clazz, &outCount2);
    @try {
        NSDictionary<NSString*, NSString *> * keyTypes = nil;
        if([clazz conformsToProtocol:@protocol(PYObjectParseProtocol)] && class_getClassMethod(clazz, @selector(pyObjectGetKeysType))){
            keyTypes = [clazz performSelector:@selector(pyObjectGetKeysType)];
        }
        NSArray<NSString *> * parseKeys = nil;
        if([object conformsToProtocol:@protocol(PYObjectParseProtocol)]){
            if([object respondsToSelector:@selector(pyObjectGetKeysForParseValue)]){
                parseKeys = [object performSelector:@selector(pyObjectGetKeysForParseValue)];
            }
        }
        NSMutableArray<NSString *> * removePNames = [NSMutableArray new];
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if(((NSNumber *)PY_OBJ_PROPER_NAME_DICT[propertyName]).boolValue) continue;//过滤Obj特殊属性
            if(parseKeys && ![parseKeys containsObject:propertyName]) continue;
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
                [removePNames addObject:[NSString stringWithUTF8String:ivarChars]];
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
            free(attribute);
            if(!flagCanExcute){
                kPrintLogln("the property '%s' type '%s' is assign, we can't iterator it", propertyName.UTF8String, typeEncoding);
                continue;
            }
            blockExcute(object, propertyName, typeEncoding, userInfo, NO);
        }
        
        for (int i = 0; i < outCount2; i++) {
            Ivar ivar = ivars[i];
            NSString * ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if(((NSNumber *)PY_OBJ_IVAR_NAME_DICT[ivarName]).boolValue) continue;//过滤Obj特殊属性
            if([removePNames containsObject:ivarName]){
                continue;
            }
            if(parseKeys && ![parseKeys containsObject:ivarName]){
                continue;
            }
            
            char * typeEncoding = ivar_getTypeEncoding(ivar);
            if(keyTypes.count > 0){
                NSString * type = keyTypes[kFORMAT(@"%s",ivar_getName(ivar))];
                if(type.length) typeEncoding = type.UTF8String;
            }
            NSLog(@"%s", typeEncoding);
            blockExcute(object, ivarName, typeEncoding, userInfo, YES);
        }
        if(!hasGoDeep) return;
        clazz = class_getSuperclass(clazz);
        if(!clazz) return;
        if(clazz == [NSObject class]) return;
        if(clazz == [UIResponder class]) return;
        if(clazz == [UIView class]) return;
        if(clazz == [UIViewController class]) return;
        if([clazz isNativelibraryClass]) return;
        [self iteratorWithObject:object clazz:clazz hasGoDeep:hasGoDeep userInfo:userInfo blockExcute:blockExcute];
    }
    @finally {
        free(properties);
        free(ivars);
    }
}

+(NSObject*) archvie:(nonnull NSObject *) object clazz:(nullable Class) clazz deep:(int) deep{
    BOOL hasGoDeep = clazz ? NO : YES;
    id result = [self valueArchive:object clazz:clazz];// [self __PY_NSOBJECT_EXPAND_OBJ_PARSET:object CLASS:clazz];
    if(result) return result;
    
    result = [self checkObject:object deep:deep];// [self __PY_NSOBJECT_EXPAND_OBJ_CHECK:object DEEP:deep FILTERIRES:fliteries];
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
                value = [self archvie:value clazz:nil deep:deep + 1]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:value CLAZZ:clazz DEEP:deep+1 FLITERIES:fliteries];
            }
            if(!value) continue;
            tempDict[key] = value;
        }
        if(tempDict.count == 0){
            NSMutableString * key = [NSMutableString new];
            [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
            [key appendString:@"_nodictvalue"];
            return @{key : [object description]};
        }
        return tempDict;
    }else if([object isKindOfClass:[NSArray class]]){
        NSMutableArray * tempArray = [NSMutableArray new];
        int tempDeep = deep + 1;
        for (id obj in (NSArray *)object) {
            [tempArray addObject:[self archvie:obj clazz:[obj class] deep:tempDeep]];
        }
        return tempArray;
    }else if([object isKindOfClass:[NSSet class]]){
        NSMutableSet * tempSet = [NSMutableSet new];
        int tempDeep = deep + 1;
        for (id obj in (NSSet *)object) {
            [tempSet addObject:[self archvie:obj clazz:[obj class] deep:tempDeep]];
        }
        return tempSet;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    kAssign(self);
    [self iteratorWithObject:object clazz:clazz hasGoDeep:hasGoDeep userInfo:dict blockExcute:^(NSObject * _Nonnull object, NSString * _Nonnull filedName, const char * _Nonnull typeEncoding, id  _Nonnull userInfo, BOOL isIvar) {
        kStrong(self);
        NSRange range = [filedName rangeOfString:@"__remove_dict"];
        if(range.length == 13 && range.location == 0){
            return;
        }
        NSMutableDictionary *dict = userInfo;
        id returnValue = nil;
        if(isIvar){
            if([dict valueForKey:filedName] != nil) return;
            returnValue = [PYArchiveObject archvieForDict:dict object:object varName:filedName typeEncoding:typeEncoding];
            if(!returnValue) return;
        }else{
            returnValue = [PYArchiveObject archvieForDict:dict object:object varName:filedName typeEncoding:typeEncoding];
            if(!returnValue) return;
        }
        if(![PYArchiveParse canParset:[returnValue class]]){
            returnValue = [self archvie:returnValue clazz:[PYArchiveParse classFromTypeEncoding:typeEncoding] deep:deep + 1];
        }
        [self __PY_ARCHIVE_PARSE:returnValue dict:dict varName:filedName clazz:clazz deep:deep];
    }];
    if(dict.count == 0){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_properyandivar"];
        return @{key : [object description]};
    }
    return dict;
}

+(void) __PY_ARCHIVE_PARSE:(nonnull id) returnValue dict:(nonnull NSDictionary *) dict varName:(nonnull NSString *) varName clazz:(nullable Class) clazz deep:(int) deep{
    if ([returnValue isKindOfClass:[NSArray class]]) {
        NSMutableArray * objs = [NSMutableArray new];
        for (id obj in (NSArray*)returnValue) {
            int tempDeep = deep + 1;
            id value = [self archvie:obj clazz:[obj class] deep:tempDeep]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
            if(value)[objs addObject:value];
        }
        returnValue = objs;
    }else if ([returnValue isKindOfClass:[NSSet class]]) {
        NSMutableArray * objs = [NSMutableArray new];
        for (NSObject * obj in (NSSet*)returnValue) {
            int tempDeep = deep + 1;
            NSObject * value = [self archvie:obj clazz:[obj class] deep:tempDeep]; // [NSObject __PY_OBJ_TO_DICT_WITH_OBJ:obj CLAZZ:[obj class] DEEP:deep+1 FLITERIES:fliteries];
            if(value)[objs addObject:value];
        }
        returnValue = objs;
    }else if ([returnValue isKindOfClass:[NSDictionary class]]) {
        returnValue = [self archvie:returnValue clazz:nil deep:deep + 1]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1 FLITERIES:fliteries];
    }else {
        id tempValue = [self archvie:returnValue clazz:clazz deep:deep + 1]; // [NSObject __PY_NSOBJECT_EXPAND_OBJ_PARSET:returnValue CLASS:clazz];
        if(tempValue) returnValue = tempValue;
        else returnValue = [self archvie:returnValue clazz:nil deep:deep + 1]; //[NSObject __PY_OBJ_TO_DICT_WITH_OBJ:returnValue CLAZZ:nil DEEP:deep+1  FLITERIES:fliteries];
    }
    if(!returnValue) return;
    [dict setValue:returnValue forKey:[PYArchiveParse parseVarToKey:varName]];
}

#pragma mark 归档数据
+(nullable NSObject *) archvieForDict:(nonnull NSMutableDictionary *) dict object:(nonnull NSObject *) object varName:(NSString *) varName typeEncoding:(const char *) typeEncoding{

    if(((NSNumber *)PY_OBJ_PROPER_NAME_DICT[varName]).boolValue) return nil;//过滤Obj特殊属性
    if((typeEncoding[0] == '@' && typeEncoding[1] == '?')){//如果是block则不取值
        kPrintExceptionln("%s","block archiving is not supported at this time");
        return nil;
    }
    NSObject * returnValue = nil;
    size_t tedl = strlen(typeEncoding);
    if(tedl == 0) return nil;

    @try {
        if(strcasecmp(typeEncoding, @encode(SEL)) == 0){//如果是SEL
            NSInvocation *invocation = [PYInvoke startInvoke:object action:sel_getUid(varName.UTF8String)];
            if(invocation == nil) return nil;
            SEL ptr;
            [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
            NSUInteger size = invocation.methodSignature.methodReturnLength;
            returnValue = [NSData dataWithBytes:&ptr length:size];
        }else if(((typeEncoding[0] == '{' && typeEncoding[tedl-1] == '}'))){//如果是结构体
            
            NSInvocation *invocation = [PYInvoke startInvoke:object action:sel_getUid(varName.UTF8String)];
            if(invocation == nil) return nil;
//                NSUInteger size = invocation.methodSignature.methodReturnLength;
//                returnValue = [NSData dataWithBytes:&ptr length:size];
            if(strcasecmp(typeEncoding, @encode(CGSize)) == 0){
                CGSize ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromCGSize(ptr);
            }else if(strcasecmp(typeEncoding, @encode(CGPoint)) == 0){
                CGPoint ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromCGPoint(ptr);
            }else if(strcasecmp(typeEncoding, @encode(CGRect)) == 0){
                CGRect ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromCGRect(ptr);
            }else if(strcasecmp(typeEncoding, @encode(NSRange)) == 0){
                NSRange ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromRange(ptr);
            }else if(strcasecmp(typeEncoding, @encode(UIEdgeInsets)) == 0){
                UIEdgeInsets ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromUIEdgeInsets(ptr);
            }else if(strcasecmp(typeEncoding, @encode(CGVector)) == 0){
                CGVector ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromCGVector(ptr);
            }else if(strcasecmp(typeEncoding, @encode(UIOffset)) == 0){
                UIOffset ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = NSStringFromUIOffset(ptr);
            }else if(strcasecmp(typeEncoding, @encode(CLLocationCoordinate2D)) == 0){
                CLLocationCoordinate2D ptr;
                [PYInvoke excuInvoke:&ptr returnType:nil invocation:invocation];
                returnValue = @{@"latitude":@(ptr.latitude), @"longitude":@(ptr.longitude)};
            }else{
                returnValue = nil;
//                NSValue * value = [object valueForKey:varName];
//                NSUInteger size;
//                NSGetSizeAndAlignment(typeEncoding, &size, NULL);
//                void * ptr = malloc(size);
//                [value getValue:ptr];
//                NSData * data = [NSData dataWithBytes:ptr length:size];
//                if(data.length){
//                    returnValue = [data toBase64String];
//                }else returnValue = nil;
//                free(ptr);
            }
        }else{
            returnValue = [object valueForKey:varName];
        }
    } @catch (NSException *exception) {
        returnValue = nil;
        kPrintExceptionln("there has no value for propery or ivar that name is %s: [%s:%s]", varName.UTF8String, exception.name.UTF8String, exception.reason.UTF8String);
    }
    
    if(!returnValue) return nil;
    Class clazz = [PYArchiveParse classFromTypeEncoding:typeEncoding];
    id value = returnValue;
    if(!(returnValue = [PYArchiveObject valueArchive:returnValue clazz:clazz])){
        return value;
    }
    [dict setObject:returnValue forKey:[PYArchiveParse parseVarToKey:varName]];
    return nil;
}


+ (NSObject * _Nullable)extracted:(Class  _Nullable __unsafe_unretained)clazz value:(NSObject * _Nonnull)value {
    return [PYArchiveParse valueArchive:value clazz:clazz];
}

+(nullable NSObject *) valueArchive:(nonnull NSObject *) value clazz:(nullable Class) clazz{
    NSObject * returnValue = nil;
    if(PYBlockValueParsetoObject && (returnValue = PYBlockValueParsetoObject(value, clazz))) return returnValue;
    return [self extracted:clazz value:value];
}


+(nullable NSObject *) checkObject:(NSObject *) object deep:(int) deep{
    if(deep > 10){
        NSMutableString * key = [NSMutableString new];
        [key appendString:[NSString stringWithUTF8String:PYObjectParsedictFailedKey]];
        [key appendString:@"_deep"];
        return @{key : [object description]};
    }
    return nil;
}

@end
