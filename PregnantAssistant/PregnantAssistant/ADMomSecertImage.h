//
//  ADMomSecertImage.h
//  PregnantAssistant
//
//  Created by D on 14/12/23.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <Realm/Realm.h>

@interface ADMomSecertImage : RLMObject

@property int index;
@property NSData *shotImg;
@property NSString *imgUrl;

//-(id)initWithImg:(UIImage *)aImage;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<ADMomSecertImage>
RLM_ARRAY_TYPE(ADMomSecertImage)
