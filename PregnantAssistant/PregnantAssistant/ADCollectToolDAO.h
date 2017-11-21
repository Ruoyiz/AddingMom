//
//  ADCollectToolDAO.h
//  PregnantAssistant
//
//  Created by D on 15/4/27.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADTool.h"
#import "ADIcon.h"

@interface ADCollectToolDAO : NSObject

+ (void)updateDataBaseOnfinish:(void (^)(void))aFinishBlock;

+ (RLMResults *)readAllPregToolData;
+ (RLMResults *)readAllParentToolData;

+ (void)collectAToolWithTitle:(NSString *)aTitle recordTime:(BOOL)isrecord;
//+ (void)collectAToolWithTitle:(NSString *)aTitle andIsParentsBabyTool:(BOOL)isparents;
+ (void)autoCollectAToolWithTitle:(NSString *)aTitle;// isParent:(BOOL)isParent;
+ (void)unCollectAToolWithTitle:(NSString *)aTitle recordTime:(BOOL)isrecord;
+ (void)unCollectAToolWithTitle:(NSString *)aTitle
                       onFinish:(void (^)(NSError *))aFinishBlock;
//+ (void)unCollectAParentToolWithTitle:(NSString *)aTitle
//                             onFinish:(void (^)(NSError *))aFinishBlock;

+ (BOOL)hasCollectAToolWithTitle:(NSString *)aTitle;
//                    isParentTool:(BOOL)isParentTool;

//+ (void)updateDataWithArray:(NSArray *)array
//               onCompletion:(void (^)())completion;

+ (void)updateDataWithArray:(NSArray *)array;

+ (void)syncAllDataOnGetData:(void(^)(NSArray *responseObject, NSError *error))getDataBlock
             onUploadProcess:(void(^)(NSError *error))processBlock
              onUpdateFinish:(void(^)(NSError *error))finishBlock;

+ (void)distrubuteData;
//加推荐工具后排序
+ (void)sortLocalArrayOnCompletion:(void (^)(void))completion;
//+ (void)changeToMananulCollectWithTitle:(NSString *)aTitle;
+ (void)changeWebToVCWithTitle:(NSString *)title VCName:(NSString *)vcName;
+ (void)needGetDataOnFinish:(void (^)(BOOL need))aFinishBlock;

@end
