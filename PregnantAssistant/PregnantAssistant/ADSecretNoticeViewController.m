//
//  ADSecretNoticeViewController.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/7/16.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADSecretNoticeViewController.h"
#import "ADSecrertNoticeinfoModel.h"

@interface ADSecretNoticeViewController ()

@end

@implementation ADSecretNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)getData
{
    if (self.noticeArray.count == 0) {
        [self p_startLoadingAnimation];
    }
    [[ADMomSecertNetworkHelper shareInstance] getAllSecretNotinfoWithStart:@"0" size:@"10" SecretFinishBlock:^(NSArray *resultArray) {
        [self.noticeArray removeAllObjects];
        [[ADMomSecertNetworkHelper shareInstance] updateNotificationTimeComplete:^(BOOL isremoveSucess) {
            if (isremoveSucess) {
                [[NSNotificationCenter defaultCenter] postNotificationName:removeSecretNumChangedNotification object:nil];
            }
        }];
        [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.noticeArray addObject:[ADSecrertNoticeinfoModel getSecrertNoticeinfoModelWithDict:obj]];
        }];
        self.loadingIndex = self.noticeArray.count;
        if (self.noticeArray.count) {
            [self.emptyView removeFromSuperview];
            self.emptyView = nil;
        }
        [self.refreshControl endRefreshing];
        [self performSelector:@selector(loadContentView) withObject:nil afterDelay:0.6];
        
    } failed:^{
        [self.refreshControl endRefreshing];
        [self p_stopLoadingAnimation];
        if (0 == self.noticeArray.count) {
            [self performSelector:@selector(loadFailedView) withObject:nil afterDelay:0.6];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    ADFeedContentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[ADFeedContentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ADSecrertNoticeinfoModel *info = self.noticeArray[indexPath.row];
    cell.isSeen = NO;
    for (ADReadNoticeItem *aItem in self.allReadNoticeIdArray) {
        if ([aItem.messageId isEqualToString:info.messageListId]) {
            cell.isSeen = YES;
        }
    }
    cell.refSecrertNotiModel = info;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ADFeedContentListTableViewCell getSecrertCellHeightWithModel:self.noticeArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADFeedContentListTableViewCell *cell = (ADFeedContentListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSeen = YES;
    cell.refSecrertNotiModel = self.noticeArray[indexPath.row];
    ADSecrertNoticeinfoModel *noticeInfo = self.noticeArray[indexPath.row];
    ADReadNoticeItem *aItem = [[ADReadNoticeItem alloc]init];
    aItem.messageId = noticeInfo.messageListId;
    [self addAReadItem:aItem];
    
    NSString *postID = noticeInfo.postId;
    NSLog(@"type == %@",noticeInfo.type);
    if ([noticeInfo.type intValue] <= 4) {
        [self jumpToSecertVcWithCid:postID cellIndex:indexPath.row];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
