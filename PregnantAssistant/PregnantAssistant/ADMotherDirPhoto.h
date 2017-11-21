//
//  ADMotherDirPhoto.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/8/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "RLMObject.h"
#import <Realm/Realm.h>


@interface ADMotherDirPhoto : RLMObject
@property NSString *uid;
@property NSString *imageName;
@property NSData *imageData;
@property BOOL isUpload;
- (instancetype)initWithImageName:(NSString *)imageName ImageDate:(UIImage *)image isUpload:(BOOL)isupload;

@end


RLM_ARRAY_TYPE(ADMotherDirPhoto)
