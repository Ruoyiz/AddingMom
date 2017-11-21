//
//  ADLookCommentTableViewCell.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/7.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLookCommentTableViewCell.h"
#import "ADGetTextSize.h"
#import "ADUserInfoSaveHelper.h"
#import "UIImageView+WebCache.h"

#define userNameWidth 220
#define commentContentWidth SCREEN_WIDTH - 30 - 40
#define timeWidth 150

#define userNameFont [UIFont ADTraditionalFontWithSize:13]
#define contentFont [UIFont ADTraditionalFontWithSize:13]

@implementation ADLookCommentTableViewCell{
    UIView *_sharpLineView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        [self loadUI];
    }
    
    return self;
}

- (void)loadUI
{
    CGFloat posY = 15;
    CGFloat posX = 15 + 34 + 8;
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, posY, 34, 34)];
    _iconImageView.layer.cornerRadius = 17;
    _iconImageView.layer.masksToBounds = YES;
    [self addSubview:_iconImageView];
    
    _moreOperateButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 45, posY - 10, 50, 50)];
    [_moreOperateButton addTarget:self action:@selector(priseComment:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreOperateButton];
    
    [self setupMoreOperateView];
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, userNameWidth, 20)];
    _userNameLabel.font = userNameFont;
    [self addSubview:_userNameLabel];
    
    posY += 22;
    
    _clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(posX + 2, posY + 2, 8, 8)];
    _clockImageView.image = [UIImage imageNamed:@"clock-circular-outline"];
    [self addSubview:_clockImageView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX + 15, posY, timeWidth, 20)];
    _timeLabel.textColor = [UIColor commentGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_timeLabel];
    
    posY += 20;
    
    _commentContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(posX, posY, commentContentWidth, 20)];
    _commentContentLabel.numberOfLines = 0;
    _commentContentLabel.font = contentFont;
    _commentContentLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_commentContentLabel];
    
    
    _sharpLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 0.6)];
    _sharpLineView.backgroundColor = [UIColor separator_line_color];
    [self addSubview:_sharpLineView];
}

- (void)setupMoreOperateView
{
    _priseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_moreOperateButton.frame.size.width - 25, 5, 14*1.3, 11*1.3)];
    _priseImageView.center = CGPointMake(_moreOperateButton.frame.size.width / 2.0, _moreOperateButton.frame.size.height / 2.0);
    _priseImageView.image = [UIImage imageNamed:@"赞"];
    [_moreOperateButton addSubview:_priseImageView];
    
    _priseCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_moreOperateButton.frame.origin.x - 20, _moreOperateButton.frame.origin.y, 30, _moreOperateButton.frame.size.height)];
//    _priseCountLabel.text = @"333";
    _priseCountLabel.textColor = [UIColor lightGrayColor];
    _priseCountLabel.font = [UIFont systemFontOfSize:14];
    _priseCountLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priseCountLabel];
    [self bringSubviewToFront:_moreOperateButton];

}

- (void)setModel:(ADMomLookCommentModel *)commentModel
{
    _model = commentModel;
    
    //NSLog(@"图片 %@",_model.face);
    if ([_model.face isEqual:[NSNull null]] || _model.face == nil || _model.face.length == 0) {
        _iconImageView.image = [UIImage imageNamed:@"无头像"];
    }else{
        //NSLog(@"使用网络图片");
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_model.face] placeholderImage:nil];
    }
    CGFloat posY = 15;
    NSDictionary *greenColor = @{NSForegroundColorAttributeName:[UIColor btn_green_bgColor]};
    NSDictionary *grayColor = @{NSForegroundColorAttributeName:[UIColor commentGrayColor]};
    if ([commentModel.replyName isEqual:[NSNull null]] || commentModel.replyName.length == 0) {
        NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:commentModel.commentName attributes:greenColor];
        _userNameLabel.attributedText = aAttributedString;
        
    }else{
        NSString *aString = [NSString stringWithFormat:@"%@ 回复 %@",commentModel.commentName,commentModel.replyName];
        NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        [aAttributedString setAttributes:greenColor range:[aString rangeOfString:commentModel.commentName]];
        [aAttributedString setAttributes:grayColor range:[aString rangeOfString:@"回复"]];
        [aAttributedString setAttributes:greenColor range:[aString rangeOfString:commentModel.replyName]];
        _userNameLabel.attributedText = aAttributedString;
    }
    
    CGFloat userNameHeight = 18;//[ADGetTextSize heighForString:_userNameLabel.text width:_userNameLabel.frame.size.width andFont:_userNameLabel.font];
    _userNameLabel.frame = CGRectMake(_userNameLabel.frame.origin.x, posY, userNameWidth, userNameHeight);
    _userNameLabel.textColor = [UIColor blackColor];
//    _moreOperateButton.frame = CGRectMake(_moreOperateButton.frame.origin.x, posY, _moreOperateButton.frame.size.width, 18);
    posY += userNameHeight;
    
    _timeLabel.text = commentModel.createTime;
    _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x, posY, timeWidth, 20);
    posY += 30;

    _commentContentLabel.text = commentModel.commentBody;
    
    CGFloat commentContentHeight = [ADGetTextSize heighForString:_commentContentLabel.text width:_commentContentLabel.frame.size.width andFont:_commentContentLabel.font];
    _commentContentLabel.frame = CGRectMake(_commentContentLabel.frame.origin.x, posY, commentContentWidth, commentContentHeight);
    posY += commentContentHeight + 20;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, posY);
    
    _moreOperateButton.selected = commentModel.isPraise;
    if (_moreOperateButton.selected) {
        _priseImageView.image = [UIImage imageNamed:@"赞过的"];
    }else{
        _priseImageView.image = [UIImage imageNamed:@"赞"];
    }
    
    _sharpLineView.frame = CGRectMake(15, posY - 1, SCREEN_WIDTH - 30, 1);
//    _linkButton.selected = commentModel.isPraise;
//    _commentButton.selected = commentModel.isComment;
    
    NSString *countStr = [NSString stringWithFormat:@"%@",commentModel.praiseCount];
    NSInteger priseCount = [countStr integerValue];

    _priseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)priseCount];
//    [_linkButton setTitle:countStr forState:UIControlStateNormal];
//    [_commentButton setTitle:[NSString stringWithFormat:@" %@",commentModel.replyCount] forState:UIControlStateNormal];
}

+ (CGFloat)cellHeightFromModel:(ADMomLookCommentModel *)model
{
    CGFloat posY = 15;
    CGFloat userNameHeight = 18;//[ADGetTextSize heighForString:_userNameLabel.text width:_userNameLabel.frame.size.width andFont:_userNameLabel.font];
    posY += userNameHeight;
    posY += 30;
    
    CGFloat commentContentHeight = [ADGetTextSize heighForString:model.commentBody width:commentContentWidth andFont:contentFont];

    posY += commentContentHeight + 20;

    
    return posY;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 更多操作
- (void)priseComment:(UIButton *)button
{
    if ([self.commentDelegate respondsToSelector:@selector(commentCell:clickedPraiseButton:)]) {
        [self.commentDelegate commentCell:self clickedPraiseButton:button];
    }
}

@end
