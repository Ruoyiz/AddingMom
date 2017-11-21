//
//  CustomStoryTableViewCell.h
//  CustomCellDemo
//
//  Created by D on 14/12/1.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRecommendTipView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CustomStoryTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *summaryStory;
@property (nonatomic, retain) UILabel *placeAndDueLabel;
@property (nonatomic, retain) UILabel *commentLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@property (nonatomic, retain) UIView *contentBg;
@property (nonatomic, retain) UIImageView *backGroundImgView;

//@property (nonatomic, retain) UIView *topLine;
//@property (nonatomic, retain) UIView *midLine;
//@property (nonatomic, retain) UIView *bottomLine;
@property (nonatomic, retain) UIView *bottomBg;
//@property (nonatomic, retain) UIView *recommandView;

@property (nonatomic, retain) UIButton *likeBtn;
@property (nonatomic, retain) UIImageView *commentImgView;

@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, assign) BOOL isComment;
@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isRecommand;
@property (nonatomic, assign) BOOL showReport;

@property (nonatomic, retain) UIButton *showReportBtn;

//@property (nonatomic, assign) BOOL havePic;

@property (nonatomic, copy) NSArray *imageUrlArray;
//@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic, retain) NSMutableArray *imageViewArray;

//@property (nonatomic, retain) ADRecommendTipView *recommandView;
@property (nonatomic, retain) UIImageView *recommandView;

@property (nonatomic, retain) UIViewController *parentVC;

@property (nonatomic, assign) BOOL passThoughTouch;

@property (nonatomic, assign) BOOL showDelBtn;

@property (nonatomic, retain) UIButton *delBtn;

@end
