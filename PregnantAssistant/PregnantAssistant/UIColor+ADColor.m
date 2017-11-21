//
//  UIColor+ADColor.m
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "UIColor+ADColor.h"

@implementation UIColor (ADColor)

+ (UIColor *)defaultTintColor
{
    return UIColorFromRGB(0xFF536E);
}

+ (UIColor *)emptyViewTextColor
{
    return UIColorFromRGB(0x737373);
}

+ (UIColor *)emptyGreenColor
{
    return [self btn_green_bgColor];
}

+ (UIColor *)base_BackgroundColor
{
//    return [UIColor colorWithRed:0.937 green:0.937 blue:0.937 alpha:1.0];
    return [UIColor whiteColor];
}

+ (UIColor *)font_Brown
{
    return [UIColor colorWithRed:0.506 green:0.467 blue:0.435 alpha:1.0];
}

+ (UIColor *)font_LightBrown
{
    return [UIColor colorWithRed:0.804 green:0.741 blue:0.686 alpha:1.0];
}

+ (UIColor *)font_Orange
{
    return UIColorFromRGB(0x8F847B);
}

+ (UIColor *)font_Title
{
    return [UIColor colorWithRed:143/255.0 green:132/255.0 blue:123/255.0 alpha:1.0];
}

+ (UIColor *)bg_brown
{
    return [UIColor colorWithRed:0.937 green:0.894 blue:0.890 alpha:1.0];
}

+ (UIColor *)bg_brown_alpha
{
    return [UIColor colorWithRed:0.506 green:0.467 blue:0.435 alpha:0.9];
}

+ (UIColor *)bg_lightYellow
{
//    return [UIColor colorWithRed:0.984 green:0.969 blue:0.945 alpha:1.0];
    return UIColorFromRGB(0xF2EBE3);
}

+ (UIColor *)bg_Tip_brown
{
    return [UIColor colorWithRed:0.600 green:0.565 blue:0.529 alpha:0.8];
}

+ (UIColor *)bg_Paper_forground
{
    return [UIColor colorWithRed:0.957 green:0.957 blue:0.957 alpha:1.0];
}

+ (UIColor *)bg_Paper_background
{
    return [UIColor colorWithRed:0.937 green:0.902 blue:0.851 alpha:1.0];
}

+ (UIColor *)darkTintColor
{
   return [UIColor colorWithRed:0.969 green:0.243 blue:0.380 alpha:1.0];
}

+ (UIColor *)font_IconGray
{
    return UIColorFromRGB(0x635D59);
}

+ (UIColor *)separator_line_color
{
    return [UIColor colorWithRed:178/255.0 green:168/255.0 blue:161/255.0 alpha:0.4];
}

+ (UIColor *)font_tip_color
{
    return UIColorFromRGB(0x86828f);
}

+ (UIColor *)separator_gray_line_color
{
    return UIColorFromRGB(0xcccccc);
}

+ (UIColor *)font_btn_color
{
    return UIColorFromRGB(0x352f44);
}

+ (UIColor *)toast_collect_bgcolor
{
    return UIColorFromRGBAndAlpha(0x4d4587, 0.9);
}

+ (UIColor *)btn_green_bgColor
{
    return UIColorFromRGB(0x27c3b0);
}

+ (UIColor *)title_darkblue
{
    return UIColorFromRGB(0x4d4587);
}

+ (UIColor *)dirty_yellow
{
    return UIColorFromRGB(0xF2EBE3);
}

+ (UIColor *)secert_cell_lightGray
{
    return UIColorFromRGB(0xDFDDE1);
}

+ (UIColor *)dark_green_Btn
{
    return [self btn_green_bgColor];
}

+ (UIColor *)light_green_Btn
{
    return UIColorFromRGB(0x00dcb9);
}

+ (UIColor *)dot_green
{
    return UIColorFromRGB(0x04DFBE);
}

+ (UIColor *)thumb_img_bgColor
{
    return UIColorFromRGB(0xf2ece4);
}

+ (UIColor *)cell_subTitle_color
{
    return UIColorFromRGB(0xbebac3);
}

+ (UIColor *)buttonSelectedGreenColor
{
    return UIColorFromRGB(0x00DBB8);
}

//高亮的tag色值
+ (UIColor *)tagGreenColor
{
    return [self btn_green_bgColor];
}

+ (UIColor *)tagRedColor
{
    return UIColorFromRGB(0xff6c81);
}

//家丁妈妈声明色值
+ (UIColor *)statementTextGrayColor
{
    return UIColorFromRGB(0x352f44);
}

+ (UIColor *)backColor
{
    return [UIColor colorWithRed:239/255.0 green:230/255.0 blue:220/255.0 alpha:1];
}

+ (UIColor *)versionTextColor
{
    return UIColorFromRGB(0x85818e);
}

+ (UIColor *)commentGrayColor
{
    return UIColorFromRGB(0x737373);
}

+ (UIColor *)vaccinePurpleColor
{
    return [UIColor colorWithRed:169/255.0 green:146/255.0 blue:254/255.0 alpha:1];
}

+ (UIColor *)cell_placeHolder_image_color
{
    return UIColorFromRGB(0xDFDFDF);
}

+ (UIColor *)cell_title_Color
{
    return UIColorFromRGB(0x333333);
}

+ (UIColor *)cell_content_Color
{
    return UIColorFromRGB(0x444444);
}

+ (UIColor *)title_unSelect_Color
{
    return UIColorFromRGB(0x666666);
}

+ (UIColor *)title_black_color
{
    return UIColorFromRGB(0x333333);
}

+ (UIColor *)unselect_title_color
{
    return UIColorFromRGB(0xCCCCCC);
}

+ (UIColor *)select_title_color
{
    return UIColorFromRGB(0xFF8080);
}

+ (UIColor *)unEnable_btn_color
{
    return UIColorFromRGB(0x737373);
}

+ (UIColor *)red_Dot_color
{
    return UIColorFromRGB(0xf23739);
}

+ (UIColor *)momLookCell_subTxtColor
{
    return UIColorFromRGB(0x737373);
}

+ (UIColor *)cellSharpBackColor
{
    return [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
}

@end
