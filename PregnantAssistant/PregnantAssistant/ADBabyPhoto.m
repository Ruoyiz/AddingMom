//
//  ADBabyPhoto.m
//  PregnantAssistant
//
//  Created by D on 14/10/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBabyPhoto.h"

@implementation ADBabyPhoto

-(id)initWithDate:(NSDate *)aDate
         andPhoto:(UIImage *)aImage
{
    if (self = [super init]) {
        _shotDate = aDate;
        _babyImg = aImage;
    }
    return self;
}

@end
