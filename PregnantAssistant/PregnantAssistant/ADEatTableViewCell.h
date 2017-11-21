//
//  ADEatTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCustomButton.h"

@interface ADEatTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *detail;

@property (nonatomic, copy) NSString *detailStr;
@property (nonatomic, retain) ADCustomButton *customBtn;

@property (nonatomic, assign) float cellHeight;

@end
