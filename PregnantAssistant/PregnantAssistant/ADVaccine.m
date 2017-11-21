//
//  ADVaccine.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/8.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVaccine.h"
#import "ADVaccineDAO.h"

@implementation ADVaccine

+ (NSDictionary *)defaultPropertyValues
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"0" forKey:@"uid"];
    [dic setObject:@"" forKey:@"vaccineName"];
    [dic setObject:@"" forKey:@"vaccineTime"];
    [dic setObject:@"" forKey:@"vaccineTag"];
    [dic setObject:@"" forKey:@"vaccineDes"];
    [dic setObject:@"" forKey:@"vaccineId"];
    [dic setObject:@"0" forKey:@"isCollected"];
    [dic setObject:@"0" forKey:@"haveVaccinated"];
    [dic setObject:@"0" forKey:@"vaccindateDateStamp"];
    [dic setObject:@"0" forKey:@"noteDateStamp"];
    [dic setObject:@"0" forKey:@"vaccindateDateStr"];
    [dic setObject:@"0" forKey:@"vaccineOverDue"];
    [dic setObject:@"0" forKey:@"orginVaccineDateStr"];
    return dic;
}

+ (ADVaccine *)getModelFromDic:(NSDictionary *)dic uid:(NSString *)uid
{
    ADVaccine *model = [[ADVaccine alloc] init];
    model.uid = uid;
    model.vaccineName = [dic objectForKey:@"name"];
    model.vaccineTime = [dic objectForKey:@"time"];
    model.vaccineTag = [dic objectForKey:@"tag"];
    model.vaccineDes = [dic objectForKey:@"vaccineDes"];
    model.vaccineId = [dic objectForKey:@"vaccineId"];
    model.vaccineOverDue = [dic objectForKey:@"vaccineOverDue"];
    NSString *dateStr = [dic objectForKey:@"vaccindateDate"];
    model.vaccindateDateStr = dateStr;
    model.orginVaccineDateStr = dateStr;
    
    //NSLog(@"..... %@, %@,%ld",model.vaccineName,dateStr,(long)[dateStr integerValue]);
    if ([model.vaccindateDateStr integerValue] <= 1) {
        model.haveVaccinated = @"1";
    }
    
    return model;
}

+ (BOOL)isConflictToWuLianVaccine:(NSString *)name
{
    if ([name isEqualToString:@"百白破疫苗"] || [name isEqualToString:@"脊灰疫苗"] || [name isEqualToString:@"Hib疫苗"]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)shouldAddVaccine:(ADVaccine *)model
{
    NSString *name = [[model.vaccineName componentsSeparatedByString:@" "] firstObject];
    if ([ADVaccine isConflictToWuLianVaccine:name]) {
        
        ADVaccine *wuLianVaccine = [ADVaccineDAO getWuLianVaccine];
        if ([wuLianVaccine.isCollected isEqualToString:@"1"]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)shouldAddWuLianVaccine:(ADVaccine *)model reason:(void (^) (BOOL canAdd,ADVaccine *reModel))reason
{
   // NSString *name = [[model.vaccineName componentsSeparatedByString:@" "] firstObject];
    NSMutableArray *array = [ADVaccineDAO readAllVaccineCollected:@"1"];
    for (ADVaccine *vaccineModel in array) {
        NSString *name = [[vaccineModel.vaccineName componentsSeparatedByString:@" "] firstObject];
        if ([self isConflictToWuLianVaccine:name]) {
            if ([vaccineModel.haveVaccinated isEqualToString:@"1"]) {
                
                reason(NO,vaccineModel);
                return NO;
            }
        }
    }
    reason(YES,nil);
    return YES;
}



@end
