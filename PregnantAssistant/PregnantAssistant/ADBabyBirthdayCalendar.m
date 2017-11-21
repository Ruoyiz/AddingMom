//
//  ADBabyBirthdayCalendar.m
//  PregnantAssistant
//
//  Created by 加丁 on 15/5/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADBabyBirthdayCalendar.h"

@implementation ADBabyBirthdayCalendar

- (instancetype)initWithBirthdayDate:(NSDate *)birthDate endDaysDate:(NSDate *)nowDate{

    self = [super init];
    if (self) {
        NSDateComponents *dataComponents1 = [self getBeiJingComponents1WithDate:birthDate];
        NSInteger years1 = [dataComponents1 year];
        NSInteger month1 = [dataComponents1 month];
        NSInteger day1 = [dataComponents1 day];
        NSInteger day11 = day1;
        
        NSDateComponents *dataComponents2 = [self getBeiJingComponents1WithDate:nowDate];
        NSInteger years2 = [dataComponents2 year];
        NSInteger month2= [dataComponents2 month];
        NSInteger day2 = [dataComponents2 day];
        NSInteger day22 = day2;
        day2 ++;
        
        NSInteger years =0,month = 0,day =0;
        
        NSInteger betMonth = [self getMonthWithMonthIndex:month2];
        NSInteger betYears = [self getYearsWithMonthIndex:month2 yearIndex:years2];
        NSInteger monthDays = [self getMontDaysWithMonthIndex:betMonth yearIndex:betYears];
        
        if (years2 == years1) {
            if (month2 - month1 == 1) {
                day1 ++;
                NSInteger betMonthDay = [self getMontDaysWithMonthIndex:month2 yearIndex:years2];
                if (day22 == betMonthDay) {
                    if (day11 >= day22) {
                        day = 0;
                        month = 1;
                    }else{
                        day = day2 - day1;
                        month = 1;
                    }
                }else{
                    if (day22 >= day11) {
                        day = day2 - day1;
                        month = 1;
                    }else{
                        day = monthDays - (day1 - day2 -1);
                        month = 0;
                    }
                }
            }else if(month1 == month2)
            {
                
                if (day2 - day1 >= 0) {
                    day = day2 - day1;
                    if (month2 - month1 >= 0) {
                        month = month2 - month1;
                        years = years2 - years1;
                    }else{
                        if (years2 - years1 > 0) {
                            years = years2 - years1;
                        }else{
                            years = month = day = 0;
                        }
                    }
                }else{
                    day = monthDays - (day1 - day2);
                    if (month2 - month1 >0) {
                        month = month2 - month1 - 1;
                        years = years2 - years1;
                    }else{
                        if (years2 > years1) {
                            month = 13 -(month1 - month2);
                            years = years2 - years1;
                        }else{
                            years = month = day = 0;
                        }
                    }
                }
            }
        }

        if (month2 - month1 >1 || years1!= years2) {
            day1 ++;
            if (day2 - day1 >= 0)
            {
                day = day2 - day1;
                if (month2 - month1 >= 0) {
                    month = month2 - month1;
                    years = years2 - years1;
                }else{
                    if (years2 - years1 > 0) {
                        month = 12 - (month1 - month2);
                        years = years2 - years1 -1;
                    }else{
                        years = month = day = 0;
                    }
                }
            }else{

                NSInteger beforMonthDay ;
                NSInteger newMonthDay;
                NSInteger beforMonth = [self getMonthWithMonthIndex:month2];
                beforMonthDay = [self getMontDaysWithMonthIndex:beforMonth yearIndex:[self getYearsWithMonthIndex:beforMonth yearIndex:years2]];
                newMonthDay = [self getMontDaysWithMonthIndex:month2 yearIndex:years2];
                if ((day11 > beforMonthDay)) {
                    day2 += (day11 - beforMonthDay);
                }
                day = monthDays - (day1 - day2);
                if (month2 - month1 >0) {
                    month = month2 - month1 - 1;
                    if (day22 == newMonthDay) {
                        day = 0;
                        month = month2 - month1;
                    }
                    years = years2 - years1;
                }else{
                    if (years2 > years1) {
                        month = 12 -(month1 - month2) -1;
                        if (day22 == newMonthDay) {
                            day = 0;
                            month = 12- (month1 - month2);
                        }
                        years = years2 - years1 -1;
                    }else{
                        years = month = day = 0;
                    }
                }
            }
            
        }
        _years = years;
        _month = month;
        _days = day;
    }
    
    return self;
    
}

- (NSDateComponents *)getBeiJingComponents1WithDate:(NSDate *)date{
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSTimeZone *formzone = [NSTimeZone systemTimeZone];
    //    NSInteger formInterval = [formzone secondsFromGMTForDate:date];
    //    NSDate *fromDate = [date dateByAddingTimeInterval:formInterval];
    return  [gregorian components:unitFlags fromDate:date];
}

- (NSInteger)getMontDaysWithMonthIndex:(NSInteger)month1 yearIndex:(NSInteger)years1{
    
    NSInteger monthDays = 30;
    if (month1 == 1 || month1 ==3 || month1 == 5 || month1==7 || month1 == 8 || month1 == 10 || month1 == 12) {
        monthDays = 31;
    }
    
    if (month1 == 2) {
        if (years1%100 == 0) {
            if (years1%400 == 0) {
                monthDays = 29;
            }else{
                monthDays = 28;
            }
        }else{
            if (years1%4 == 0) {
                monthDays = 29;
            }else{
                monthDays = 28;
            }
        }
    }
    
    return monthDays;
}

- (NSInteger)getMonthWithMonthIndex:(NSInteger)month{
    
    if (month == 1) {
        return  12;
    }
    return month-1;
}

- (NSInteger)getYearsWithMonthIndex:(NSInteger)month yearIndex:(NSInteger)years{
    
    if (month == 1) {
        return years -1;
    }
    return years;
}



@end
