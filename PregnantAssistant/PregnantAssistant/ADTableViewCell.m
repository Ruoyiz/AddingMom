//
//  ADTableViewCell.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADTableViewCell.h"

@implementation ADTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTextFiele:(BOOL)istextField{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (istextField) {
            _cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 14, 44)];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 44)];
            _cellTextField.leftViewMode = UITextFieldViewModeAlways;
            _cellTextField.leftView = leftView;
            _cellTextField.font = [UIFont systemFontOfSize:14];
            [self addSubview:_cellTextField];
        }else{
            _myTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH, 44)];
            _myTitleLable.textAlignment = NSTextAlignmentLeft;
            _myTitleLable.font = [UIFont systemFontOfSize:14];
            [self addSubview:_myTitleLable];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
