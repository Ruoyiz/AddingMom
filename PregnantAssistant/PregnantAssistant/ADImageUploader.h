//
//  ADImageUploader.h
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADImageUploader : NSObject

+ (void)uploadWithImage:(UIImage *)uploadImg
                 toPath:(NSString *)aPath
          progressBlock:(void (^)(CGFloat percent,
                                  long long requestDidSendBytes))progressBlock
          completeBlock:(void (^)(NSError * error,
                                  NSDictionary * result,
                                  NSString *imgUrl,
                                  BOOL completed))completeBlock;

+ (void)uploadImagesWithArary:(NSArray *)uploadImgArray
                       toPath:(NSArray *)paths
                progressBlock:(void (^)(CGFloat percent,
                                        long long requestDidSendBytes))progressBlock
                completeBlock:(void (^)())completeBlock;


+ (NSString *)generateImageName;

@end
