//
//  ADMomSecertDAO.h
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMomSecertImage.h"

@interface ADMomSecertDAO : NSObject

+ (RLMResults *)readImage;
+ (void)saveImage:(ADMomSecertImage *)aImage;
+ (void)removeImage:(ADMomSecertImage *)aPhoto;
+ (void)removeAllImg;

@end
