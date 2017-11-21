//
//  ADHelper.m
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADHelper.h"
#import "ADLoginControl.h"

#define kAppId @"931197358" //931197358

#define TOAST_LABEL_TAG 209990

static NSString *DesKey = @"addingaddingzaiyiqi";

@implementation ADHelper
//添加userAgent
+ (void)addUseragent
{
    NSString *userAgent = [[[UIWebView alloc] init] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *newUserAgent = [NSString stringWithFormat:@"PregnantAssistant/%@ iOS/%@", [ADHelper getVersion],[ADHelper getIOSVersion]];
    NSString *customUserAgent = [userAgent stringByAppendingFormat:@" %@", newUserAgent];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent":customUserAgent}];
}

//添加cookie
+ (NSMutableURLRequest *)getCookieRequestWithUrl:(NSURL *)url
{
    NSDictionary *dictCookieUId = [NSDictionary dictionaryWithObjectsAndKeys:@"idfv", NSHTTPCookieName,
                                   [ADHelper getIdfv], NSHTTPCookieValue,
                                   @"/", NSHTTPCookiePath,
                                   @"test.com", NSHTTPCookieDomain,
                                   nil];
    
    NSHTTPCookie *cookieUserId = [NSHTTPCookie cookieWithProperties:dictCookieUId];
    
    //set token to cookie
//    
//    NSDictionary *dictCookiePToken = [NSDictionary dictionaryWithObjectsAndKeys:@"uidenc", NSHTTPCookieName,
//                                      
//                                      [ADHelper getUId], NSHTTPCookieValue,
//                                      
//                                      @"/", NSHTTPCookiePath,
//                                      
//                                      @"test.com", NSHTTPCookieDomain,
//                                      
//                                      nil];
   // NSHTTPCookie *cookiePassToken = [NSHTTPCookie cookieWithProperties:dictCookiePToken];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    // set cookies
    NSArray *arrCookies = [NSArray arrayWithObjects: cookieUserId, nil];
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    [request setValue: [dictCookies objectForKey:@"Cookie"] forHTTPHeaderField: @"Cookie"];
    
    return request;
}

+ (NSString *)getIOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSDate *)fakeDateWithHour:(int)aHour andMin:(int)aMin
{
    NSDate *today = [NSDate date];
    
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                                   fromDate:today];
    
    // Set the hour, minute, second to be zero
    components.hour = aHour;
    components.minute = aMin;
    components.second = 0;
    
    // Create the date
    return  [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSDate *)makeDateWithYear:(int)aYear month:(int)aMonth day:(int)aDay Hour:(int)aHour andMin:(int)aMin
{
    NSDate *today = [NSDate date];
    
    // Get the year, month, day from the date
    NSDateComponents *components =
    [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:today];
    
    // Set the hour, minute, second to be zero
    components.year = aYear;
    components.month = aMonth;
    components.day = aDay;
    components.hour = aHour;
    components.minute = aMin;
    components.second = 0;
    
    // Create the date
    return  [[NSCalendar currentCalendar] dateFromComponents:components];
}

+ (NSString *)getVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return infoDict[@"CFBundleShortVersionString"];
}

+ (NSString *)getCurrentDay
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日", (long)year, (long)month, (long)day];
}

+ (NSString *)getDateLabelStrWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    NSInteger hour =  [dateComponents hour];
    NSInteger min =  [dateComponents minute];
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld:%02ld",
            (long)year, (long)month, (long)day, (long)hour, (long)min];
}

+ (NSString *)getDueLabelStrWithDate:(NSDate *)aDate
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:aDate];
    int days=((int)time)/(3600*24) ;
    
    int passDay = 280 - days -1;
    //hide _dueLabel when high
    if(passDay > 280) {
        return @"";
    } else {
        int week = passDay /7;
        int dueday = passDay %7;
        
        return  [NSString stringWithFormat:@"孕%d周%d天", week, dueday];
    }
}

+ (NSString *)getCurrentHourAndMin
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger hour =  [dateComponents hour];
    NSInteger min =  [dateComponents minute];
    
    return [NSString stringWithFormat:@"%2ld:%02ld", (long)hour, (long)min];
}

+ (NSString *)getHourMinSecWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger hour =  [dateComponents hour];
    NSInteger min =  [dateComponents minute];
    NSInteger sec = [dateComponents second];
    
    return [NSString stringWithFormat:@"%2d:%02d:%02d", (int)hour, (int)min, (int)sec];
}

+ (NSString *)getIntervalWithDate:(NSDate *)aDate andDate2:(NSDate *)aDate2
{
    NSTimeInterval time = [aDate timeIntervalSinceDate:aDate2];
    int hour = ((int)time)/(3600);
    int min = ((int)time)/(60) %60;
    int sec = ((int)time)%(60);
    
    //间隔时间大于12h 后 重新计时
    if (hour >= 12) {
        if (min > 0 || sec >0) {
            hour = hour %12;
        }
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hour, (int)min, (int)sec];
}

