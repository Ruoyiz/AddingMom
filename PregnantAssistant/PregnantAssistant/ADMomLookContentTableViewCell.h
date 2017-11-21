//
//  ADMomLookContentTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 15/3/2.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADMomContentInfo.h"
#import "ADMomLookSaveContent.h"
//#import "ASUILabel.h"

typedef enum {
    cellLabelNoneType = -1,
    cellLabelNewType = 0,
    cellLabelAdType = 1
} momLookCellLabelType;

@interface ADMomLookContentTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subTitleLabel;
@property (nonatomic, retain) UILabel *publishTimeLabel;
@property (nonatomic,assign) BOOL fromSearch;
@property (nonatomic, retain) UIImageView *thumbImgView;
@property (nonatomic, retain) UIImageView *palceImgView;

//@property (nonatomic, retain) UIImageView *tipImageView;
//@property (nonatomic, retain) UIImageView *adImageView;

//@property (nonatomic, retain) UIImageView *playImgView;
//@property (nonatomic, retain) UILabel *timeLabel;
@property (nonatomic, assign) momLookCellLabelType aMomLookCellLabelType;
//@property (nonatomic, strong)UILabel *seperatorLine;
@property (nonatomic, assign) BOOL showTimeLabel;
@property (nonatomic, assign) BOOL showAdView;
//@property (nonatomic, retain) UIImageView *placeImgView;

@property (nonatomic, retain) ADMomContentInfo *aMomLookInfo;
@property (nonatomic, retain) ADMomLookSaveContent *aSaveContent;
//文章标签
@property (nonatomic,strong) NSString *tagLabelStr;

//文章出处icon
@property (nonatomic,strong) UIImageView *articleIconImageView;

//阅读总数
@property (nonatomic,strong) UILabel *readAmountLabel;

@property (nonatomic,strong) UIView *sepLineView;

@end
