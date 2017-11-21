//
//  ADVaccineTableViewCell.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADVaccineTableViewCell.h"
#import "ADVaccineDAO.h"

@implementation ADVaccineTableViewCell{
    UIImageView *_tagStateImageView;
    UILabel *_tagStateLabel;
    UIView *_sharpView;
    
    UIView *_circleView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);  
    
    CGFloat labelWidth = (SCREEN_WIDTH - 40 - 30 - 15*3) / 2.0;
    _nameLabel = [self createLabelWithFrame:CGRectMake(15, 10, labelWidth, 30) font:[UIFont ADTitleFontWithSize:16] textColor:[UIColor title_darkblue]];
    [self addSubview:_nameLabel];
    
    _numberOfVaccineLabel = [self createLabelWithFrame:CGRectMake(labelWidth + 30, 10, labelWidth, 30) font:[UIFont ADTitleFontWithSize:15] textColor:[UIColor title_darkblue]];
    [self addSubview:_numberOfVaccineLabel];
    
    _timeLabel = [self createLabelWithFrame:CGRectMake(15, 40, labelWidth , 30) font:[UIFont systemFontOfSize:13] textColor:[UIColor darkGrayColor]];
    [self addSubview:_timeLabel];
    
    _noteDateLabel = [self createLabelWithFrame:CGRectMake(labelWidth + 30, 40, labelWidth, 30) font:[UIFont systemFontOfSize:13] textColor:[UIColor darkGrayColor]];
    [self addSubview:_noteDateLabel];
    
    _enterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _enterImageView.image = [UIImage imageNamed:@"GO"];
    _enterImageView.center = CGPointMake(SCREEN_WIDTH - 75, 40);
    [self addSubview:_enterImageView];
    
    _sharpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6, 45)];
    _sharpView.center = CGPointMake(SCREEN_WIDTH - 55, 40);
    _sharpView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_sharpView];
   
    _tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 80)];
    _tagButton.center = CGPointMake(SCREEN_WIDTH - 30, 40);
    
    [_tagButton addTarget:self action:@selector(tagButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_tagButton];
    
    _tagStateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 56/2.5, 49/2.5)];
    _tagStateImageView.center = CGPointMake(30, 30);
    [_tagButton addSubview:_tagStateImageView];
    
    _tagStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    _tagStateLabel.center = CGPointMake(30, 52);
    _tagStateLabel.font = [UIFont ADTitleFontWithSize:9];
    _tagStateLabel.textColor = [UIColor whiteColor];
    _tagStateLabel.textAlignment = NSTextAlignmentCenter;
    [_tagButton addSubview:_tagStateLabel];
    
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    _circleView.userInteractionEnabled = NO;
    _circleView.layer.cornerRadius = 9;
    _circleView.center = CGPointMake(_tagButton.frame.size.width / 2.0, 52 - 9 - 13);
    _circleView.layer.masksToBounds = YES;
    _circleView.backgroundColor = [UIColor clearColor];
    _circleView.alpha = 0;
//    _circleView.layer.borderColor = [[UIColor redColor] CGColor];
    _circleView.layer.borderWidth = 1;
    [_tagButton addSubview:_circleView];
}

