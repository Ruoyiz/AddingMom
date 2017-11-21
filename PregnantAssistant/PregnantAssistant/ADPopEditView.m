//
//  ADPopEditView.m
//  PregnantAssistant
//
//  Created by D on 15/3/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADPopEditView.h"

@implementation ADPopEditView

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVC
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentVc = aVC;
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];
    //toolBar
    UIView * sortBar = [[[NSBundle mainBundle] loadNibNamed:@"ADToolSortBar" owner:self options:nil]lastObject];
    sortBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    [self addSubview:sortBar];
    _sortTitle.textColor = UIColorFromRGB(0x3E3467);
    
    //uitableview
    _sortTableView = [[UITableView alloc]initWithFrame:
                      CGRectMake(0, sortBar.frame.size.height, SCREEN_WIDTH, self.frame.size.height -50)];
    _sortTableView.backgroundColor = [UIColor dirty_yellow];
    _sortTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_sortTableView];
}

- (IBAction)rightBtnClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:finishSortToolNotification object:nil];
}

@end
