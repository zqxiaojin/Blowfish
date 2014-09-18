//
//  BlowfishEncoder+String.m
//  Blowfish
//
//  Created by Jin on 9/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BlowfishEncoder+String.h"
#include <string.h>
@implementation BlowfishEncoder (String)


- (BlowfishEncoder*)initWithTextKey:(NSString*) textKey
{
    return [self initWithKey:[textKey dataUsingEncoding:NSUTF8StringEncoding]];
}

#define cTOv(c)  (((c) > 'a') ? ((c) - 'a' + 10) : ((c) - '0'))

unsigned char vToc(unsigned char v);
unsigned char vToc(unsigned char v)
{
    return (((v) > 9) ? ((v) - 0xa + 'a' ) : ((v) + '0'));
}
+ (NSData*)HEXStringToData:(NSString*)string
{
    NSData* result = nil;
    do
    {
        const unsigned char* data = (const unsigned char*)[string UTF8String];
        unsigned long utfLen = strlen((const char *)data);
        if (utfLen % 2 != 0) {
            break;
        }
        unsigned long len = utfLen / 2;
        
        NSMutableData* tempData = [NSMutableData dataWithLength:len];
        
        unsigned char* tempDataPtr = (unsigned char*)[tempData mutableBytes];
        
        for (unsigned long i = 0; i < len; ++i)
        {
            tempDataPtr[i] = (unsigned char)(cTOv(data[i * 2] << 4) + (cTOv(data[i * 2 + 1])));
        }
        
        result = tempData;
        
    } while (false);

    return result;
}

+ (NSString*)NSDataToHEXString:(NSData*)data
{
    unsigned char* tempDataPtr = (unsigned char*)[data bytes];
    unsigned long len = [data length];
    NSMutableString* mString = [NSMutableString stringWithCapacity:len * 2];
    
    for (unsigned long i = 0; i < len; ++i)
    {
        unsigned char c = tempDataPtr[i];
        [mString appendFormat:@"%c%c", vToc(c >> 4) , vToc(c & 15)];
    }
    
    return mString;
}

- (NSString*)encryptECBWithString:(NSString*)stringToBeEncrypt
{
    return [BlowfishEncoder NSDataToHEXString:[self encryptECBWithData:[stringToBeEncrypt dataUsingEncoding:NSUTF8StringEncoding]]];
}


- (NSString*)decryptECBWithHEXString:(NSString*)stringToBeDecrypt
{
    return [BlowfishEncoder NSDataToHEXString:[self decryptECBWithData:[BlowfishEncoder HEXStringToData:stringToBeDecrypt]]];
}

@end
