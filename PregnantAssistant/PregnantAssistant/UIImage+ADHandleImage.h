//
//  UIImage+ADHandleImage.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADHandleImage)
//等比率缩放
- (UIImage *)scaleImagetoScale:(float)scaleSize;

//生成新的宽高图片
- (UIImage *)toSize:(CGSize)asize;

//保证原来的长宽比 ，生成适合新的size的image
- (UIImage *)reSizeImageToSize:(CGSize)asize;


/*
 size: 图片编辑的大小
 appearanceImage: 绘制到原图上面的图片
 appearanceImageRect: 上面图片的位置
 */
- (UIImage *)getGraphicsImageWithSize:(CGSize)size appearanceImage:(UIImage *)appearanceImage appearanceImageRect:(CGRect)appearanceImageRect;

/*
 size: 图片编辑的大小
 appearnceText: 绘制到原图上面的文字
 appearanceTextRect: 上面文字的位置
 attributes: 文字的属性
 */
- (UIImage *)getGraphicsImageWithSize:(CGSize)size appearanceText:(NSString *)appearnceText appearanceTextRect:(CGRect)appearanceTextRect withAttributes:(NSDictionary *)attributes;
/*
 添加水印等绘图
 这里只是添加的一个红色水印，以后依情况而定
 */
- (UIImage *)getDrawGraphicsImageWithSize:(CGSize)size;

@end
