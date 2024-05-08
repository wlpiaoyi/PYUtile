//
//  PYDataFunction.m
//  PYUtile
//
//  Created by piaoyi wl on 2024/4/30.
//  Copyright © 2024 wlpiaoyi. All rights reserved.
//

#import "PYDataFunction.h"

@implementation PYDataFunction

+(long) data16To10:(const char *) value{
    size_t length = strlen(value);
    if(length <= 2) return 0;
    if(value[0] != '0' || value[1] != 'X') return 0;
    long integer = 0;
    long index = 0;
    for (long i = length - 1; i >= 2; --i) {
        long c = (long)value[i];
        if(c >= 48 && c <= 57){
            integer += (c-48) << (4 * index);
        }else if(c >= 65 && c <= 70){
            integer += (c-55) << (4 * index);
        }
        index++;
    }
    return integer;
}


+(long) data2To10:(const char *) value{
    size_t length = strlen(value);
    if(length <= 2) return 0;
    if(value[0] != '0' || value[1] != 'B') return 0;
    long integer = 0;
    long index = 0;
    for (long i = length - 1; i >= 2; --i) {
        char c = value[i];
        if(c == '1'){
            integer += 1 << (1 * index);
        }
        index++;
    }
    return integer;
}



@end
