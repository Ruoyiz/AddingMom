//
//  ADToolIconDAO.m
//  
//
//  Created by D on 15/7/15.
//
//

#import "ADToolIconDAO.h"
#import "ADTool.h"

@implementation ADToolIconDAO

+ (NSArray *)getRecommandToolsForPreMomAtWeek:(NSInteger)week
{
    NSArray *preWeek = @[
                         [[ADTool alloc]initWithTitle:@"生男生女表"],
                         [[ADTool alloc]initWithTitle:@"孕妈日记"],
                         [[ADTool alloc]initWithTitle:@"胎梦解梦"],
                         [[ADTool alloc]initWithTitle:@"不能吃"],
                         [[ADTool alloc]initWithTitle:@"预产期计算器"],
                         [[ADTool alloc]initWithTitle:@"胎儿发育图"],
                         [[ADTool alloc]initWithTitle:@"HCG参考值"],
                         [[ADTool alloc]initWithTitle:@"孕酮参考值"]
                         ];
    
    NSArray *week1 = @[
                       [[ADTool alloc]initWithTitle:@"胎儿发育图"],
                       [[ADTool alloc]initWithTitle:@"HCG参考值"],
                       [[ADTool alloc]initWithTitle:@"孕酮参考值"],
                       [[ADTool alloc]initWithTitle:@"不能吃"],
                       [[ADTool alloc]initWithTitle:@"B超单解读"],
                       [[ADTool alloc]initWithTitle:@"生男生女表"],
                       [[ADTool alloc]initWithTitle:@"孕期体重标准"],
                       [[ADTool alloc]initWithTitle:@"胎梦解梦"]
                       ];
    
    NSArray *week2 = @[
                       [[ADTool alloc]initWithTitle:@"胎儿发育图"],
                       [[ADTool alloc]initWithTitle:@"不能吃"],
                       [[ADTool alloc]initWithTitle:@"产检日历"],
                       [[ADTool alloc]initWithTitle:@"唐筛查看男女"],
                       [[ADTool alloc]initWithTitle:@"B超单解读"],
                       [[ADTool alloc]initWithTitle:@"孕期体重标准"],
                       [[ADTool alloc]initWithTitle:@"胎儿发育评测"],
                       [[ADTool alloc]initWithTitle:@"数胎动"],
                       [[ADTool alloc]initWithTitle:@"产检档案"]
                       ];
    
    NSArray *week3 = @[
                       [[ADTool alloc]initWithTitle:@"胎儿发育图"],
                       [[ADTool alloc]initWithTitle:@"胎儿体重计算"],
                       [[ADTool alloc]initWithTitle:@"胎儿发育评测"],
                       [[ADTool alloc]initWithTitle:@"产检日历"],
                       [[ADTool alloc]initWithTitle:@"B超单解读"],
                       [[ADTool alloc]initWithTitle:@"孕期体重标准"],
                       [[ADTool alloc]initWithTitle:@"数胎动"],
                       [[ADTool alloc]initWithTitle:@"宫缩计时器"],
                       [[ADTool alloc]initWithTitle:@"坐月子"]
                       ];
    
    NSArray *week4 = @[
                       [[ADTool alloc]initWithTitle:@"数胎动"],
                       [[ADTool alloc]initWithTitle:@"待产包"],
                       [[ADTool alloc]initWithTitle:@"坐月子"],
                       [[ADTool alloc]initWithTitle:@"胎儿体重计算"],
                       [[ADTool alloc]initWithTitle:@"胎儿发育评测"],
                       [[ADTool alloc]initWithTitle:@"宫缩计时器"],
                       [[ADTool alloc]initWithTitle:@"B超单解读"],
                       [[ADTool alloc]initWithTitle:@"产检日历"]
                       ];
    
    NSArray *afterWeek = @[
                           [[ADTool alloc]initWithTitle:@"坐月子"]
                           ];
    
    //judge week
    if (week == -1) {
        return preWeek;
    } else if (week <= 12) {
        return week1;
    } else if (week <= 20) {
        return week2;
    } else if (week <= 28) {
        return week3;
    } else if (week <= 40) {
        return week4;
    } else { //产后
        return afterWeek;
    }
}

+ (NSArray *)getRecommandToolsForAlreadyMom
{
    NSArray *array = @[
                        [[ADTool alloc]initWithTitle:@"疫苗提醒"],
                        [[ADTool alloc]initWithTitle:@"身高体重"],
                      ];
    return array;
}

+ (NSArray *)getToolInAllToolTabIsAlreadyMom:(BOOL)isMom
{
    NSArray *parentArray = @[
                             [[ADTool alloc]initWithTitle:@"疫苗提醒"],
                             [[ADTool alloc]initWithTitle:@"身高体重"]
                             ];

    NSArray *firstArray = @[
                            [[ADTool alloc]initWithTitle:@"不能吃"],
                            [[ADTool alloc]initWithTitle:@"孕期体重标准"],
                            [[ADTool alloc]initWithTitle:@"HCG参考值"],
                            [[ADTool alloc]initWithTitle:@"孕酮参考值"],
                            [[ADTool alloc]initWithTitle:@"胎儿体重计算"],
                            [[ADTool alloc]initWithTitle:@"胎儿发育评测"],
                            [[ADTool alloc]initWithTitle:@"B超单解读"],
                            [[ADTool alloc]initWithTitle:@"胎儿发育图"],
                            [[ADTool alloc]initWithTitle:@"预产期计算器"],
                            [[ADTool alloc]initWithTitle:@"坐月子"]
                            ];

    NSArray *secondArray = @[
                             [[ADTool alloc]initWithTitle:@"产检日历"],
                             [[ADTool alloc]initWithTitle:@"产检档案"],
                             [[ADTool alloc]initWithTitle:@"孕妈日记"],
                             [[ADTool alloc]initWithTitle:@"大肚成长记"],
                             [[ADTool alloc]initWithTitle:@"待产包"],
                             [[ADTool alloc]initWithTitle:@"数胎动"],
                             [[ADTool alloc]initWithTitle:@"宫缩计时器"]
                             ];

    NSArray *thirdArray = @[
                            [[ADTool alloc]initWithTitle:@"生男生女表"],
                            [[ADTool alloc]initWithTitle:@"唐筛查看男女"],
                            [[ADTool alloc]initWithTitle:@"胎梦解梦"]
                            ];

    NSArray *lastArray = @[
                           [[ADTool alloc]initWithTitle:@"为我点赞"]
                           ];
    if (isMom) {
        return @[parentArray, firstArray, secondArray, thirdArray, lastArray];
    } else {
        return @[firstArray, secondArray, thirdArray, lastArray];
    }
}

@end
