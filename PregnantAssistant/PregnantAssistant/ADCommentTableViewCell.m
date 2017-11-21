//
//  ADCommentTableViewCell.m
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADCommentTableViewCell.h"

@implementation ADCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _userLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, self.frame.size.width -18, 30)];
        _userLabel.font = [UIFont systemFontOfSize:13];
        _userLabel.textColor = UIColorFromRGB(0x06DCBA);
        _userLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_userLabel];
        
        _commentLabel = [[UILabel alloc]init];
        //_commentLabel.font = [UIFont systemFontOfSize:15];
//        if (iPhone6Plus) {
//            _commentLabel.font = [UIFont systemFontOfSize:SummaryStoryFont_6Plus];
//        } else if (iPhone6) {
//            _commentLabel.font = [UIFont systemFontOfSize:SummaryStoryFont_6];
//        } else {
//            _commentLabel.font = [UIFont systemFontOfSize:SummaryStoryFont];
//        }
        _commentLabel.font = [UIFont momSecretCell_title_font];
        _commentLabel.numberOfLines = 10;
        _commentLabel.textColor = UIColorFromRGB(0x383245);
        _commentLabel.textAlignment = NSTextAlignmentLeft;
//        _commentLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:_commentLabel];
        
        _floorAndHourLabel = [[UILabel alloc]init];
        _floorAndHourLabel.font = [UIFont systemFontOfSize:12];
        _floorAndHourLabel.textColor = [UIColor secert_cell_lightGray];
        _floorAndHourLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_floorAndHourLabel];
        
        _likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, self.frame.size.width -54, 30)];
        _likeLabel.font = [UIFont systemFontOfSize:12];
        _likeLabel.textColor = UIColorFromRGB(0x757080);
        _likeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_likeLabel];
        
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_likeBtn];
        _bottomLine = [self getLineViewWithWidth:self.frame.size.width -20];
        [self addSubview:_bottomLine];
        
        _momLookReportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_momLookReportBtn setImage:[UIImage imageNamed:@"举报"] forState:UIControlStateNormal];
        [self addSubview:_momLookReportBtn];
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _commentLabel.frame = CGRectMake(16, 30, SCREEN_WIDTH -30, self.frame.size.height -60);
    _floorAndHourLabel.frame = CGRectMake(18, _commentLabel.frame.origin.y +_commentLabel.frame.size.height -2,
                                          self.frame.size.width -18, 30);
    
    _likeBtn.frame = CGRectMake(SCREEN_WIDTH -18 -22, self.frame.size.height -39, 40, 40);
    _likeLabel.frame = CGRectMake(_likeBtn.frame.origin.x -30 -8, 0, 40, 30);
    _likeLabel.center = CGPointMake(_likeLabel.center.x, _likeBtn.center.y);
    
    _momLookReportBtn.frame = CGRectMake(_likeLabel.frame.origin.x -11, self.frame.size.height -38, 40, 40);
    
    _bottomLine.frame = CGRectMake(10, self.frame.size.height -1, self.frame.size.width -20, 1);
}

- (UIView *)getLineViewWithWidth:(float)aWidth
{
    UIView *aLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, aWidth, 1)];
    aLineView.backgroundColor = UIColorFromRGB(0xEBEAEA);
    return aLineView;
}

- (void)setIsLike:(BOOL)isLike
{
    _isLike = isLike;
    if (isLike == YES) {
        [_likeBtn setSelected:YES];
    } else {
        [_likeBtn setSelected:NO];
    }
}

-(void)setIsHot:(BOOL)isHot
{
//    if (isHot == YES) {
//        [_likeBtn setImage:[UIImage imageNamed:@"hotGoodPressed"] forState:UIControlStateSelected];
//        [_likeBtn setImage:[UIImage imageNamed:@"hotGood"] forState:UIControlStateNormal];
//    } else {
    [_likeBtn setImage:[UIImage imageNamed:@"赞过的"] forState:UIControlStateSelected];
    [_likeBtn setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
