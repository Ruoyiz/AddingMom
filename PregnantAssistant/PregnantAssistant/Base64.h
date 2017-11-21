//
//  Base64.h
//  PregnantAssistant
//
//  Created by D on 15/3/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+(int)char2Int:(char)c;
+(NSData *)decode:(NSString *)data;
+(NSString *)encode:(NSData *)data;
@end