//
//  ADTableViewCell.h
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/9.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *cellTextField;
@property (nonatomic, strong) UILabel *myTitleLable;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isTextFiele:(BOOL)istextField;
@end
