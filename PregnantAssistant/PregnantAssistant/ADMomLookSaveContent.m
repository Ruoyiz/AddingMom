//
//  ADMomLookSaveContent.m
//  PregnantAssistant
//
//  Created by D on 15/3/6.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookSaveContent.h"

@implementation ADMomLookImage

- (instancetype)initWithUrl:(NSString *)aUrl
{
    if (self = [super init]) {
        _imageUrl = aUrl;
    }
    return self;
}

@end

@implementation ADMomLookSaveContent

-(instancetype)initWithInfo:(ADMomContentInfo *)aInfo
{
    if (self = [super init]) {
//        NSLog(@"aInfo: %@", aInfo);
        _uid = [[NSUserDefaults standardUserDefaults]addingUid];
        _title = [self getStrFromOnject:aInfo.title];
        _aPublishTime = [self getStrFromOnject:aInfo.aPublishTime];
        _aDescription = [self getStrFromOnject:aInfo.aDescription] ;
        _mediaSource = [self getStrFromOnject:aInfo.mediaSource]; //内容来源
        
        _collectId = [[self getStrFromOnject:aInfo.collectId] integerValue];
        _action = [self getStrFromOnject:aInfo.action];
        _nUrl = [self getStrFromOnject:aInfo.nUrl];
        _wUrl = [self getStrFromOnject:aInfo.wUrl];
        
//        NSLog(@"type: %d %d", aInfo.aContentType, aInfo.aContentStyle);
        _aContentType = aInfo.aContentType;
        _aContentStyle = aInfo.aContentStyle;
        
        _saveDate = [NSDate date];
        
        _addingUserLogoUrl = aInfo.addingUserLogoUrl.length == 0 ? @"": aInfo.addingUserLogoUrl;
        _timeCost = aInfo.timeCost.length == 0 ? @"": aInfo.timeCost;
//        NSLog( @"%@ %@ %@",
//              _title,
//              _aPublishTime,
//              _aDescription);
//        NSLog( @"%@ %@",
//              _mediaSource,
//              _action);
    }
    
    return self;
}

//no use!!
- (NSString *)getStrFromOnject:(id)object
{
    if ([object isEqual:[NSNull null]] || object == nil) {
        return @"";
    }else{
        return object;
    }
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{
             @"collectId":@0,
             @"nUrl":@"",
             @"wUrl":@"",
             @"aDescription":@"",
             @"mediaSource":@"",
             @"addingUserLogoUrl":@"",
             @"timeCost":@""
//             @"aContentType": @1,
//             @"aContentStyle": @1
             };
}

@end
