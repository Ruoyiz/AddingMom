//
//  NSUserDefaults+ADSaveSettings.h
//  PregnantAssistant
//
//  Created by D on 15/1/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *firstLaunchKey = @"firstLaunch";
static NSString *firstLaunchTimeKey = @"FIRSTLAUNCHTIMEKEY";
static NSString *appLaunchType = @"appLaunchType";
static NSString *momSecretCommentDraftKey = @"MomSecretCommentDraftKey";
static NSString *allContractionRecordKey = @"allRecord";
static NSString *hasShowNoticeTipKey = @"hasShowTip";
static NSString *addingTokenKey = @"adTokenkey";
static NSString *touchWarmTimeKey = @"TouchTimeKey";
static NSString *favToolIconKey = @"favKey";
static NSString *addingMomSecretKey = @"adSecretkey";
static NSString *dueDateKey = @"DUEDATEKEY";
static NSString *birthdateKey = @"BirthDateKey";
static NSString *everLaunchedKey = @"everLaunched";

static NSString *babaySexKey = @"babaySexKey";

static NSString *wxAccessTokenKey = @"wxAccessToken";
static NSString *wxRefreshTokenKey = @"wxRefreshToken";
static NSString *wxOpenIdKey = @"wxOpenId";

static NSString *addingUidKey = @"adUidKey";

static NSString *momLookListRequstTimeKey = @"momLookListRequstTimeKey";
static NSString *momLookFeedListRequestTimeKey = @"momLookFeedListRequestTimeKey";

static NSString *everRecKey = @"everRecKey";

static NSString *haveLauchToolTabKey = @"haveLauchToolTabKey";

static NSString *countFetal_HaveUpdate = @"countFetal_HaveUpdate";

static NSString *ever_ChangedLaunchType = @"everChangedLaunchType";

static NSString *everUploadBabyImgKey = @"everUploadBabyImgKey";
static NSString *everUploadCheckCalKey = @"everUploadCheckCalKey";
static NSString *everUploadContractionKey = @"everUploadContractionKey";
static NSString *everUploadCountFetailKey = @"everUploadCountFetailKey";
static NSString *everUploadCollectToolKey = @"everUploadCollectToolKey";
static NSString *everUploadMomNoteKey = @"everUploadMomNoteKey";

static NSString *hasShowSyncKey = @"hasShowSyncKey";

static NSString *checkSyncDateKey = @"checkSyncDateKey";

static NSString *longitudeKey = @"longitudeKey";
static NSString *latitudeKey = @"latitudeKey";

static NSString *haveEverRecommandParentToolKey = @"haveEverRecommandParentToolKey";

static NSString *lastUpdateDateKey = @"noticeTimer";

static NSString *everUpdateCheckArchiveKey = @"everUpdateCheckArchiveKey";


static NSString *xgDeviceTokenKey = @"xgDeviceTokenKey";

@interface NSUserDefaults (ADSaveSettings)

@property (nonatomic, copy) NSData *date;

@property (nonatomic, assign) NSDate *firstUseAppDate;
@property (nonatomic, assign) BOOL firstLauch;
@property (nonatomic, assign) BOOL everLaunched;

@property (nonatomic,assign) NSInteger launchType;

@property (nonatomic, assign) BOOL everRecIcon;

@property (nonatomic, copy) NSString *momSecretCommentDraft;

@property (nonatomic, copy) NSArray *allContractionRecords;

@property (nonatomic, assign) BOOL hasShowNoticeTip;

@property (nonatomic, copy) NSString *addingToken;
@property (nonatomic, copy) NSString *addingUid;

@property (nonatomic, copy) NSString *touchWarmTime;

@property (nonatomic, copy) NSData *favToolArray;

@property (nonatomic, copy) NSString *addingMomSecret;

@property (nonatomic, copy) NSData *dueDate;

@property (nonatomic,copy) NSDate *birthDate;

@property (nonatomic,strong) NSDate *pushDate;


@property (nonatomic, copy) NSString *wxAccessToken;
@property (nonatomic, copy) NSString *wxRefreshToken;
@property (nonatomic, copy) NSString *wxOpenId;

@property (nonatomic, copy) NSDate *momLookListRequestTime;
@property (nonatomic, copy) NSDate *momLookFeedListRequestTime;

@property (nonatomic, assign) BOOL haveLauchToolTab;
//@property (nonatomic, copy) NSArray *allReadMomLookInfo;

@property (nonatomic, assign) BOOL havetUpdateCountFetalToolData;

@property (nonatomic,assign) BOOL everChangedLaunchType;

@property (nonatomic,assign) BOOL everUploadBabyShotImg;
@property (nonatomic,assign) BOOL everUploadCheckCal;
@property (nonatomic,assign) BOOL everUploadContraction;
@property (nonatomic,assign) BOOL everUploadCountFetail;
@property (nonatomic,assign) BOOL everUploadCollectTool;
@property (nonatomic,assign) BOOL everUploadMomNote;

@property (nonatomic,assign) BOOL everUpdateCheckArchive;

@property (nonatomic,assign) ADBabySex babySex;

@property (nonatomic, assign) NSDate *checkSyncDate;

@property (nonatomic,assign) BOOL hasShowSyncAlert;

@property (nonatomic,assign) BOOL haveEverRecommandParentTool;

@property (nonatomic,strong) NSString *xgDeviceToken;

#pragma mark - 保存频道
@property (nonatomic,strong) NSArray *channelNameArray;
@property (nonatomic,strong) NSArray *channelIdArray;

#pragma mark - 保存经纬度
@property (nonatomic,strong)NSString *longitude;
@property (nonatomic,strong)NSString *latitude;

//保存更新小红点时间
@property (nonatomic,strong) NSDate *lastUpdateBadgeDate;

//移除uid
- (void)removeAddingUid;
//移除token
- (void)removeAddingToken;

@end
