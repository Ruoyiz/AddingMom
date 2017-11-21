//
//  ADMomSecertEngine.m
//  PregnantAssistant
//
//  Created by D on 15/4/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomSecertEngine.h"

@implementation ADMomSecertEngine

-(id) initWithDefaultSettings
{
    NSString *cookieStr = [NSString stringWithFormat:@"idfv=%@",[ADHelper getIdfv]];
    NSString *newUserAgent = [NSString stringWithFormat:@"PregnantAssistant/%@ iOS/%@", [ADHelper getVersion],[ADHelper getIOSVersion]];
    if(self = [super initWithHostName:baseApiUrl customHeaderFields:@{@"Cookie":cookieStr,@"User-Agent":newUserAgent}]) {
        
    }
    return self;
}

@end
