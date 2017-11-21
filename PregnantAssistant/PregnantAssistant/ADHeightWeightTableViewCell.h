//
//  ADHeightWeightTableViewCell.h
//  WeightDemo
//
//  Created by 加丁 on 15/5/27.
//  Copyright (c) 2015年 加丁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWeightHeightModel.h"
@interface ADHeightWeightTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *addHeightLabel;
@property (strong, nonatomic) UILabel *addWidthLabel;
@property (strong, nonatomic) UIButton *imageButton;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) ADWeightHeightModel *refreshModel;
@property (strong, nonatomic)ADWeightHeightModel *heightRefreshModel;

@end
