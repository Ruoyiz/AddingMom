//
//  ADBaseDataSyncHelper.m
//  PregnantAssistant
//
//  Created by D on 15/5/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBaseDataSyncHelper.h"
#import "ADUserSyncMetaHelper.h"
#import "ADCollectToolDAO.h"
//#import "ADUserInfo"
#import "ADCheckCalDAO.h"
#import "ADCountFetalDAO.h"
#import "ADInLabourDAO.h"
#import "ADBabyShotDAO.h"
#import "ADNoteDAO.h"
#import "ADContractionDAO.h"
#import "ADCheckArchivesDAO.h"
#import "ADVaccineDAO.h"
#import "ADWHDataManager.h"

@implementation ADBaseDataSyncHelper

+ (void)syncAllData
{
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:checkCareCalendarKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADCheckCalDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:fetalMovementKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADCountFetalDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:predeliveryBagKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADInLabourDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:pregDiaryKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADBabyShotDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:motherDiaryKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADNoteDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:uterineContractionKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADContractionDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:checkArichveKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADCheckArchivesDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:vaccineSyncTimeKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADVaccineDAO syncVaccineDataSuccess:nil failure:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:heightWeightSyncTimeKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADWHDataManager syncAllDataOnGetData:nil getDataFailure:nil onUploadProcess:nil uploadFailure:nil noNeed:nil];
        }
    }];
    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:userInfoTimeKey complete:^(BOOL isNeed) {
        if (isNeed) {
            [ADUserInfoSaveHelper syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
        }
    }];
//    [ADUserSyncMetaHelper isNeedSynsDataWithSyncKey:<#(NSString *)#> complete:<#^(BOOL isNeed)complete#>];
//    [ADUserSyncMetaHelper isHaveUnSyncDataOnFinish:^(BOOL res) {
//        if (res == YES) {
////            [ADCollectToolDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
//
////            [ADCheckCalDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADCountFetalDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADInLabourDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADBabyShotDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADNoteDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADContractionDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADCheckArchivesDAO syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
////            [ADVaccineDAO syncVaccineDataSuccess:nil failure:nil];
////            [ADWHDataManager syncAllDataOnGetData:nil getDataFailure:nil onUploadProcess:nil uploadFailure:nil noNeed:nil];
//            [ADUserInfoSaveHelper syncAllDataOnGetData:nil onUploadProcess:nil onUpdateFinish:nil];
//        }
//    }];
}
@end
