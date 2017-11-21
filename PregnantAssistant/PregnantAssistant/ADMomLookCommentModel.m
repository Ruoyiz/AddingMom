//
//  ADMomLookCommentModel.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookCommentModel.h"

@implementation ADMomLookCommentModel

//将网络数据转化为model
+ (NSMutableArray *)conversionResponseObjectToModelArray:(id)responseObject
{
    //NSLog(@"%@",responseObject);
    NSMutableArray *modelArray = [NSMutableArray array];
    
    for (NSDictionary *subDic in responseObject) {
        if (![subDic isKindOfClass:[NSDictionary class]]) {
            return modelArray;
        }
        ADMomLookCommentModel *model = [[ADMomLookCommentModel alloc] init];
        
        model.commentBody = [subDic objectForKey:@"commentBody"];
        model.commentId = [subDic objectForKey:@"commentId"];
        model.contentId = [subDic objectForKey:@"contentId"];
        model.isComment = [[subDic objectForKey:@"isComment"] boolValue];
        model.isPraise = [[subDic objectForKey:@"isPraise"] boolValue];
        model.isSelf = [[subDic objectForKey:@"isSelf"] boolValue];
        model.praiseCount = [subDic objectForKey:@"praiseCount"];
        model.replyCommentId = [subDic objectForKey:@"replyCommentId"];
        model.replyContentId = [subDic objectForKey:@"replyContentId"];
        model.replyCount = [subDic objectForKey:@"replyCount"];
        model.replyName = [subDic objectForKey:@"replyName"];
        model.status = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"status"]];
        model.uid = [NSString stringWithFormat:@"%@",[subDic objectForKey:@"uid"]];
        model.commentName = [subDic objectForKey:@"commentName"];
        model.face = [subDic objectForKey:@"face"];
        
        NSString *updateTimestampStr = [subDic objectForKey:@"updateTime"];
        NSString *createTimestampStr = [subDic objectForKey:@"createTime"];
        
        model.updateTime = [self getTimeStrFromTimestamp:[updateTimestampStr integerValue]];
        model.createTime = [self getTimeStrFromTimestamp:[createTimestampStr integerValue]];
        
        [modelArray addObject:model];
    }
    
    return modelArray;
}

+ (NSString *)getTimeStrFromTimestamp:(NSInteger)timestamp
{
    NSDate *today = [NSDate date];
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSInteger day = [today daysAfterDate:time];
    
    NSInteger hour = [today hoursAfterDate:time] % 24;
    
    NSInteger minute = [today minutesAfterDate:time] % 60;
    
    if (day > 0) {
        return [NSString stringWithFormat:@"%ld天前",(long)day];
    }else if (hour > 0){
        return [NSString stringWithFormat:@"%ld小时前",(long)hour];
    }else if (minute > 0){
        return [NSString stringWithFormat:@"%ld分钟前",(long)minute];
    }
    
    return @"1分钟前";
}

@end
