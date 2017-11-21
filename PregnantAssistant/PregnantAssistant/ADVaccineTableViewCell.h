//
//  ADVaccineTableViewCell.h
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/4.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ADVaccineModel.h"
#import "ADVaccine.h"

@class ADVaccineTableViewCell;

@protocol VaccineCellDelegate <NSObject>

- (void)didClickedTagButtonInCell:(ADVaccineTableViewCell *)cell;

@end

@interface ADVaccineTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *numberOfVaccineLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *noteDateLabel;

@property (nonatomic,strong) UIImageView *enterImageView;

@property (nonatomic,strong) UIButton *tagButton;

@property (nonatomic,strong) ADVaccine *model;

//@property (nonatomic,assign) BOOL isDetail;
@property (nonatomic,assign) BOOL isDetailCell;

@property (nonatomic,strong) NSString *cellType;

@property (nonatomic,assign) id <VaccineCellDelegate> delegate;

@end
