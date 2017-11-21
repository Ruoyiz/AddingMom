//
//  ADImageUploader.m
//  PregnantAssistant
//
//  Created by D on 15/5/5.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADImageUploader.h"
#import "UMUUploaderManager.h"
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"

@implementation ADImageUploader

+ (void)uploadWithImage:(UIImage *)uploadImg
                 toPath:(NSString *)aPath
          progressBlock:(void (^)(CGFloat percent,
                                  long long requestDidSendBytes))progressBlock
          completeBlock:(void (^)(NSError *error,
                                  NSDictionary *result,
                                  NSString *imgUrl,
                                  BOOL completed))completeBlock
{
    NSData *fileData = UIImagePNGRepresentation(uploadImg);
    NSLog(@"img h:%f w:%f", uploadImg.size.height, uploadImg.size.width);
    NSDictionary * fileInfo = [UMUUploaderManager fetchFileInfoDictionaryWith:fileData];//获取文件信息
    
    NSDictionary * signaturePolicyDic = [self constructingSignatureAndPolicyWithFileInfo:fileInfo
                                                                              andImgPath:aPath];
    
    NSString *signature = signaturePolicyDic[@"signature"];
    NSString *policy = signaturePolicyDic[@"policy"];
    NSString *bucket = signaturePolicyDic[@"bucket"];
    
    UMUUploaderManager * manager = [UMUUploaderManager managerWithBucket:bucket];
    
//    if (fileData == nil) {
//        return;
//    }
    [manager uploadWithFile:fileData
                     policy:policy
                  signature:signature
              progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                  NSLog(@"%f",percent);
                  if (progressBlock) {
                      progressBlock(percent, requestDidSendBytes);
                  }
              }completeBlock:^(NSError *error, NSDictionary *result, BOOL completed) {
                  NSString *imgUrl = [NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@",aPath];
                  if (completeBlock) {
                      completeBlock(error, result, imgUrl, completed);
                  }
              }];
}

//上传多张图片
+ (void)uploadImagesWithArary:(NSArray *)uploadImgArray
                       toPath:(NSArray *)paths
                progressBlock:(void (^)(CGFloat percent,
                                        long long requestDidSendBytes))progressBlock
                completeBlock:(void (^)())completeBlock
{
    __block int finishUploadCnt = 0;
    for (int i = 0; i < uploadImgArray.count; i++) {
        UIImage *aImg = uploadImgArray[i];
        NSString *aPath = paths[i];
        [self uploadWithImage:aImg
                       toPath:aPath
                progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
            
        } completeBlock:^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
            if (completed) {
                finishUploadCnt++;
                //传完最后1张
                if (finishUploadCnt == uploadImgArray.count -1) {
                    if (completeBlock) {
                        completeBlock();
                    }
                }
            }
        }];
    }
}

+ (void)uploadWithImages:(NSArray *)uploadImgArray
                  toPath:(NSString *)aPath
           progressBlock:(void (^)(CGFloat percent,
                                   long long requestDidSendBytes))progressBlock
           completeBlock:(void (^)(NSError *error,
                                   NSDictionary *result,
                                   NSString *imgUrl,
                                   BOOL completed))completeBlock
{
//    dispatch_queue_t queue = dispatch_get_global_queue(0,0);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group,queue,^{
//        NSLog(@"Block 1");
//        //run first NSOperation here
//    });
//    
//    dispatch_group_async(group,queue,^{
//        NSLog(@"Block 2");
//        //run second NSOperation here
//    });
//    
//    //or from for loop
//    for (NSOperation *operation in operations)
//    {
//        dispatch_group_async(group,queue,^{
//            [operation start];
//        });
//    }
//    
//    dispatch_group_notify(group,queue,^{
//        NSLog(@"Final block");
//        //hide progress indicator here
//    });
//    
}

/**
 *  根据文件信息生成Signature\Policy\bucket (安全起见，以下算法应在服务端完成)
 *
 *  @param paramaters 文件信息
 *
 *  @return
 */
+ (NSDictionary *)constructingSignatureAndPolicyWithFileInfo:(NSDictionary *)fileInfo
                                                  andImgPath:(NSString *)imgPath
{
    NSString * bucket = @"addinghome";
    NSString * secret = @"0aojnOI2dfZH7KT651pzsXe2hX8=";
    
    NSMutableDictionary * mutableDic = [[NSMutableDictionary alloc]initWithDictionary:fileInfo];
    [mutableDic setObject:@(ceil([[NSDate date] timeIntervalSince1970])+60) forKey:@"expiration"];//设置授权过期时间
    [mutableDic setObject:imgPath forKey:@"path"];//设置保存路径
    
    //    NSLog(@"_imageArray:%@ path:%@", _imgUrlArray.class, imgPath);
    //    [_imgUrlArray addObject:[NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@", imgPath]];
    
    //    NSLog(@"_imageArray:%@", _imgUrlArray);
    /**
     *  这个 mutableDic 可以塞入其他可选参数 见：http://docs.upyun.com/api/form_api/#Policy%e5%86%85%e5%ae%b9%e8%af%a6%e8%a7%a3
     */
    NSString * signature = @"";
    NSArray * keys = [mutableDic allKeys];
    keys= [keys sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutableDic[key];
        signature = [NSString stringWithFormat:@"%@%@%@",signature,key,value];
    }
    signature = [signature stringByAppendingString:secret];
    
    return @{@"signature":[signature MD5],
             @"policy":[self dictionaryToJSONStringBase64Encoding:mutableDic],
             @"bucket":bucket};
}

+ (NSString *)dictionaryToJSONStringBase64Encoding:(NSDictionary *)dic
{
    id paramesData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:paramesData
                                                 encoding:NSUTF8StringEncoding];
    return [jsonString base64encode];
}

#pragma mark - generate img name method
+ (NSString *)generateImageName
{
    NSMutableString *imgName = [[NSMutableString alloc]initWithCapacity:0];
    NSDate *now = [NSDate date];
    [imgName appendString:[now stringWithFormat:@"yyyyMMdd"]];
    NSArray *orginArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                            @"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"g",
                            @"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",
                            @"u",@"v",@"w",@"x",@"y",@"z"];
    for (int i = 0; i < 9; i++) {
        int index = random() %36;
        [imgName appendString:orginArray[index]];
    }
    
    NSLog(@"imgName:%@", imgName);
    return imgName;
}

@end