+ (NSString *)getTitleStrFromDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger year =  [dateComponents year];
    NSInteger month =  [dateComponents month];
    NSInteger day = [dateComponents day];

    NSString *titlestr = [NSString stringWithFormat:@"%d-%02d-%2d",(int)year, (int)month, (int)day];
    return titlestr;
}

+ (NSString *)getPicNameFromDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                             | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger year =  [dateComponents year];
    NSInteger month =  [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger min = [dateComponents minute];
    NSInteger sec = [dateComponents second];
    
    NSString *titlestr = [NSString stringWithFormat:@"momPic-%d-%d-%d-%d-%d-%d",
                          (int)year, (int)month, (int)day, (int)hour, (int)min, (int)sec];
    return titlestr;
}

+ (NSString *)getCellTitleWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:aDate];
    int days=((int)time)/(3600*24);
    if (days < 0) {
        days = 0;
    }
    int passDay = 280 -days -1;
    
    int week = passDay /7;
    int dueday = passDay %7;
    
    NSString *subYearStr =
    [[NSString stringWithFormat:@"%d", (int) year] substringWithRange:NSMakeRange(2, 2)];
    
    if (passDay > 280 || passDay < 0) {
        return
        [NSString stringWithFormat:@"%@-%d-%d",subYearStr, (int)month, (int)day];
    } else {
        return
        [NSString stringWithFormat:@"%@-%d-%d 孕%d周%d天",subYearStr, (int)month, (int)day,week,dueday];
    }
}

+ (NSDate *)getDueDate
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    return appDelegate.dueDate;
}

+ (NSDate *)getBirthDate
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    return appDelegate.babyBirthday;
//    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
//    NSTimeInterval timeInterval = [timeZone secondsFromGMTForDate:appDelegate.babyBirthday];
   // return [appDelegate.babyBirthday dateByAddingTimeInterval:timeInterval-1];
}

+ (NSString *)getDueDateStrWithBlank:(BOOL)aBlank
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDate *date = [self getDueDate];
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    if (aBlank) {
        return
        [NSString stringWithFormat:@"%d - %d - %d",(int)year, (int)month, (int)day];
    } else {
        return
        [NSString stringWithFormat:@"%d-%d-%d",(int)year, (int)month, (int)day];
    }
}

+ (NSString *)getMostHourWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger hour = [dateComponents hour];
    NSInteger min = [dateComponents minute];
    
    return
    [NSString stringWithFormat:@"%2d:%02d - %2d:%02d", (int)hour, (int)min, (int)hour +1, (int)min];
}

+ (NSString *)getMonthDateStr
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSInteger day = [dateComponents day];
    NSInteger month = [dateComponents month];
    NSInteger year = [dateComponents year];
    
    return
    [NSString stringWithFormat:@"%d-%d-%d",(int)year, (int)month, (int)day];
}