- (void)setModel:(ADVaccine *)model
{
    _model = model;
    _timeLabel.textColor = [UIColor darkGrayColor];
    NSArray *nameArray = [model.vaccineName componentsSeparatedByString:@" "];
    if(_isDetailCell){
        if(nameArray.count == 2){
            _nameLabel.text = [NSString stringWithFormat:@"%@    %@",[nameArray firstObject],[nameArray lastObject]];
        }else{
            _nameLabel.text = [nameArray firstObject];
        }
    }else{
        _nameLabel.text = [nameArray firstObject];
    }
    if (nameArray.count > 1) {
        _numberOfVaccineLabel.text = [nameArray lastObject];
    }else{
        _numberOfVaccineLabel.text = @"";
    }
    _tagStateLabel.backgroundColor = [UIColor dark_green_Btn];
    _tagStateImageView.alpha = 1;
    _circleView.alpha = 0;

    UIImage *redCircle;
    if ([_cellType isEqualToString:@"2"]){
        if ([model.isCollected isEqualToString:@"1"]) {
            
            redCircle = [UIImage imageNamed:@"OK"];
            _tagStateImageView.frame = CGRectMake(18, 22, 23, 15);
            _tagStateImageView.image = redCircle;
            _tagStateLabel.text = @"已添加";
            _tagStateLabel.backgroundColor = [UIColor lightGrayColor];

        }else{
            redCircle = [UIImage imageNamed:@"addPurple"];
            _tagStateImageView.frame = CGRectMake(18, 17, 53/2.2, 48/2.2);
            _tagStateImageView.image = redCircle;
            _tagStateLabel.text = model.vaccineTag;
            _tagStateLabel.backgroundColor = [UIColor vaccinePurpleColor];
        }
    }else{
        if ([model.haveVaccinated isEqualToString:@"0"]) {
            
            _tagStateLabel.text = _model.vaccineTag;
//            _tagStateImageView.image = [UIImage imageNamed:@"green"];
            _tagStateImageView.alpha = 0;
            _circleView.alpha = 1;
            
            if ([model.vaccineTag isEqualToString:@"必打"]) {
                _tagStateLabel.backgroundColor = [UIColor dark_green_Btn];
                _circleView.layer.borderColor = [[UIColor dark_green_Btn] CGColor];
            }else{
                _tagStateLabel.backgroundColor = [UIColor vaccinePurpleColor];
                _circleView.layer.borderColor = [[UIColor vaccinePurpleColor] CGColor];
            }
            
        }else{
            
            _tagStateImageView.image = [UIImage imageNamed:@"对勾"];
            _tagStateLabel.backgroundColor = [UIColor lightGrayColor];
            _tagStateLabel.text = @"已打";
        }
    }
    
    CGFloat labelWidth = (SCREEN_WIDTH - 40 - 30 - 15*3) / 2.0;
    _timeLabel.text = model.vaccineTime;
    _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y, labelWidth, _timeLabel.frame.size.height);
    _noteDateLabel.hidden = NO;
    
    if (![_model.vaccindateDateStamp isEqualToString:@"0"] && !_isDetailCell) {
        
        NSDate *vaccindate = [NSDate dateWithTimeIntervalSince1970:[_model.vaccindateDateStamp integerValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        _timeLabel.text = [dateFormatter stringFromDate:vaccindate];
    }
    
    
    if ([_model.vaccineOverDue integerValue] != 0 && [_model.isCollected isEqualToString:@"1"] && [_model.haveVaccinated isEqualToString:@"0"] && [_cellType isEqualToString:@"0"]) {
        NSInteger integer = [_model.vaccineOverDue integerValue];
        NSInteger days = integer % 100 + integer / 100 *30 + 1;
        
        ADAppDelegate *myApp = APP_DELEGATE;
        
        if ([_model.vaccindateDateStamp isEqualToString:@"0"]) {
            
            //未设置接种日期则按默认日期提示是否超时
            if ([myApp.babyBirthday daysBeforeDate:[NSDate date]] > days) {
                _tagStateLabel.backgroundColor = [UIColor redColor];
                _tagStateLabel.text = @"已超时";
                _tagStateImageView.alpha = 0;
                _circleView.alpha = 1;
                _timeLabel.textColor = [UIColor redColor];
                _circleView.layer.borderColor = [[UIColor redColor] CGColor];
            }
        }else{
            
            //设置过接种日期
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_model.vaccindateDateStamp integerValue]];
            NSInteger days = [date daysBeforeDate:[NSDate date]];
            if (days > 1) {
                _tagStateLabel.backgroundColor = [UIColor redColor];
                _tagStateLabel.text = @"已超时";
                _timeLabel.textColor = [UIColor redColor];
                _tagStateImageView.alpha = 0;
                _circleView.alpha = 1;
                _circleView.layer.borderColor = [[UIColor redColor] CGColor];
            }
        }
    }
    
    NSString *name = [[_model.vaccineName componentsSeparatedByString:@" "] firstObject];
    if(![name isEqualToString:@"五联疫苗"]){
        
        ADVaccine *wuLianVAccine = [ADVaccineDAO getWuLianVaccine];
        if ([ADVaccine isConflictToWuLianVaccine:name] && [wuLianVAccine.isCollected isEqualToString:@"1"]) {
            _timeLabel.text = @"已被五联疫苗覆盖";
            _timeLabel.textColor = [UIColor lightGrayColor];
            _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y, labelWidth + 100, _timeLabel.frame.size.height);
            _noteDateLabel.hidden = YES;
            if ([_cellType isEqualToString:@"0"]) {
                _circleView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            }else{
                if ([_model.isCollected isEqualToString:@"1"]) {
                    if([_model.haveVaccinated isEqualToString:@"0"])
                    _tagStateImageView.frame = CGRectMake(18, 22, 23, 15);
                    _tagStateImageView.image = [UIImage imageNamed:@"OK"];
                    _tagStateLabel.text = @"已添加";
                }else{
                    _tagStateImageView.image = [UIImage imageNamed:@"添加1"];
                    _tagStateImageView.frame = CGRectMake(19, 18, 22, 22);
                }
            }
            _tagStateLabel.backgroundColor = [UIColor lightGrayColor];
        }
    }

}

- (UILabel *)createLabelWithFrame:(CGRect)frame font:(UIFont *)font textColor:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor =  color;
    label.font = font;
    return label;
}

- (void)setCellType:(NSString *)cellType
{
    _cellType = cellType;
    
}

- (void)setIsDetailCell:(BOOL)isDetailCell
{
    _isDetailCell = isDetailCell;
    _numberOfVaccineLabel.alpha = 0;
    _noteDateLabel.alpha = 0;
    _enterImageView.alpha = 0;
    _sharpView.alpha = 0;
    _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y, SCREEN_WIDTH - 80, _nameLabel.frame.size.height);
    _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x, _timeLabel.frame.origin.y, SCREEN_WIDTH - 80, _timeLabel.frame.size.height);
}

- (void)tagButtonClicked:(UIButton *)button
{
    //NSLog(@"%@",_cellType);
    if ([_cellType isEqualToString:@"0"] || [_cellType isEqualToString:@"1"]) {
        if([_tagStateLabel.text isEqualToString:@"已打"]){
            [ADVaccineDAO modifyVaccine:_model vaccindate:@"0"];
        }else{
            [ADVaccineDAO modifyVaccine:_model vaccindate:@"1"];
            [ADVaccineDAO removeNotificationWithName:_model.vaccineName];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(didClickedTagButtonInCell:)]) {
        [self.delegate didClickedTagButtonInCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
