//
//  BlowfishEncoder.h
//  Blowfish
//
//  Created by LiangJin on 14-9-5.
//  Copyright (c) 2014年 LiangJin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlowfishEncoder : NSObject

/**
 *	@brief	填入key来初始化,后续需要考虑是否记录key的版本来判断是否key过期
 *
 */
- (BlowfishEncoder*)initWithKey:(NSData*) dataKey;


/**
 *	@brief	加密函数,需要先设置key
 *
 *	@param 	dataToBeEncrypt 	需要加密的数据
 *
 *	@return	返回加密结果,如果内存不足,则可能返回nil
 */
- (NSData*)encryptECBWithData:(NSData*)dataToBeEncrypt;


/**
 *	@brief	解密函数,需要先设置key
 *
 *	@param 	dataToBeDecrypt 	需要解密的数据
 *
 *	@return	返回解密结果,如果内存不足,则可能返回nil
 */
- (NSData*)decryptECBWithData:(NSData*)dataToBeDecrypt;


@end
