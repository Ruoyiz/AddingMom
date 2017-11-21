//
//  ADSyncToolTime.h
//  PregnantAssistant
//
//  Created by D on 15/4/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADSyncToolTime : RLMObject

@property NSString *uid;

@property NSString *c_userInfo_MTime;
@property NSString *c_antenatalCareCalendar_MTime;
@property NSString *c_antenatalCareRecord_MTime;
@property NSString *c_motherDiary_MTime;
@property NSString *c_pregDiary_MTime;
@property NSString *c_predeliveryBag_MTime;
@property NSString *c_fetalMovement_MTime;
@property NSString *c_uterineContraction_MTime;
@property NSString *c_toolsCollection_MTime;
@property NSString *c_heightWeight_MTime;
@property NSString *c_vaccineSync_MTime;

@property NSString *s_userInfo_MTime;
@property NSString *s_antenatalCareCalendar_MTime;
@property NSString *s_antenatalCareRecord_MTime;
@property NSString *s_motherDiary_MTime;
@property NSString *s_pregDiary_MTime;
@property NSString *s_predeliveryBag_MTime;
@property NSString *s_fetalMovement_MTime;
@property NSString *s_uterineContraction_MTime;
@property NSString *s_toolsCollection_MTime;

@property NSString *s_vaccineSync_MTime;
@property NSString *s_heightWeightSync_MTime;

//userInfoSyncTime                        用户信息同步时间
//antenatalCareCalendarSyncTime           产检日历同步时间
//antenatalCareRecordSyncTime             产检档案同步时间
//motherDiarySyncTime                     孕妈日记同步时间
//pregDiarySyncTime                       大肚日记同步时间
//predeliveryBagSyncTime                  待产包同步时间
//fetalMovementSyncTime                   胎动同步时间
//uterineContractionSyncTime              宫缩同步时间
//toolsCollectionSyncTime                 工具收藏同步时间
//vaccineSyncTime                         疫苗同步时间
//heightWeightSyncTime                    身高体重同步时间

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADSyncToolTime>
RLM_ARRAY_TYPE(ADSyncToolTime)
