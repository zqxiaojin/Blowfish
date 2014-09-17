//
//  BlowfishEncoder+String.h
//  Blowfish
//
//  Created by Jin on 9/18/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "BlowfishEncoder.h"

@interface BlowfishEncoder (String)

- (BlowfishEncoder*)initWithTextKey:(NSString*) textKey;

- (NSString*)encryptECBWithString:(NSString*)stringToBeEncrypt;


- (NSString*)decryptECBWithHEXString:(NSString*)stringToBeDecrypt;

@end
