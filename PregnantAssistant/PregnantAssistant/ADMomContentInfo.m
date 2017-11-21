//
//  ADMomContentInfo.m
//  PregnantAssistant
//
//  Created by D on 15/3/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomContentInfo.h"

@implementation ADMomContentInfo

- (instancetype)initWithTitle:(NSString *)title
                   andImgUrls:(NSArray *)aImgUrl
               andContentType:(NSString *)aContentType
              andContentStyle:(NSString *)aContentStyle
               andPublishTime:(NSString *)aPublishTime
               andMediaSource:(NSString *)aMediaSource
               andDescription:(NSString *)aDes
                    andAction:(NSString *)aAction
                  andSaveDate:(NSDate *)saveDate
                     tagLabel:(NSString *)tagLabel
{
    if (self = [super init]) {
        _title = title;
        _imgUrls = aImgUrl;
        
        NSLog(@"type:%d", aContentType.intValue);
        _aContentType = aContentType.intValue;
        _aContentStyle = aContentStyle.intValue;
        _aPublishTime = aPublishTime;
        
        self.mediaSource = aMediaSource;
        _aDescription = aDes;
        _tagLabelStr = tagLabel;
        _action = aAction;
        _saveDateStr = [NSString stringWithFormat:@"%ld", (long)[saveDate timeIntervalSince1970]];
    }
    
    return self;
}

- (id)initWithModelObject:(id)object
{
    self = [super init];
    if (self) {
        //NSLog(@"down %@",object);
        NSDictionary *dic = (NSDictionary *)object;
        
        _contentId = dic[@"contentId"];
        _mediaId = dic[@"mediaId"];
        
        _title = [dic objectForKey:@"title"];
        _imgUrls = [dic objectForKey:@"images"];
        
        _aContentType = [[dic objectForKey:@"type"] intValue];
        _commentCount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentCount"]];
//        NSString * style =
        _aContentStyle = [dic[@"style"] intValue];
//        if (![style isEqual:[NSNull null]] && style) {
//            _aContentStyle = [style intValue];
//        }
        _aPublishTime = [NSString stringWithFormat:@"%@",[dic objectForKey:@"publishTime"]];
        
//        _duration = @"";
        NSString *media = [dic objectForKey:@"sponsorName"];//resultArray[i][@"sponsorName"];
        if (media.length == 0) {
            media = [dic objectForKey:@"mediaName"];//resultArray[i][@"mediaName"];
        }
        
        _addingUserLogoUrl = dic[@"mediaLogoUrl"];
        _timeCost = [NSString stringWithFormat:@"%@", dic[@"timeCost"]];
        
        //self.content = aContent;
        self.mediaSource = media;
        _aDescription = [dic objectForKey:@"description"];
//        _aContentId = [dic objectForKey:@"contentId"];//aContentId;
        
        _action = [dic objectForKey:@"action"];
        _nUrl = [dic objectForKey:@"nurl"];
        _wUrl = [dic objectForKey:@"wurl"];
        _wTitle = [dic objectForKey:@"wtitle"];
        _commentCount = [dic objectForKey:@"commentCount"];
        
        self.tagLabelStr = [dic objectForKey:@"label"];
        
        _collectId = dic[@"collectId"];
    }
    
    return self;
}

@end