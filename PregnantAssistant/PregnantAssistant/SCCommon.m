//
//  SCCommon.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCommon.h"
#import "SCDefines.h"
#import <QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation SCCommon


/**
 *  UIColor生成UIImage
 *
 *  @param color     生成的颜色
 *  @param imageSize 生成的图片大小
 *
 *  @return 生成后的图片
 */
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize {
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//画一条线
+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [parentLayer addSublayer:layer];
}

#pragma mark -------------save image to local---------------
//保存照片至本机
+ (void)saveImageToPhotoAlbum:(UIImage*)image {
    
//    为了能够删除
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
    //保存图片
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:ALAssetOrientationUp
                          completionBlock:^(NSURL *assetURL, NSError *error)
     {
         //read old array
         NSMutableArray *array =
         [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"ImageUrlArray"]];
         if (array == nil) {
             array = [[NSMutableArray alloc]initWithCapacity:1];
         }

         NSLog(@"assertUrl %@ err %@", assetURL, error);
         //save nsurl for next
         [array insertObject:assetURL atIndex:0];
         
         [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:array]
                                                   forKey:@"ImageUrlArray"];
     }];
}

+ (void)createAlbumInPhoneAlbum
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:@"大肚成长记"])
                {
                    haveHDRGroup = YES;
                }
            }
            
            if (!haveHDRGroup)
            {
                //do add a group named "XXXX"
                [assetsLibrary addAssetsGroupAlbumWithName:@"大肚成长记"
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     [groups addObject:group];
                     
                 }
                                              failureBlock:nil];
//                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        SCDLog(@"保存成功");
    }
}

@end
