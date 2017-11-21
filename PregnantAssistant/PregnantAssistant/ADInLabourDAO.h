//
//  ADInLabourDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADBaseToolDAO.h"
#import "ADLabourThing.h"
#import "ADNewLabourThing.h"

static NSString *buyKey = @"buy";

@interface ADInLabourDAO : ADBaseToolDAO

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;

+ (void)addAWantLabourThing:(ADNewLabourThing *)aThing;
+ (void)delAWantLabourThing:(ADNewLabourThing *)aThing;
+ (void)delAWantLabourThingWithName:(NSString *)aName;

+ (void)markALabourThingName:(NSString *)aThingTitle withBuyStatus:(BOOL)aStatus;

+ (RLMResults *)readAllData;

+ (RLMResults *)readWantThingWithKindTitle:(NSString *)aTitle;

+ (BOOL)isContainAThing:(NSString *)aThingName inKind:(NSString *)aKindTitle;

+ (void)addAKindWantThing:(NSArray *)aThing andKindTitle:(NSString *)aTitle;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

+ (void)distrubuteData;

@end
