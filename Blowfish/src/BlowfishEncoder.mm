//
//  BlowfishEncoder.m
//  Blowfish
//
//  Created by LiangJin on 14-9-5.
//  Copyright (c) 2014年 LiangJin. All rights reserved.
//

#import "BlowfishEncoder.h"
#import "Blowfish.h"

struct DataWrapper
{
    unsigned char* m_pointer;
    unsigned long  m_position;
    unsigned long  m_length;
};

static void appendByte(unsigned char byte, void *_data)
{
    DataWrapper *data = ( DataWrapper*) _data;
    if (data->m_position < data->m_length)
    {
        data->m_pointer[data->m_position++] = byte;
    }
    else
    {
        assert(0);
    }
}

unsigned long PKCS5PaddingLength(const unsigned char* data, unsigned long datalength);

unsigned long PKCS5PaddingLength(const unsigned char* data, unsigned long datalength)
{
    unsigned char length = 0;
    do {
        if (!data || datalength < 8)
        {
            assert(0);
            break;
        }
        
        length = data[datalength - 1];
        
        
        if (length > 0 && length <= 8)
        {
            for (unsigned long i = 0; i < length; ++i)
            {
                if (length != data[datalength - i - 1])
                {
                    return 0;
                }
            }
        }
        else
        {
            assert(0);
        }
        
    } while (false);
    
    return length;
}

@interface BlowfishEncoder ()
{
    
}
@property (nonatomic,retain)NSData* key;

@end

@implementation BlowfishEncoder

@synthesize key = m_key;
@synthesize enablePadding = m_enablePadding;

- (instancetype)initWithKey:(NSData*) dataKey
{
    if (self = [super init])
    {
        assert([dataKey length] > 0);
        
        if ([dataKey length] > 0)
        {
            self.key = dataKey;
            m_enablePadding = TRUE;
        }
        
    }
    return self;
}

- (void)dealloc
{
    [m_key release];
    [super dealloc];
}

- (NSData*)encryptECBWithData:(NSData*)dataToBeEncrypt
{
    NSMutableData* encryptData = nil;
    do
    {
        if (dataToBeEncrypt == nil || [self.key length] == 0)
        {
            assert(0);
            break;
        }
        unsigned long inputLength = [dataToBeEncrypt length];

        //padding
        unsigned char padding_length = 0;
        
        if (m_enablePadding)
        {
            padding_length = inputLength % sizeof(uint64_t);
            if (padding_length == 0)
                padding_length = sizeof(uint64_t);
            else
                padding_length = sizeof(uint64_t) - padding_length;
        }
        
        encryptData = [NSMutableData dataWithLength:inputLength + padding_length];
        if (encryptData == nil)
        {
            break;
        }
        
        DataWrapper dw;
        dw.m_pointer = (unsigned char*)[encryptData mutableBytes];
        dw.m_position = 0;
        dw.m_length = [encryptData length];
        
        struct blf_ecb_ctx ctx;
        Blowfish_ecb_start(&ctx,
                           true,
                           (unsigned char*)[m_key bytes],
                           (int)[m_key length],
                           appendByte,
                           (void*) &dw);
        
        unsigned char* bytes = (unsigned char*)[dataToBeEncrypt bytes];
        unsigned long len = inputLength;
        
        for (unsigned long i = 0; i < len; i++)
        {
            Blowfish_ecb_feed(&ctx, bytes[i]);
        }
        for (unsigned long i = 0; i < padding_length; i++)
        {
            Blowfish_ecb_feed(&ctx, padding_length);
        }
        
        Blowfish_ecb_stop(&ctx);
        
        
    } while (false);

    
    return encryptData;
}

- (NSData*)decryptECBWithData:(NSData*)dataToBeDecrypt
{
    NSMutableData* decryptData = nil;
    do
    {
        if (dataToBeDecrypt == nil || [self.key length] == 0)
        {
            assert(0);
            break;
        }

        unsigned long length = [dataToBeDecrypt length];
        decryptData = [NSMutableData dataWithLength:length];
        if (decryptData == nil)
        {
            break;
        }
        
        DataWrapper dw;
        dw.m_pointer = (unsigned char*)[decryptData mutableBytes];
        dw.m_position = 0;
        dw.m_length = [decryptData length];
        
        struct blf_ecb_ctx ctx;
        Blowfish_ecb_start(&ctx,
                           false,
                           (unsigned char*)[m_key bytes],
                           (int)[m_key length],
                           appendByte,
                           (void*) &dw);
        
        unsigned char* bytes = (unsigned char*)[dataToBeDecrypt bytes];
        unsigned long len = [dataToBeDecrypt length];
        
        for (unsigned long i = 0; i < len; i++)
        {
            Blowfish_ecb_feed(&ctx, bytes[i]);
        }
        
        Blowfish_ecb_stop(&ctx);
        
        if (m_enablePadding)
        {        
            unsigned long padding = PKCS5PaddingLength(dw.m_pointer, dw.m_length);
            
            if (padding)
            {
                [decryptData setLength:dw.m_length - padding];
            }
        }
        
        

    } while (false);
    
    
    return decryptData;
}
@end
