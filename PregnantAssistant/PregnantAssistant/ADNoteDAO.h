//
//  ADNoteDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADNewNote.h"

@interface ADNoteDAO : NSObject

+ (RLMResults *)readAllData;

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;
+ (void)uploadOldData;

+ (void)addNote:(ADNewNote *)aNote;
+ (void)addDiaryModelWithNote:(NSString *)noteText photosNames:(ADMotherDirPhoto *)photosName photosUrls:(NSString *)photoUrl publishDate:(NSString *)publishTimer imageName:(NSString *)imageName newNotoe:(ADNewNote *)adnewNote;
+ (RLMResults *)readNewNoteWithNSTimer:(NSString *)timer;
+ (void)updateWithPublishDate:(NSString *)pubLishTimer photosName:(NSString *)photoName isUpload:(BOOL)isUpload;
+ (void)updateNewNoteWithNote:(NSString *)noteText publishTimer:(NSString *)publishTimer;
+ (void)delNote:(ADNewNote *)aNote;
+ (void)createOrUpdateNote:(ADNewNote *)aNote;

+ (void)distrubuteData;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

@end