+ (BOOL)validDate:(NSDate *)vDate withMaxDate:(NSDate *)maxDate
{
    NSTimeInterval secs = [vDate timeIntervalSinceDate:maxDate];
    if (secs <= -3600.0) {
        return YES;
    } else if (secs >= 3600.0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isDurationBigger1Hour:(NSDate*)date1 date2:(NSDate*)date2
{
    NSTimeInterval secs = [date1 timeIntervalSinceDate:date2];

    if(fabs(secs) >= 3600.0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isBiggerSecWithDate1:(NSDate*)date1 date2:(NSDate*)date2
{
    NSTimeInterval secs = [date1 timeIntervalSinceDate:date2];
    if (secs > 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isBiggerOrSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    if ([comp1 year] > [comp2 year]) {
        return YES;
    } else {
        if ([comp1 day] >= [comp2 day] &&
            [comp1 month] >= [comp2 month]) {
            NSLog(@"return ye");
            return YES;
        } else {
            NSLog(@"return no");
            return NO;
        }
    }
}

+ (BOOL)isBiggerOrSameWithDate1:(NSDate*)date1 date2:(NSDate*)date2
{
    NSTimeInterval secondsBetweenDates= [date1 timeIntervalSinceDate:date2];
    if (secondsBetweenDates >= 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (int)getNavigationBarHeight
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return 64;
    }else{
        return 44;
    }
}


+ (NSArray *)getArrayFromTxt:(NSString *)aTxt
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:aTxt ofType:@"txt"];
    NSString *csvString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *locations = [csvString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSMutableArray *locationsArray = [NSMutableArray array];
    for (NSString * location in locations)
    {
        NSArray *components = [location componentsSeparatedByString:@"\n"];
        for(NSString *aComponent in components)
        {
            NSArray *components = [aComponent componentsSeparatedByString:@";"];
            
            NSString *name =  components[0];
            NSString *resons =  components[1];
            NSString *num =  components[2];
            NSNumber *score  = components[3];
            
            NSArray *aThing = @[name, resons, num, score];
            
            [locationsArray addObject:aThing];
        }
    }
    return locationsArray;
}

+ (void)showAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲爱的" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

+ (BOOL)isIphone4
{
    if ([[UIScreen mainScreen] applicationFrame].size.height == 460
        || [[UIScreen mainScreen] applicationFrame].size.height == 480) {
        return YES;
    } else {
        return NO;
    }
}

+ (long)getStrLength:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

+ (void)changeStatusBarColorWhite
{
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

+ (void)changeStatusBarColorblack
{
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}

// return 23:00
+ (NSString *)getStrAtHour:(NSInteger)hour
{
    return [NSString stringWithFormat:@"%02d:00",(int)hour];
}

+ (NSString *)getHourAndMinWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger hour = [dateComponents hour];
    NSInteger min = [dateComponents minute];
    
    return
    [NSString stringWithFormat:@"%2d:%02d",(int)hour, (int)min];
}

+ (NSString *)getCircleTitleWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:aDate];
    NSInteger year =  [dateComponents year];
    NSInteger month =  [dateComponents month];
    NSInteger day = [dateComponents day];
    NSString *subYearStr;
    if (year > 0) {
        subYearStr = [[NSString stringWithFormat:@"%ld", (long)year] substringWithRange:NSMakeRange(2, 2)];
    }
    NSString *titlestr = [NSString stringWithFormat:@"%@/%02d/%d",subYearStr, (int)month, (int)day];
    return titlestr;
}

+ (NSString *)getHealthLineLabelWithDate:(NSDate *)aDate
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    long days= (long)[aDate distanceInDaysToDate:appDelegate.dueDate];
    if (days < 0) {
        days = 0;
    }
    long passDay = 280 -days;
    
    long week = passDay /7;
    long dueday = passDay %7;
    
    return [NSString stringWithFormat:@"%02ldW%ldD",(long)week,(long)dueday];
}

+ (void)showToastWithText:(NSString *)aTxt
{
    [self showToastWithText:aTxt andFontSize:15 andFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
}

+ (void)showToastWithText:(NSString *)aTxt andFontSize:(NSInteger)fontSize
{
    [self showToastWithText:aTxt andFontSize:fontSize andFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
}

+ (void)showToastWithText:(NSString *)aText frame:(CGRect)frame
{
    [self showToastWithText:aText andFontSize:15 andFrame:frame];
}

+ (void)showToastWithText:(NSString *)aTxt
              andFontSize:(NSInteger)fontSize
                 andFrame:(CGRect)frame
{
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    //判断屏幕上是否已经存在toast
    UILabel *toastLabel = (UILabel *)[appDelegate.window viewWithTag:TOAST_LABEL_TAG];
    
    if (toastLabel) {
        return;
    }
    
    toastLabel = [[UILabel alloc]initWithFrame:frame];
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.font = [UIFont fontWithName:RTWSYueGoTrial_Light size:fontSize];
    toastLabel.textColor = [UIColor whiteColor];
    toastLabel.backgroundColor = UIColorFromRGBAndAlpha(0x4d4587, 0.9);
    toastLabel.alpha = 0;
    toastLabel.text = aTxt;
    toastLabel.tag = TOAST_LABEL_TAG;
    [appDelegate.window addSubview:toastLabel];
    
    [UIView animateWithDuration:0.3 animations:^{
        toastLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionLayoutSubviews animations:^{
            toastLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [toastLabel removeFromSuperview];
        }];
    }];
}

+ (UIImage *)reduceImg:(UIImage *)aImg inKBSize:(CGFloat)aSize
{
    NSData *imgData = UIImageJPEGRepresentation(aImg, 1); //1 it represents the quality of the image.
    if ((imgData.length/1024) >= aSize) {
        
        while ((imgData.length/1024) >= aSize) {
            // Pass the NSData out again
            imgData = UIImageJPEGRepresentation(aImg, 0.02);
        }
    }
    
    return [UIImage imageWithData:imgData];
}

+ (NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

+ (NSString *)getIdfv
{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSString *)getUId
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ([uid isEqualToString:@"0"]) {
        uid = @"";
    }
    NSString *result = [DESUtils encryptUseDES:uid key:DesKey];
//    NSLog(@"uid:%@", [[NSUserDefaults standardUserDefaults] addingUid]);
//    NSLog(@"uid res:%@ en:%@", result, [DESUtils decryptUseDES:result key:DesKey]);
    
    return result;
}

+ (BOOL)isUrlContainAdding:(NSString *)aUrl
{
    if ([aUrl myContainsString:@"adding"]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSInteger)getAgeWithBirthDate:(NSDate *)birthday
{
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit
                                                                      fromDate:birthday
                                                                        toDate:[NSDate date]
                                                                       options:0];
    return [ageComponents year];
}

+ (NSDate *)modifyToZeroHourMinWithDate:(NSDate *)aDate
{
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:aDate];
    
    components.hour = 0;
    components.minute = 0;
    components.second = 1;

    NSDate *finialDate = [calendar dateFromComponents:components];
    return finialDate;
}

+ (NSDate *)badgeDate
{
    NSDate *today = [NSDate date];
    
    NSDate *tomorrow = [today dateByAddingDays:1];
    NSCalendar *calendar= [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSCalendarUnitDay
                                               fromDate:tomorrow];

    components.hour = 7;
    components.minute = 0;
    components.second = 0;
    
    NSDate *finialDate = [calendar dateFromComponents:components];
    
    
    return finialDate;
}

+ (UIImage*)scaleImg:(UIImage*)image toSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

+ (NSString *)getMinsBySecond:(NSString *)secs
{
    NSInteger min = secs.intValue / 60;
    if (min == 0) {
        min = 1;
    }
    return [NSString stringWithFormat:@"%ld分钟阅读", (long)min];
}

+ (NSString *)getAmongTimeByTimeSp:(NSString *)timesp
{
    NSString *aTime = @"";
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timesp.intValue];
    NSInteger hour = [createDate hoursBeforeDate:[NSDate date]];
    if (hour == 0) {
        NSInteger min = [createDate minutesBeforeDate:[NSDate date]];
        if (min == 0) {
            aTime = @"刚刚";
        } else {
            aTime = [NSString stringWithFormat:@"%ld分钟前", (long)min];
        }
    } else if (hour >= 24) {
        NSInteger day = [createDate daysBeforeDate:[NSDate date]];
        aTime = [NSString stringWithFormat:@"%ld天前", (long)day];
    } else {
        aTime = [NSString stringWithFormat:@"%ld小时前", (long)hour];
    }
    return aTime;
}

