//
//  ADBabyShotDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/20.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADShotPhoto.h"
#import "ADUserSyncTimeDAO.h"

@interface ADBabyShotDAO : NSObject

+ (RLMResults *)readAllData;

+ (void)savePhotoWithImage:(UIImage *)aImg
                    andUrl:(NSString *)aUrl
                   andDate:(NSDate *)aDate
                  isUpload:(BOOL)isupload
                  onFinish:(void (^)())aFinishBlock;
+ (void)updatePhotoWithUrl:(NSString *)aUrl
                  toNewUrl:(NSString *)newUrl
                  isUpload:(BOOL)isupload;
+ (void)removeAPhoto:(ADShotPhoto *)aPhoto
            onFinish:(void (^)())aFinishBlock;

+ (void)distrubuteData;

+ (void)uploadAllDataOnFinish:(void (^)(NSError *error))aFinishBlock;

+ (void)uploadOldDataOnFinish:(void (^) (void))aFinishBlock;

+ (void)syncAllDataOnGetData:(void(^)(NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

@end
