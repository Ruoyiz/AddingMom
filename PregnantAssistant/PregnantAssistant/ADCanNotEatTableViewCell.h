//
//  ADCanNotEatTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14-9-29.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADCanNotEatTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UIImage *logo;
@property (nonatomic, retain) UIImageView *logoImgView;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, retain) UILabel  *moreLabel;
@property (nonatomic, retain) UIButton  *moreBtn;

@property (nonatomic, copy) NSString *subContent;
@property (nonatomic, assign) float height;

@property (nonatomic, retain) UIView *bottomLine;

@end