+ (void)presentVc:(UIViewController *)aVc atVc:(UIViewController *)targetVc hiddenNavi:(BOOL)hidden loginControl:(ADLoginControl *)control
{
    aVc.view.frame = CGRectMake(0, SCREEN_HEIGHT, aVc.view.frame.size.width, aVc.view.frame.size.height);
    [targetVc.view addSubview:aVc.view];
    [targetVc addChildViewController:aVc];
    
    if (targetVc.navigationController.navigationBar.hidden == YES) {
        control.superNavBarHidden = YES;
    }else{
        control.superNavBarHidden = NO;
    }

    control.targetVC = targetVc;
    
    [targetVc.navigationController setNavigationBarHidden:hidden animated:YES];
    
    [UIView animateWithDuration:0.26 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        aVc.view.frame = CGRectMake(0, 0, aVc.view.frame.size.width, aVc.view.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}

+ (NSInteger)getIndexOfVc:(id)vc FromArray:(NSArray *)array
{
    return [array indexOfObject:vc];
}

+ (NSMutableAttributedString *)getEMAttributeStringFromEmString:(NSString *)str font:(UIFont *)font color:(UIColor *)color highlightColor:(UIColor *)highlightColor
{
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] init];;
    NSArray *array = [str componentsSeparatedByString:@"<em>"];
    if (array.count == 1) {
        [aAttributedString appendAttributedString:[self getAttributeStringWithStr:str font:font color:color]];
    }else{
        for (int i = 0; i < array.count; i++) {
            NSString *subStr = [array objectAtIndex:i];
            NSArray *subArray = [subStr componentsSeparatedByString:@"</em>"];
            if ([subStr myContainsString:@"</em>"]) {
                if(subArray.count == 1){
                    [aAttributedString appendAttributedString:[self getAttributeStringWithStr:[subArray firstObject] font:font color:highlightColor]];
                }else{
                    [aAttributedString appendAttributedString:[self getAttributeStringWithStr:[subArray firstObject] font:font color:highlightColor]];
                    [aAttributedString appendAttributedString:[self getAttributeStringWithStr:[subArray lastObject] font:font color:color]];
                }
            }else{
                [aAttributedString appendAttributedString:[self getAttributeStringWithStr:[subArray firstObject] font:font color:color]];
            }
        }
    }
    
    return aAttributedString;
}

+ (NSAttributedString *)getAttributeStringWithStr:(NSString *)str font:(UIFont *)font color:(UIColor *)color
{
    NSMutableAttributedString *muSubAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    return muSubAttStr;
}

@end
