//
//  ADLable.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLable.h"

@interface ADLable (){
    CGRect Myframe;
    UIFont *myFont;
    NSMutableParagraphStyle *paragraphstyle;
}
@end

@implementation ADLable
@synthesize verticalAlignment = verticalAlignment_;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)title textColor:(UIColor *)textColor textFont:(UIFont *)textFont lineSpace:(CGFloat)lineSpace{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphstyle setLineSpacing:lineSpace];
//        [paragraphstyle setAlignment:NSTextAlignmentCenter];
        self.attributedText = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paragraphstyle}];
        CGSize size = [title boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont parentToolTitleViewDetailHeiFontWithSize:14],NSParagraphStyleAttributeName:paragraphstyle} context:nil].size;
        self.frame =CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFont:(UIFont *)textFont lineSpace:(CGFloat)lineSpace{
    self = [super initWithFrame:frame];
    if (self) {
        Myframe = frame;
        myFont = textFont;
        self.numberOfLines = 0;
        paragraphstyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphstyle setLineSpacing:lineSpace];
        self.attributedText = [[NSAttributedString alloc] initWithString:@"label" attributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textColor, NSParagraphStyleAttributeName:paragraphstyle}];
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalAlignment)verticalAlignment{
    verticalAlignment_ = verticalAlignment;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect{
    CGRect acturlRect = [self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:acturlRect];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines{
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verticalAlignment) {
        case VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height)/2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        default:
            break;
    }
    
    return textRect;
}

- (void)setLabelText:(NSString *)LabelText{
    self.text = LabelText;
    CGSize size = [LabelText boundingRectWithSize:CGSizeMake(Myframe.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:myFont,NSParagraphStyleAttributeName:paragraphstyle} context:nil].size;
    self.frame =CGRectMake(Myframe.origin.x, Myframe.origin.y, Myframe.size.width, size.height);
}

@end
