//
//  UIImage+ADHandleImage.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "UIImage+ADHandleImage.h"

@implementation UIImage (ADHandleImage)

- (UIImage *)scaleImagetoScale:(float)scaleSize{
    UIImage *scaleImage;
    if (nil == self) {
        scaleImage = nil;
    }else{
        UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize, self.size.height*scaleSize));
        [self drawInRect:CGRectMake(0, 0, self.size.width*scaleSize, self.size.height*scaleSize)];
        scaleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return scaleImage;
}

- (UIImage *)toSize:(CGSize)asize{
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
    }else{
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [self drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

- (UIImage *)reSizeImageToSize:(CGSize)asize{
    UIImage *newimage;
    if (nil == self) {
        newimage = nil;
    }
    else{
        CGSize oldsize = self.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [self drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;

}

- (UIImage *)getGraphicsImageWithSize:(CGSize)size appearanceImage:(UIImage *)appearanceImage appearanceImageRect:(CGRect)appearanceImageRect{

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [appearanceImage drawInRect:appearanceImageRect];
    //返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭相应的上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)getGraphicsImageWithSize:(CGSize)size appearanceText:(NSString *)appearnceText appearanceTextRect:(CGRect)appearanceTextRect withAttributes:(NSDictionary *)attributes{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    [appearnceText drawInRect:appearanceTextRect withAttributes:attributes];
    //返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭相应的上下文
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)getDrawGraphicsImageWithSize:(CGSize)size{

    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    //添加水印
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, size.width * 2/3.0, size.height - 10);
    CGContextAddLineToPoint(context,  size.width * 2/3.0 + 60, size.height - 10);
    [[UIColor redColor]setStroke];
    CGContextSetLineWidth(context, 2.0);
    CGContextDrawPath(context, kCGPathStroke);
    //返回绘制的新图形
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭相应的上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
