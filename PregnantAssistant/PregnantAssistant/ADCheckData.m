//
//  ADCheckData.m
//  PregnantAssistant
//
//  Created by D on 14/11/27.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCheckData.h"

@implementation ADCheckData

- (id)initWithWeight:(NSString *)aWeight
    andLowBloodPress:(NSString *)aLowBloodPress
   andHighBloodPress:(NSString *)aHighBloodPress
        andHeartBeat:(NSString *)aHeartBeat
     andPalaceHeight:(NSString *)aPalaceHeight
  andAbCircumference:(NSString *)aAbCircumference
             andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.weight = aWeight;
        self.lowBloodPress = aLowBloodPress;
        self.highBloodPress = aHighBloodPress;
        self.heartBeat = aHeartBeat;
        self.palaceHeight = aPalaceHeight;
        self.abCircumference = aAbCircumference;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

- (id)initWithWeight:(NSString *)aWeight
             andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.weight = aWeight;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

- (id)initWithLowBloodPress:(NSString *)aLowBloodPress
          andHighBloodPress:(NSString *)aHighBloodPress
                    andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.lowBloodPress = aLowBloodPress;
        self.highBloodPress = aHighBloodPress;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

- (id)initWithHeartBeat:(NSString *)aHeartBeat
                andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.heartBeat = aHeartBeat;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

- (id)initWithPalaceHeight:(NSString *)aPalaceHeight
                   andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.palaceHeight = aPalaceHeight;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

- (id)initWithAbCircumference:(NSString *)aAbCircumference
                      andDate:(NSDate *)aDate
{
    if (self = [super init]) {
        self.abCircumference = aAbCircumference;
        self.aDate = aDate;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
    }
    return self;
}

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"uid":@"0", @"weight":@"", @"lowBloodPress":@"", @"highBloodPress":@"",
             @"heartBeat":@"", @"palaceHeight":@"", @"abCircumference":@""};
}

@end
