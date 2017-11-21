//
//  ADNewNote.m
//  PregnantAssistant
//
//  Created by D on 15/4/21.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADNewNote.h"

@implementation ADNewNote

-(id)initWithNote:(NSString *)aNote
      photosNames:(NSMutableArray *)aPhotoNamesArray
       photosUrls:(NSString *)aPhotoUrls
        photoData:(NSArray *)photoData
   andPublishDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.note = aNote;
        
        for (int i = 0; i < aPhotoNamesArray.count; i++) {
            ADStringObject *aName = [[ADStringObject alloc]init];
            aName.value = aPhotoNamesArray[i];
            [self.photoNames addObject:aName];
        }
        
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
        self.publishDate = aDate;
        if (aPhotoUrls.length == 0) {
            aPhotoUrls = @"";
        }
        self.photoUrls = aPhotoUrls;
    }
    return self;
}


// Specify default values for properties
+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0", @"photoUrls":@"",@"publishTimer":@"",@"photoNames":@[]};
}

//+ (NSString *)primaryKey {
//    return @"publishDate";
//}
// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
