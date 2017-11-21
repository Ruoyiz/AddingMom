//
//  ADLabourThingTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADLabourThingTableViewCell.h"


#define LINESPACE 2

@implementation ADLabourThingTableViewCell

- (void)awakeFromNib {
    self.aRateView = [[RatingView alloc]initWithFrame:CGRectMake(80, 93, 100, 32)];
    [self.aRateView setImagesDeselected:@"星星off" partlySelected:@"" fullSelected:@"星星on" andDelegate:nil];
    
    [self addSubview:self.aRateView];
    self.aRateView.userInteractionEnabled = NO;
    
//    self.recommanLabel.textColor = [UIColor defaultTintColor];
    self.recommanLabel.textColor = [UIColor btn_green_bgColor];
    
    [self.addListBtn setImage:[UIImage imageNamed:@"待产包加入清单"]
                     forState:UIControlStateNormal];
    
    [self.addListBtn setImage:[UIImage imageNamed:@"待产清单已加入"]
                     forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setName:(NSString *)name
{
    self.nameLabel.font = [UIFont systemFontOfSize:14];
//    self.nameLabel.textColor = [UIColor defaultTintColor];
    self.nameLabel.textColor = [UIColor btn_green_bgColor];

    self.nameLabel.text = name;
}

-(void)setReason:(NSString *)reason
{
    self.resonLabel.textColor = [UIColor font_Brown];
//    self.resonLabel.textColor = [UIColor font_btn_color];
    
    self.resonLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.resonLabel.numberOfLines = 3;
    self.resonLabel.font = [UIFont systemFontOfSize:13];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:reason];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    [paragraphStyle setLineSpacing:LINESPACE];//调整行间距

    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [reason length])];
    self.resonLabel.attributedText = attributedString;

}

-(void)setNum:(NSString *)num
{
    self.numLabel.font = [UIFont systemFontOfSize:13];
//    self.numLabel.textColor = [UIColor defaultTintColor];
    self.numLabel.textColor = [UIColor btn_green_bgColor];
    self.numLabel.textAlignment = NSTextAlignmentRight;
    self.numLabel.text = num;
}

-(void)setScore:(float)score
{
    [self.aRateView displayRating:score];
}

@end
