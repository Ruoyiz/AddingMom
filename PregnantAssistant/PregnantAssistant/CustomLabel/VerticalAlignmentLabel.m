//
//  VerticalAlignmentLabel.m
//  TonyRun
//
//  Created by yitu on 14-11-25.
//  Copyright (c) 2014年 addinghome. All rights reserved.
//

#import "VerticalAlignmentLabel.h"

@implementation VerticalAlignmentLabel

@synthesize verticalAlignment=_verticalAlignment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalAlignment=VerticalAlignmentTop;
    }
    return self;
}

//- (void)setText:(NSString *)text
//{
//    CGSize size = [text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
//    CGAffineTransform transform = self.transform;
//    self.transform = CGAffineTransformIdentity;
//    CGRect frame = self.frame;
//    frame.size.height = size.height;
//    self.frame = frame;
//    self.transform = transform;
//    
//    [super setText:text];
//}
//
-(void)setVerticalAlignment:(VerticalAlignment)verticalAlignment
{
    _verticalAlignment=verticalAlignment;
    [self setNeedsDisplay];//重绘一下
}

-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    CGRect textRect=[super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch(self.verticalAlignment)
    {
        case VerticalAlignmentTop:
            textRect.origin.y=bounds.origin.y;
            break;
        case VerticalAlignmentMiddle:
            textRect.origin.y=bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
        case VerticalAlignmentBottom:
            textRect.origin.y=bounds.origin.y+bounds.size.height-textRect.size.height;
            break;
        default:
            textRect.origin.y=bounds.origin.y+(bounds.size.height-textRect.size.height)/2.0;
            break;
    }
    return textRect;
}
-(void)drawTextInRect:(CGRect)rect
{
    CGRect actualRect=[self textRectForBounds:rect limitedToNumberOfLines:self.numberOfLines];//重新计算位置
    [super drawTextInRect:actualRect];
}

@end