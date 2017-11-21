//
//  ADShotPhoto.m
//  PregnantAssistant
//
//  Created by D on 14/11/24.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShotPhoto.h"

@implementation ADShotPhoto

- (instancetype)initWithImg:(UIImage *)aImg shotDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.shotDate = aDate;
        self.shotImg = UIImageJPEGRepresentation(aImg, 1.0);
        
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0", @"url":@"", @"shotImg":@"" ,@"isUpload":@YES};
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
