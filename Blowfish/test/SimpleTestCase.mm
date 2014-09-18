//
//  SimpleTestCase.m
//  Blowfish
//
//  Created by Jin on 9/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SimpleTestCase.h"
#import "BlowfishEncoder.h"

void TestEncodeAndDecoder(NSString* text);
void TestEncodeAndDecoder(NSString* text)
{
    char key[] = "IamTheKey!";
    NSData* keyData = [NSData dataWithBytes:key length:strlen(key)];
    
    BlowfishEncoder* encoder = [[BlowfishEncoder alloc] initWithKey:keyData];
//    encoder.enablePadding = NO;
    
    NSData* encryptData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDate* start = [NSDate date];
    
    encryptData = [encoder encryptECBWithData:encryptData];
    
    NSLog(@"encrypt %d bytes cost %f ms", (int)[encryptData length] , [[NSDate date] timeIntervalSinceDate:start]  * 1000);
    
    start = [NSDate date];
    
    //测试解密
    NSData* decrypt = [encoder decryptECBWithData:encryptData];
    
    
    NSLog(@"decrypt %d bytes cost %f ms", (int)[encryptData length] , [[NSDate date] timeIntervalSinceDate:start]  * 1000);
    
    
    NSString* result = [[[NSString alloc] initWithData:decrypt encoding:NSUTF8StringEncoding] autorelease];
    
    
    if ([result isEqualToString:text])
    {
        NSLog(@"Success!");
    }
    else
    {
        NSLog(@"Fail !!");
        assert(0);
    }
    
    [encoder release];
}


@implementation SimpleTestCase

@synthesize reporter;

- (void)run:(NSArray*)array;
{
  
    for (NSString* text in array)
    {
        TestEncodeAndDecoder(text);
    }
    
    [self.reporter caseFinish];
}

@end
