//
//  ADBabyPhoto.h
//  PregnantAssistant
//
//  Created by D on 14/10/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADBabyPhoto : NSObject

@property (nonatomic, retain) NSDate *shotDate;
@property (nonatomic, retain) UIImage *babyImg;

-(id)initWithDate:(NSDate *)aDate
         andPhoto:(UIImage *)aImage;

@end
