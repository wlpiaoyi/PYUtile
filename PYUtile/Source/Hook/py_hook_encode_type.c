//
//  py_hook_encode_type.c
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//
//
#include "py_hook_encode_type.h"

char* py_getencodes_m(char* encodePointer[]){
    size_t length = 0;
    int index = 0;
    while (true) {
        char *encode = encodePointer[index];
        if(!encode){
            index = 0;
            break;
        }
        length += strlen(encode);
        index++;
    }
    
    char *encodes = calloc(length+1, sizeof(char));
    
    index = 0;
    int indexA = 0;
    while (true) {
        char *encode = encodePointer[index];
        if(!encode){
            index = 0;
            break;
        }
        
        size_t l = strlen(encode);
        for (size_t _index = 0; _index < l; _index++) {
            encodes[indexA] = encode[_index];
            indexA ++;
        }
        index ++;
    }
    return encodes;
}


char* py_sub_chars_m(const char * targetChar, int subIndex, const char * subChar){
    size_t _targetLength = strlen(targetChar);
    size_t _subLength = strlen(subChar);
    
    size_t _subIndex = subIndex < 0 ? 0 : subIndex;
    _subIndex = _subIndex > _targetLength - 1 ? _targetLength - 1 : _subIndex;
    
    char *charValue = calloc(_targetLength + _subLength, sizeof(char));
    for(size_t index = 0; index < _targetLength + _subLength; index++){
        char c;
        if(index < _subIndex){
            c = targetChar[index];
        }else if(index < _subLength + _subIndex){
            c = subChar[index - _subIndex];
        }else{
            c = targetChar[index - _subIndex - _subLength];
        }
        charValue[index] = c;
    }
    return charValue;
}

char* py_copy_chars_m(const char * charCopy, size_t startIndex, size_t endIndex){
    size_t _startIndex = startIndex == -1 ? 0 : startIndex;
    size_t _endIndex = endIndex == -1? strlen(charCopy) : endIndex;
    char *charValue = calloc(_endIndex - _startIndex, sizeof(char));
    for(size_t index = _startIndex; index < _endIndex; index++){
        charValue[index-_startIndex] = charCopy[index];
    }
    return charValue;
}
