//
//  ADFeedRecommendTableViewCell.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/6/24.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADFeedContentListModel.h"

@class ADFeedRecommendTableViewCell;

@protocol ADFeedContentCellDelegate <NSObject>

- (void)tableViewCell:(ADFeedRecommendTableViewCell *)cell didClickedRssButton:(UIButton *)button;

@end

@interface ADFeedRecommendTableViewCell : UITableViewCell

@property (nonatomic,assign) id <ADFeedContentCellDelegate> delegate;
@property (nonatomic, strong) ADFeedContentListModel *refreshModel;
+ (CGFloat)getFeedRecommendWithModel:(ADFeedContentListModel *)model;
@end
