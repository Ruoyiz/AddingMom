//
//  NotificationDefine.h
//  FetalMovement
//
//  Created by wangpeng on 14-3-5.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#pragma once
static NSString *ConnectError = @"网络连不上了 请检查网络";

static NSString *getAddingTokenNotification = @"GetAddingTokenNotification";
static NSString *haveSomeOneLikeSecretNotification = @"HaveSomeOneLikeSecretNotification";
static NSString *notiNumChangedNotification = @"NotiNumChangedNotification";
static NSString *secretNumChangedNotification = @"secretNumChangedNotification";
static NSString *removeSecretNumChangedNotification = @"RemoveSecretNumChangedNotification";

static NSString *changeDueDateToBirdthDate = @"ChangeDueDateToBirdthDate";

static NSString *postSecretSucessNotification = @"PostSecretSucessNotification";
static NSString *pushAVideoVcNotification = @"PushAVideoVcNotification";

static NSString *momLookNewBadgeNotification = @"momLookNewBadgeNotification";

//static NSString *momLookNewClearBadgeNotification = @"momLookNewClearBadgeNotification";
static NSString *old_AppVersion = @"APPVERSION";
static NSString *last_AppVersion = @"lastAppVersion";
static NSString *Last_NoticeId = @"lastNoticeId";

static NSString *finishSortToolNotification = @"finishSortToolNotification";

static NSString *tapImgNotification = @"tapImgNotification";

//微信
static NSString *loginWeiSucessNotify = @"loginWeiSucessNotify";

static NSString *cancelLogin = @"cancelLogin";
static NSString *loginWeiSuccessFomeMom = @"loginWeiSucessNotifyFomeMom";

static NSString *scrollToTopNotification = @"scrollToTopNotification";

static NSString *logoutNotification = @"logoutNotification";
static NSString *DismissInfoVcNotification = @"DismissInfoVcNotification";

static NSString *finishDownloadImgNotification = @"finishDownloadImgNotification";
static NSString *selfLikeMomSecertNotification = @"selfLikeMomSecertNotification";

static NSString *distrubeDataToUserNotification = @"distrubeDataToUserNotification";

#pragma mark - count fetal notification
static NSString *const NOTIFICATION_DAY_CHANGED = @"DayChanged";
static NSString *const NOTIFICATION_CHANGE_FAV = @"FavChanged";
static NSString *const NOTIFICATION_ADD_NOTE = @"AddNote";

//static NSString *const NOTIFICATION_ADD_VALID_ONE = @"addAValidOne";

static NSString *const NOTIFICATION_CNT_DAY_CHANGED = @"CntDayChanged";
static NSString *const NOTIFICATION_CHANGE_CNT_TODAY = @"CntToday";

static NSString *const NOTIFICATION_FINISH_ONEHOUR = @"finishOneHour";

static NSString *const NOTIFICATION_ADD_VALID_ONE_CHANGE = @"ADD_ONE_TODAY";

static NSString *unEnablePageUserInterface = @"unEnablePageUserInterface";
static NSString *enablePageUserInterface = @"enablePageUserInterface";

static NSString *ChangeCommentCountNoti = @"ChangeCommentCount";

static NSString *RefreshLookDataNoti = @"RefreshLookDataNoti";

#define addMomLookTitleDot1Notification @"addMomLookTitleDot1Notification"
#define addMomLookTitleDot2Notification @"addMomLookTitleDot2Notification"

#define removeMomLookTitleDot1Notification @"removeMomLookTitleDot1Notification"
#define removeMomLookTitleDot2Notification @"removeMomLookTitleDot2Notification"
#define removeMomLookTitleAllDotNotification @"removeMomLookTitleAllDotNotification"

#define updateFeedListNotification @"updateFeedListNotification"
#define updateRecommadListNotification @"updateRecommadListNotification"
#define updateColloctListNotification @"updateColloctListNotification"
#define loginSucessNotification @"loginSucessNotification"
