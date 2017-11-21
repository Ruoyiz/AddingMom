//
//  ADPhotoActionSheet.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/10.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADPhotoActionSheet.h"
@interface ADPhotoActionSheet ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_tableViewDateArray;
    UIButton *_backButton;
}
@end
@implementation ADPhotoActionSheet
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        _tableViewDateArray = titleArray;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.dataSource = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? CGFLOAT_MIN:10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0 ? 2:1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _tableViewDateArray[indexPath.section][indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)show{
    ADAppDelegate *myApp = APP_DELEGATE;
    UIWindow *myWindow = myApp.window;
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backButton.alpha = 0.5;
    _backButton.backgroundColor = [UIColor blackColor];
    [_backButton addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [myWindow addSubview:_backButton];
    [myWindow addSubview:self];
    [UIView animateWithDuration:0.2 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hide];
    if ([_deletege respondsToSelector:@selector(photoActionSheetClicked:atIndex:)]) {
        [_deletege photoActionSheetClicked:self atIndex:indexPath.section*100 + indexPath.row];
    }
}
- (void)hide{
    [_backButton removeFromSuperview];
    _backButton = nil;
    [UIView animateWithDuration:0.2 delay:0.05 usingSpringWithDamping:1 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
@end
