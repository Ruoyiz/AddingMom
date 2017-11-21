//
//  ADConstants.h
//  PregnantAssistant
//
//  Created by D on 14/10/30.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#pragma once

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES:NO)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES:NO)

#define RETINA_INCH4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define LESS_RETINA_INCH_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)  //获取屏幕 宽度
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height) //获取屏幕 高度
#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)

//#define NAVIGATIONVIEW_HEIGHT (IOS7_OR_LATER?65:45)

#define MAIN_WINDOW  [[[UIApplication sharedApplication] windows] objectAtIndex:0]//获得主窗口
#define APP_DELEGATE (ADAppDelegate *)[[UIApplication sharedApplication] delegate]//获得Appdelegate

#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBAndAlpha(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define UICOLOR(R, G, B, A)[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//在Main线程上运行
#define DISPATCH_ON_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//在Global Queue上运行
#define DISPATCH_ON_GLOBAL_QUEUE_HIGH(globalQueueBlock) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), globalQueueBlock);
#define DISPATCH_ON_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlock);
#define DISPATCH_ON_GLOBAL_QUEUE_LOW(globalQueueBlock) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), globalQueueBlock);
#define DISPATCH_ON_GLOBAL_QUEUE_BACKGROUND(globalQueueBlock) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), globalQueueBlock);

#define PIC_NUM_LIMIT 40

#define haveReadNumKey @"haveReadNumKey"

static NSString * addingMomSecretImagesKey = @"adSecertImagesUrlKey";

static NSString * baseTestApiUrl = @"api.addinghome.com";

static NSString * baseApiUrl = @"api.addinghome.com";

static NSString *dateKey = @"CHECKDATEKEY";

typedef enum {
    hotStoryType = 0,
    allStoryType
} viewType;

//孕妈看看资源列表数据
#define kMomLookChannelIds @"kMomLookChannelIds"
#define kMomLookChannelNames @"kMomLookChannelNames"

#define atLeastIconNumTip @"您不能取消了，需要至少保留5个小工具为收藏状态哦~"

typedef NS_ENUM(NSInteger, WeatherType) {
    springType,
    summerType,
    autumnType,
    winterType
};

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#define NAVIBAT_HEIGHT 64

#define CellLeftEdge 12

