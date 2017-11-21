//
//  ADMomLookReadInfoManager.m
//  PregnantAssistant
//
//  Created by D on 15/3/12.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomLookReadInfoManager.h"

@implementation ADMomLookReadInfoManager

+ (void)addCellInfoWithAction:(NSString *)aAction
{
    ADMomCellInfo *aCellInfo = [[ADMomCellInfo alloc]init];
    aCellInfo.action = aAction;
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:aCellInfo];
    
    [realm commitWriteTransaction];
}

+ (void)delCellInfoWithAction:(NSString *)aAction
{
    ADMomCellInfo *aCellInfo = [[ADMomCellInfo alloc]init];
    aCellInfo.action = aAction;

    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm deleteObject:aCellInfo];
    
    [realm commitWriteTransaction];
}

+ (BOOL)isClickedWithAction:(NSString *)aAction
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"action == %@", aAction];
    NSLog(@"action:%@ pred:%@", aAction, pred);
    RLMResults *contents = [ADMomCellInfo objectsWithPredicate:pred];
    if (contents.count > 0) {
        return YES;
    }
    return NO;
}

+ (RLMResults *)readAllFavVideo
{
    return [ADMomCellInfo allObjects];
}

@end
