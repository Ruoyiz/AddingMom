//
//  ADContractionTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14/10/20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADContractionTableViewCell.h"

@implementation ADContractionTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subview in self.subviews) {
        
        //8
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
            //your color
            ((UIView*)[subview.subviews firstObject]).backgroundColor=[UIColor darkTintColor];
            break;
        }
        // 7
        for(UIView *subview2 in subview.subviews){
            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
                //your color
                ((UIView*)[subview2.subviews firstObject]).backgroundColor=[UIColor darkTintColor];
                break;
            }
        }
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 130, 16)];
        _startTimeLabel.textAlignment = NSTextAlignmentLeft;
        _startTimeLabel.textColor = [UIColor defaultTintColor];
        _startTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        
        [self.contentView addSubview:self.startTimeLabel];
        
        _lastTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 32, SCREEN_WIDTH, 14)];
        _lastTimeLabel.textAlignment = NSTextAlignmentLeft;
        _lastTimeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        _lastTimeLabel.textColor = [UIColor defaultTintColor];
        [self.contentView addSubview:self.lastTimeLabel];
        
        UIView *point1 = [self getCirclePointWithColor:[UIColor defaultTintColor]];
        point1.center = CGPointMake(17, self.lastTimeLabel.center.y);
        [self.contentView addSubview:point1];
        
        _intervalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH -10, 16)];
        _intervalLabel.textAlignment = NSTextAlignmentRight;
        _intervalLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        _intervalLabel.textColor = [UIColor defaultTintColor];
        [self addSubview:self.intervalLabel];
        
        _point2 = [self getCirclePointWithColor:
                          [UIColor colorWithRed:1.000 green:0.733 blue:0.165 alpha:1.0]];
        _point2.center = CGPointMake(SCREEN_WIDTH -136, self.intervalLabel.center.y);
        [self addSubview:_point2];
    }
    return self;
}

- (UIView *)getCirclePointWithColor:(UIColor *)aColor
{
    UIView *aPoint = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
    aPoint.backgroundColor = aColor;
    [aPoint setClipsToBounds:YES];
    [aPoint.layer setCornerRadius:4];

    return aPoint;
}
@end
