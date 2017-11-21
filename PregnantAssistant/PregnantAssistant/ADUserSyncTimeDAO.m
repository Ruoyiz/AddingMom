//
//  ADUserSyncTimeDAO.m
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADUserSyncTimeDAO.h"

@implementation ADUserSyncTimeDAO

+ (void)syncTimeWithRecord:(ADSyncToolTime *)aTime
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
//    [ADSyncToolTime createOrUpdateInDefaultRealmWithObject:aTime];
    [ADSyncToolTime createInDefaultRealmWithValue:aTime];
    
    [realm commitWriteTransaction];
}


+ (ADSyncToolTime *)findUserSyncTimeRecord
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    
    RLMResults *userRecord = [ADSyncToolTime objectsWithPredicate:predicate2];
    if (userRecord.count == 0) {
        [self setupFirstTime];
        userRecord = [ADSyncToolTime objectsWithPredicate:predicate2];
    }

    return userRecord[0];
}

+ (void)setupFirstTime
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"uid == %@", uid];
    RLMResults *findThings = [ADSyncToolTime objectsWithPredicate:predicate2];
    if (findThings.count == 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        ADSyncToolTime *aRecord = [[ADSyncToolTime alloc]init];
        aRecord.uid = uid;
        [realm addObject:aRecord];
        
        [realm commitWriteTransaction];
    }
}

@end
