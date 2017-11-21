//
//  ADMomLookNetworkEngine.m
//  PregnantAssistant
//
//  Created by D on 15/3/16.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookNetworkEngine.h"
//#import "DESUtils.h"
//
//static NSString *DesKey = @"addingaddingzaiyiqi";
@implementation ADMomLookNetworkEngine

-(id) initWithDefaultSettings
{
    NSString *cookieStr = [NSString stringWithFormat:@"idfv=%@",[ADHelper getIdfv]];
    NSString *newUserAgent = [NSString stringWithFormat:@"PregnantAssistant/%@ iOS/%@", [ADHelper getVersion],[ADHelper getIOSVersion]];
    if(self = [super initWithHostName:baseApiUrl customHeaderFields:@{@"Cookie":cookieStr,@"User-Agent":newUserAgent}]) {
        
    }
    return self;
}

//- (NSString *)getUId
//{
//    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
//    if (uid.length == 0) {
//        uid = @"";
//    }
//    NSString *result = [DESUtils encryptUseDES:uid key:DesKey];
//    NSLog(@"uid:%@", [[NSUserDefaults standardUserDefaults] addingUid]);
//    NSLog(@"uid res:%@ en:%@", result, [DESUtils decryptUseDES:result key:DesKey]);
//    
//    return result;
//}

@end
