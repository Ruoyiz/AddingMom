//
//  ADHelper.h
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADAppDelegate.h"
#import "DESUtils.h"

@interface ADHelper : NSObject
//向url中添加cookie
+ (NSMutableURLRequest *)getCookieRequestWithUrl:(NSURL *)url;

//添加userAgent
+ (void)addUseragent;

//获取系统版本
+ (NSString *)getIOSVersion;

//获取app版本
+ (NSString *)getVersion;

+ (NSString *)getCurrentDay;

+ (NSString *)getCurrentHourAndMin;

//+ (NSString *)getCurrentDayAndHour;
+ (NSString *)getDateLabelStrWithDate:(NSDate *)aDate;

+ (NSString *)getDueLabelStrWithDate:(NSDate *)aDate;

+ (NSDate *)getDueDate;
+ (NSString *)getDueDateStrWithBlank:(BOOL)aBlank;

+ (NSString *)getMonthDateStr;

+ (NSString *)getHourMinSecWithDate:(NSDate *)aDate;
+ (NSString *)getIntervalWithDate:(NSDate *)aDate andDate2:(NSDate *)aDate2;

+ (NSString *)getTitleStrFromDate:(NSDate *)aDate;

+ (BOOL)isDurationBigger1Hour:(NSDate*)date1 date2:(NSDate*)date2;

+ (BOOL)isBiggerSecWithDate1:(NSDate*)date1 date2:(NSDate*)date2;

+ (BOOL)isBiggerOrSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2;

+ (BOOL)isBiggerOrSameWithDate1:(NSDate*)date1 date2:(NSDate*)date2;

+ (int)getNavigationBarHeight;

+ (void)showAlertWithMessage:(NSString *)message;

+ (NSArray *)getArrayFromTxt:(NSString *)aTxt;

+ (BOOL)isIphone4;

+ (long)getStrLength:(NSString*)strtemp;

+ (void)changeStatusBarColorWhite;
+ (void)changeStatusBarColorblack;

+ (NSString *)getStrAtHour:(NSInteger)hour;

+ (NSString *)getHourAndMinWithDate:(NSDate *)aDate;

+ (NSString *)getMostHourWithDate:(NSDate *)aDate;

+ (BOOL)validDate:(NSDate *)vDate withMaxDate:(NSDate *)maxDate;

+ (NSDate *)fakeDateWithHour:(int)aHour andMin:(int)aMin;

+ (NSString *)getPicNameFromDate:(NSDate *)aDate;

+ (NSString *)getCellTitleWithDate:(NSDate *)aDate;

+ (NSString *)getCircleTitleWithDate:(NSDate *)aDate;

+ (NSString *)getHealthLineLabelWithDate:(NSDate *)aDate;

+ (void)showToastWithText:(NSString *)aTxt;

+ (void)showToastWithText:(NSString *)aTxt andFontSize:(NSInteger)fontSize;

+ (void)showToastWithText:(NSString *)aText frame:(CGRect)frame;

+ (void)showToastWithText:(NSString *)aTxt
              andFontSize:(NSInteger)fontSize
                 andFrame:(CGRect)frame;

+ (UIImage *)reduceImg:(UIImage *)aImg inKBSize:(CGFloat)aSize;

+ (NSInteger)getToInt:(NSString*)strtemp;

+ (NSString *)getIdfv;
+ (NSString *)getUId;

+ (BOOL)isUrlContainAdding:(NSString *)aUrl;

+ (NSInteger)getAgeWithBirthDate:(NSDate *)birthday;

+ (NSDate *)modifyToZeroHourMinWithDate:(NSDate *)aDate;

+ (NSDate *)getBirthDate;
+ (NSDate *)badgeDate;

+ (UIImage*)scaleImg:(UIImage*)image toSize:(CGSize)newSize;

+ (NSDate *)makeDateWithYear:(int)aYear month:(int)aMonth day:(int)aDay Hour:(int)aHour andMin:(int)aMin;

+ (NSString *)getMinsBySecond:(NSString *)secs;

+ (NSString *)getAmongTimeByTimeSp:(NSString *)timesp;

+ (void)presentVc:(UIViewController *)aVc atVc:(UIViewController *)targetVc hiddenNavi:(BOOL)hidden loginControl:(ADLoginControl *)control;

+ (NSInteger)getIndexOfVc:(id)vc FromArray:(NSArray *)array;

+ (NSMutableAttributedString *)getEMAttributeStringFromEmString:(NSString *)str font:(UIFont *)font color:(UIColor *)color highlightColor:(UIColor *)highlightColor;

@end