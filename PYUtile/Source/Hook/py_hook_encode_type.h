//
//  py_hook_encode_type.h
//  PYUtile
//
//  Created by wlpiaoyi on 2016/12/6.
//  Copyright © 2016年 wlpiaoyi. All rights reserved.
//

#ifndef py_hook_encode_type_h
#define py_hook_encode_type_h
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#endif

char* py_getencodes_m(char* encodePointer[]);
char* py_sub_chars_m(const char * targetChar, int subIndex, const char * subChar);
char* py_copy_chars_m(const char * charCopy, size_t startIndex, size_t endIndex);
