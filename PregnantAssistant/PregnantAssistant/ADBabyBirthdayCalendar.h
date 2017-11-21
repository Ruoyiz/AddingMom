//
//  ADBabyBirthdayCalendar.h
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADBabyBirthdayCalendar : NSObject

@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger years;
@property (nonatomic, assign) NSInteger days;
- (instancetype)initWithBirthdayDate:(NSDate *)birthDate endDaysDate:(NSDate *)nowDate;

@end
