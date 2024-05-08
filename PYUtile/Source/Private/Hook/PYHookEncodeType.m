//
//  PYHookEncodeType.m
//  PYUtile
//
//  Created by piaoyi wl on 2024/4/28.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import "PYHookEncodeType.h"

@implementation PYHookEncodeType

+(char *) copyChars:(const char *) charCopy startIndex:(size_t) startIndex endIndex:(size_t) endIndex{
    size_t _startIndex = startIndex == -1 ? 0 : startIndex;
    size_t _endIndex = endIndex == -1? strlen(charCopy) : endIndex;
    char *charValue = calloc(_endIndex - _startIndex, sizeof(char));
    for(size_t index = _startIndex; index < _endIndex; index++){
        charValue[index-_startIndex] = charCopy[index];
    }
    return charValue;
}

@end
