//
//  ADMomSecertDAO.m
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMomSecertDAO.h"

@implementation ADMomSecertDAO

+ (RLMResults *)readImage
{
    return
    [[ADMomSecertImage allObjects]sortedResultsUsingProperty:@"index" ascending:YES];
}

+ (void)saveImage:(ADMomSecertImage *)aImage
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:aImage];
    
    [realm commitWriteTransaction];
}

+ (void)removeImage:(ADMomSecertImage *)aPhoto
{
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:aPhoto];
    [realm commitWriteTransaction];
}

+ (void)removeAllImg
{
    RLMResults *allImg = [ADMomSecertImage allObjects];
    RLMRealm* realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:allImg];
    
    [realm commitWriteTransaction];
}

@end
