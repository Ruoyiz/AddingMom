//
//  ADPopEditView.h
//  PregnantAssistant
//
//  Created by D on 15/3/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ADPopEditView : UIView

@property (nonatomic, retain) UIViewController *parentVc;
@property (nonatomic, retain) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UILabel *sortTitle;
@property (nonatomic, retain) UITableView *sortTableView;

- (id)initWithFrame:(CGRect)frame
        andParentVC:(UIViewController *)aVC;

@end
