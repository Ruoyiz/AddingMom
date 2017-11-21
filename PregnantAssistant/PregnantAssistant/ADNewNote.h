//
//  ADNewNote.h
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Realm/Realm.h>
#import "ADStringObject.h"
#import "ADMotherDirPhoto.h"

@interface ADNewNote : RLMObject

@property NSString *uid;
@property NSString *note;
@property NSDate *publishDate;
@property NSString *publishTimer;
@property RLMArray<ADStringObject> *photoNames; // 存储的图片 本地地址
@property RLMArray<ADMotherDirPhoto> *motherPhotoModes;
@property NSString *photoUrls; // 存储的图片远程地址

-(id)initWithNote:(NSString *)aNote
      photosNames:(NSMutableArray *)aPhotoNamesArray
       photosUrls:(NSString *)aPhotoUrls
        photoData:(NSArray *)photoData
   andPublishDate:(NSDate *)aDate;

//+ (void)saveImageWithImageNameArray:(NSArray *)imageNameArray imageDataArray:(NSArray *)imageDataArray;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADNewNote>
RLM_ARRAY_TYPE(ADNewNote)
