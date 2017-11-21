//
//  ADConfineTableViewCell.h
//  PregnantAssistant
//
//  Created by D on 14-9-26.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADConfineTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *name;
@property (nonatomic, retain) UILabel *detail;
@property (nonatomic, copy) NSString *detailStr;
@property (nonatomic, assign) float detailHeight;
@end
