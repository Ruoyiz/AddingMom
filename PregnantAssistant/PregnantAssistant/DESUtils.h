//
//  DESUtils.h
//  PregnantAssistant
//
//  Created by D on 15/3/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
#import "Base64.h"
@interface DESUtils : NSObject
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key;
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
@end