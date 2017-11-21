//
//  ADCollectTool.m
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADTool.h"

@implementation ADTool

- (id)initWithTitle:(NSString *)aTitle
           andIsWeb:(BOOL)aWeb
              andVC:(NSString *)aVc
          andToolId:(NSString *)aId
    andIsParentTool:(BOOL)aParentTool
{
    if (self = [super init]) {
        self.title = aTitle;
        self.isWeb = aWeb;
        self.toolId = aId;
        self.myVc = aVc;
        self.uid = [[NSUserDefaults standardUserDefaults] addingUid];
        self.isParentTool = aParentTool;
        
//        NSLog(@"isParentTool:%d %d", self.isParentTool, aParentTool );
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle
{
    NSString *vcName = [self getToolVcNameFromTitle:aTitle];
    BOOL isWeb = NO;
    if (vcName.length == 0) {
        isWeb = YES;
    }
    
    return [self initWithTitle:aTitle
                      andIsWeb:isWeb
                         andVC:vcName
                     andToolId:[self getToolIdFromTitle:aTitle]
               andIsParentTool:[self getIsParentToolFromTitle:aTitle]];
}

- (id)initWithIoolId:(NSString *)aToolId
{
    NSString *aTitle = [self getToolNameFromToolId:aToolId];
    NSString *vcName = [self getToolVcNameFromTitle:aTitle];
    BOOL isWeb = NO;
    if (vcName.length == 0) {
        isWeb = YES;
    }
    
    return [self initWithTitle:aTitle
                      andIsWeb:isWeb
                         andVC:vcName
                     andToolId:aToolId
               andIsParentTool:[self getIsParentToolFromTitle:aTitle]];
}

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"myVc":@""};
}

- (NSString *)getToolNameFromToolId:(NSString *)aToolId
{
    NSArray *allToolArray = [self readAllTool];
    NSDictionary *dic;
    for (int i = 0; i < [allToolArray count]; i++) {
        dic = (NSDictionary *)allToolArray[i];
        if ([dic[@"vcId"] isEqualToString:aToolId]) {
            return dic[@"title"];
        }
    }
    
    return @"";
}

- (NSString *)getToolIdFromTitle:(NSString *)aTitle
{
    NSArray *allToolArray = [self readAllTool];
    NSDictionary *dic;
    for (int i = 0; i < [allToolArray count]; i++) {
        dic = (NSDictionary *)allToolArray[i];
        if ([dic[@"title"] isEqualToString:aTitle]) {
            return dic[@"vcId"];
        }
    }
    
    return @"";
}

- (NSString *)getToolVcNameFromTitle:(NSString *)aTitle
{
    NSArray *allToolArray = [self readAllTool];
    NSDictionary *dic;
    for (int i = 0; i < [allToolArray count]; i++) {
        dic = (NSDictionary *)allToolArray[i];
        if ([dic[@"title"] isEqualToString:aTitle]) {
            return dic[@"vcName"];
        }
    }
    
    return @"";
}

- (BOOL)getIsParentToolFromTitle:(NSString *)aTitle
{
    NSArray *allToolArray = [self readAllTool];
    NSDictionary *dic;
    for (int i = 0; i < [allToolArray count]; i++) {
        dic = (NSDictionary *)allToolArray[i];
        if ([dic[@"title"] isEqualToString:aTitle]) {
            BOOL isParentTool = [(NSNumber*)[dic objectForKey:@"isParentTool"]boolValue];
            return isParentTool;
        }
    }
    
    return NO;
}

-(NSUInteger)hash
{
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.toolId hash];
    
    return result;
}

-(BOOL)isEqual:(id)object
{
    return [self.toolId isEqualToString:[object toolId]];
}

- (NSArray *)readAllTool
{
    NSString *infoPlist = [[NSBundle mainBundle] pathForResource:@"ToolsPlist" ofType:@"plist"];
    return [[NSArray alloc] initWithContentsOfFile:infoPlist];
}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

@end
