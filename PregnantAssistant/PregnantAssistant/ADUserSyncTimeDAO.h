//
//  ADUserSyncTimeDAO.h
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADSyncToolTime.h"

//typedef NS_ENUM(NSInteger, syncTimeType) {
//    userInfoSyncTime,
//    antenatalCareCalendarSyncTime,
//    antenatalCareRecordSyncTime,
//    motherDiarySyncTime,
//    pregDiarySyncTime,
//    predeliveryBagSyncTime,
//    fetalMovementSyncTime,
//    uterineContractionSyncTime,
//    toolsCollectionSyncTime
//};

@interface ADUserSyncTimeDAO : NSObject

+ (void)setupFirstTime;
+ (ADSyncToolTime *)findUserSyncTimeRecord;
+ (void)syncTimeWithRecord:(ADSyncToolTime *)aTime;

@end
