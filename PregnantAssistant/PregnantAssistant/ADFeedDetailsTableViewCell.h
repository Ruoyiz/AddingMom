//
//  ADFeedDetailsTableViewCell.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADFeedDetailModel.h"

@interface ADFeedDetailsTableViewCell : UITableViewCell

@property (strong, nonatomic) ADFeedDetailModel *refreshModel;
+ (CGFloat)getCellHeightWithModel:(ADFeedDetailModel *)model;

@end
