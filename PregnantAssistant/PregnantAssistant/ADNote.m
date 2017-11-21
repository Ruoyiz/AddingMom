//
//  ADNote.m
//  PregnantAssistant
//
//  Created by D on 14/11/4.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADNote.h"

static NSString *kCellTitle = @"kCellTitle";
static NSString *kDateStr = @"kDate";
static NSString *kDueStr = @"kDue";
static NSString *kNote = @"kNote";
static NSString *kPhotoArray = @"kPhotoArray";
static NSString *kPhotoNameArray = @"kPhotoNameArray";

@implementation ADNote

-(id)initWithCellTitle:(NSString *)aTitle
          dateLabelStr:(NSString *)aDateStr
           dueLabelStr:(NSString *)aDueStr
                  note:(NSString *)aNote
           photosNames:(NSMutableArray *)aPhotoNamesArray
{
    if (self = [super init]) {
        self.cellTitle = aTitle;
        self.dateLabelStr = aDateStr;
        //超过40周 不再显示孕几周
        if (aDueStr == nil) {
            self.dueLabelStr = @"";
        } else {
            self.dueLabelStr = aDueStr;
        }
        self.note = aNote;
        self.photoNames = aPhotoNamesArray;
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cellTitle forKey:kCellTitle];
    [aCoder encodeObject:self.dateLabelStr forKey:kDateStr];
    [aCoder encodeObject:self.dueLabelStr forKey:kDueStr];
    [aCoder encodeObject:self.note forKey:kNote];
    [aCoder encodeObject:self.photoNames forKey:kPhotoNameArray];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.cellTitle = [aDecoder decodeObjectForKey:kCellTitle];
        self.dateLabelStr = [aDecoder decodeObjectForKey:kDateStr];
        self.dueLabelStr = [aDecoder decodeObjectForKey:kDueStr];
        self.note = [aDecoder decodeObjectForKey:kNote];
        self.photoNames = [aDecoder decodeObjectForKey:kPhotoNameArray];
    }
    return self;
}

@end
