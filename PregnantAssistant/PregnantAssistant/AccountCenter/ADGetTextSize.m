//
//  ADGetTextSize.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/14.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADGetTextSize.h"
#import <CoreText/CoreText.h>

@implementation ADGetTextSize

+ (CGFloat)heighForString:(NSString *)text width:(CGFloat)width andFont:(UIFont *)font{
    
    //获得系统版本号
    CGFloat sysVer=[[[UIDevice currentDevice]systemVersion]floatValue];
    CGFloat heigh = 0.0;
    
    if (sysVer >= 7.0) {
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        heigh=[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:NULL].size.height;
    }else{
        //heigh=[text sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    }
    return heigh ;
}

+ (CGFloat)heightForString:(NSString *)text width:(CGFloat)width attributes:(NSDictionary *)attributes
{
    CGFloat heigh = 0.0;
    heigh=[text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:NULL].size.height;
    
    return heigh ;

}

+ (CGFloat)widthForString:(NSString*)text height:(CGFloat)height andFont:(UIFont *)font{
    //获得系统版本号
    CGFloat sysVer=[[[UIDevice currentDevice]systemVersion]floatValue];
    CGFloat wid=0.0;

    if (sysVer>=7.0) {
        NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        wid=[text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dict context:NULL].size.width;
    }else{
        //wid=[text sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:CGSizeMake(CGFLOAT_MAX, height) lineBreakMode:NSLineBreakByCharWrapping].width;
    }
    return wid ;
}

- (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}

@end
