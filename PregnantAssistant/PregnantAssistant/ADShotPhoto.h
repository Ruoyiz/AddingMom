//
//  ADShotPhoto.h
//  PregnantAssistant
//
//  Created by D on 14/11/24.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADShotPhoto : RLMObject

@property NSString *uid;
@property NSDate *shotDate;
@property NSData *shotImg;
@property NSString *url;
@property BOOL isUpload;

- (instancetype)initWithImg:(UIImage *)aImg shotDate:(NSDate *)aDate;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADShotPhoto>
RLM_ARRAY_TYPE(ADShotPhoto)
