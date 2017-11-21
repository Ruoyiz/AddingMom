//
//  ADDataDistributor.m
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADDataDistributor.h"
#import "ADCheckCalDAO.h"
#import "ADBabyShotDAO.h"
#import "ADCountFetalDAO.h"
#import "ADCheckArchivesDAO.h"
#import "ADNoteDAO.h"
#import "ADContractionDAO.h"
#import "ADInLabourDAO.h"
#import "ADCollectToolDAO.h"
#import "ADUserInfoSaveHelper.h"
#import "ADVaccineDAO.h"
#import "ADWHDataManager.h"
#import "ADMomLookDAO.h"

@implementation ADDataDistributor

+ (ADDataDistributor *)shareInstance
{
    static ADDataDistributor *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance
                                                 selector:@selector(distributeDataToLoginUser)
                                                     name:distrubeDataToUserNotification object:nil];
        
    });
    return sharedInstance;
}

- (void)distributeDataToLoginUser
{
    [ADCollectToolDAO distrubuteData];
    
    [ADMomLookDAO distrubuteData];
    [ADInLabourDAO distrubuteData];
    [ADCountFetalDAO distrubuteData];
    [ADCheckCalDAO distrubuteData];
    [ADNoteDAO distrubuteData];
    [ADBabyShotDAO distrubuteData];
    [ADContractionDAO distrubeteData];
    [ADCheckArchivesDAO distrubeteData];
    [ADVaccineDAO distrubuteData];
    [ADWHDataManager distrubuteData];
}

@end
