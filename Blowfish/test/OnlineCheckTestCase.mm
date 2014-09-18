//
//  OnlineCheckTestCase.m
//  Blowfish
//
//  Created by Jin on 9/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "OnlineCheckTestCase.h"
#import "BlowfishEncoder+String.h"


@interface OnlineCheckTestCase ()
{
    NSUInteger m_currentIndex;
}

@property (nonatomic,retain)NSURLConnection* connection;
@property (nonatomic,retain)NSArray* testArray;
@property (nonatomic,retain)NSMutableData* data;
@property (nonatomic,retain)NSString* key;
@property (nonatomic,retain)NSString* currentText;
@end

@implementation OnlineCheckTestCase

@synthesize reporter;
@synthesize testArray;
@synthesize connection;
@synthesize data    = m_data;
@synthesize key     = m_key;
@synthesize currentText;

- (void)dealloc
{
    self.data = nil;
    self.key = nil;
    self.currentText = nil;
    self.connection = nil;
    self.testArray = nil;
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.key = @"hello";
    }
    return self;
}

- (void)run:(NSArray *)array
{
    self.testArray = array;
    [self startCheck];
}

- (void)startCheck
{
    if (m_currentIndex >= [self.testArray count])
    {
        [self.reporter caseFinish];
        return;
    }
    NSURL* url = [NSURL URLWithString:@"http://www.tools4noobs.com/"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"http://www.tools4noobs.com" forHTTPHeaderField:@"Origin"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.120 Safari/537.36"
   forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8"
   forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"http://www.tools4noobs.com/online_tools/encrypt/"
   forHTTPHeaderField:@"Referer"];
   
    [request setValue:@"zh-CN,zh;q=0.8,en-US;q=0.6,en;q=0.4" forHTTPHeaderField:@"Accept-Language"];

    
    NSString* key = self.key;
    NSString* orgText = self.currentText = [self.testArray objectAtIndex:m_currentIndex];

    
    NSString* postBody = [NSString stringWithFormat:@"http://www.tools4noobs.com/?action=ajax_encrypt&key=%@&text=%@&algo=blowfish&mode=ecb&encode=checked&encode_method=2"
                          , key
                          , orgText
                          ];
    
    NSURL* cfURL = (NSURL*)CFURLCreateAbsoluteURLWithBytes(kCFAllocatorDefault
                                                     , (const UInt8 *)postBody.UTF8String
                                                     , (CFIndex)strlen(postBody.UTF8String)
                                                     , kCFStringEncodingUTF8
                                                     , 0
                                                     , true);
    
    postBody = [[cfURL absoluteString] stringByReplacingOccurrencesOfString:@"http://www.tools4noobs.com/?" withString:@""];
    
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    self.data = [[NSMutableData alloc] initWithCapacity:32];
    
    ++m_currentIndex;
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [self.connection cancel];
    [self startCheck];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response;
{
    return request;
}
- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSHTTPURLResponse *)response;
{
    if (response.statusCode != 200)
    {
        assert(0);
    }
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data;
{
    [self.data appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    [self checkResult];
    [self.connection cancel];
    [self startCheck];
}


- (void)checkResult
{
    NSString *resultString = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    NSRange resultStartRange = [resultString rangeOfString:@"readonly\">"];
    
    if (resultStartRange.location == NSNotFound)
    {
        assert(0);
    }
    
    NSRange resultEndRange = [resultString rangeOfString:@"</textarea>"];
    if (resultEndRange.location == NSNotFound)
    {
        assert(0);
    }
    NSUInteger start = resultStartRange.location + resultStartRange.length;
    
    NSString* result = [resultString substringWithRange:NSMakeRange(start, resultEndRange.location - start)];
    
    BlowfishEncoder* encoder = [[[BlowfishEncoder alloc] initWithTextKey:self.key] autorelease];
    encoder.enablePadding = NO;
    
    NSString* encoderResult = [encoder encryptECBWithString:self.currentText];
    
    
    [[[BlowfishEncoder alloc] initWithTextKey:self.key] decryptECBWithHEXString:result];
    
    
    assert([encoderResult isEqualToString:result]);
}

@end
