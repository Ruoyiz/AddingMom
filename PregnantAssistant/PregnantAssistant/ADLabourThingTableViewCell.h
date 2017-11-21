//
//  ADLabourThingTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14-9-18.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface ADLabourThingTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *resonLabel;
@property (nonatomic, retain) IBOutlet UILabel *numLabel;

@property (nonatomic, retain) IBOutlet UILabel *recommanLabel;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, assign) float score;
@property (nonatomic, copy) NSString *num;

@property (nonatomic, retain) RatingView *aRateView;
@property (weak, nonatomic) IBOutlet UIButton *addListBtn;

@end
