//
//  UIFont+ADFont.h
//  PregnantAssistant
//
//  Created by D on 14-10-8.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ADFont)

+ (UIFont *)title_font;
+ (UIFont *)btn_title_font;

+ (UIFont *)tip_font;
+ (UIFont *)body_font;

+ (UIFont *)momLookCell_title_font;
+ (UIFont *)momLookCell_subTitle_font;
+ (UIFont *)FZLTWithSize:(CGFloat)size;

+ (UIFont *)momSecretCell_title_font;

+ (UIFont *)momLookCell_text_font;

+ (UIFont *)ADTitleFontWithSize:(CGFloat)size;

+ (UIFont *)ADTraditionalFontWithSize:(CGFloat)size;

+ (UIFont *)parentToolTitleViewDetailFontWithSize:(CGFloat)size;
+ (UIFont *)parentToolTitleViewDetailHeiFontWithSize:(CGFloat)size;

+ (UIFont *)ADBlackTitleFont;
@end
