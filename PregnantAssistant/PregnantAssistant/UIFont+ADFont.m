//
//  UIFont+ADFont.m
//  PregnantAssistant
//
//  Created by D on 14-10-8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "UIFont+ADFont.h"

@implementation UIFont (ADFont)

+ (UIFont *)tip_font
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)btn_title_font
{
    return  [UIFont systemFontOfSize:17];
}

+ (UIFont *)title_font
{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)body_font
{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)FZLTWithSize:(CGFloat)size
{
    return [UIFont fontWithName:FZLanTingHei_L_GBk size:size];
}

+ (UIFont *)momLookCell_title_font
{
    if (iPhone6 || iPhone6Plus) {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellTitlefontSize_6];
    } else {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellTitlefontSize_5];
    }
}

+ (UIFont *)momLookCell_text_font
{
    if (iPhone6 || iPhone6Plus) {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellTextfontSize_6];
    } else {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellTextfontSize_5];
    }
}

+ (UIFont *)momLookCell_subTitle_font
{
    if (iPhone6 || iPhone6Plus) {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellSubTitlefontSize_6];
    } else {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellSubTitlefontSize_5];
    }
}

+ (UIFont *)momSecretCell_title_font
{
    if (iPhone6) {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:SummaryStoryFont_6];
    }else if (iPhone6Plus){
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:SummaryStoryFont_6Plus];
    }else {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:SummaryStoryFont];
    }
}

+ (UIFont *)momSecretCell_subTitle_font
{
    if (iPhone6 || iPhone6Plus) {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellSubTitlefontSize_6];
    } else {
        return [UIFont fontWithName:FZLanTingHei_L_GBk size:CellSubTitlefontSize_5];
    }
}

+ (UIFont *)ADTitleFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:RTWSYueGoTrial_Light size:size];
}

+ (UIFont *)ADTraditionalFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:FZLanTingHei_L_GBk size:size];
}

+ (UIFont *)parentToolTitleViewDetailFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:RTWSYueGoTrial_Light size:size];
}

+ (UIFont *)parentToolTitleViewDetailHeiFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:FZLanTingHei_L_GBk size:size];
}

+ (UIFont *)ADBlackTitleFont
{
    return [UIFont fontWithName:FZLanTingHei_L_GBk size:15];
}

@end
