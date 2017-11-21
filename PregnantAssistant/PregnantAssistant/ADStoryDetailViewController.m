//
//  ADStoryDetailViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADStoryDetailViewController.h"
#import "MomStoryComment.h"
#import "MomStory.h"
#import "ADCommentTableViewCell.h"
#import "ADShareHelper.h"
#import "SVPullToRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ADSimpleLoadingView.h"
#import "ADAlertView.h"
#import "ADZoomImgView.h"

#define MAXLENGTH 600
#define BARHEIGHT 48
#define TEXTLANGTH 300

static NSString *louZhuTip = @"楼主还没有现身哦~";
@interface ADStoryDetailViewController ()

@end

@implementation ADStoryDetailViewController{
    BOOL _allComment;
    BOOL _reloading;
    ADSimpleLoadingView *_loadingView;
    BOOL _isDelete;
}
#pragma mark - view circle life
-(void)dealloc
{
    self.myTableView.showsInfiniteScrolling = NO;
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    [self.myTableView removeFromSuperview];
    self.myTableView = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:_inputToolbar];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self loadingStop];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MobClick event:lightforum_entry_view];
    
    [self addTableView];

    [self setRightItemSecertShare];
    
    if (_aSecret == nil) {
        [self getASecretWithId:_postId finish:^(){
            [self.myTableView reloadData];
        }];
    } else {
        NSString *aSecret = _aSecret[@"postId"];
        _postId = aSecret.intValue;
    }
    
    _uid = _aSecret[@"uid"];
    NSString *content = _aSecret[@"body"];
    NSString *likeNum = _aSecret[@"praiseCount"];
    NSString *commentNum = _aSecret[@"commentCount"];
    
    _localLikeNum = likeNum.intValue;
    _localCommentNum = commentNum.intValue;
    _currentPos = 0;
    _haveMoreData = YES;
    
//    _onlyShowLouzhu = NO;
    
    [self calcFristCellHeightWithContent:content];
    
    self.myTitle = @"秘密详情";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    _commentArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    if (_scrollBottom == YES) {
        [self getCommentBeginWith:@"0" andSize:@"2000" complication:^{
            [self.myTableView reloadData];
            [self scrollToBottom];
            
        }];
    } else {
        
        [self getCommentBeginWith:@"0" andSize:@"15" complication:^{
            [self.myTableView reloadData];
//            [self loadLoadingViewFromHeight:_cellHeight];
        }];
    }

    [self loadTextView];
    
}

- (void)loadTextView
{
    self.inputToolbar = [[BHInputToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - BARHEIGHT, SCREEN_WIDTH, BARHEIGHT)];
    [self.view addSubview:self.inputToolbar];
    _inputToolbar.inputDelegate = self;
    _inputToolbar.textView.placeholder = @"";
    _inputToolbar.backgroundColor = [UIColor whiteColor];
    
    //read text
    NSString *oldStr = [[NSUserDefaults standardUserDefaults] momSecretCommentDraft];
    if (oldStr.length > 0) {
        self.inputToolbar.textView.text = oldStr;
    }
    
}

- (void)calcFristCellHeightWithContent:(NSString *)content
{
    CGRect textRect;
    
    textRect = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -36, 1000)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont momSecretCell_title_font]}
                                     context:nil];
    _cellHeight = textRect.size.height;
    
    NSString *imageUrls = _aSecret[@"imageUrl"];
    NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *imageUrlArray = nil;
    if (xmlData != nil) {
        imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
    }
    float perImgRowHeight = (SCREEN_WIDTH - 8*4) /3;
    if (imageUrlArray.count > 0) {
        NSInteger rowNum = (imageUrlArray.count -1) /3 +1;
        _cellHeight += perImgRowHeight *rowNum;
        _cellHeight += 21 +6 +40+12;
    } else {
        _cellHeight += 42 +40;
    }
}

-(void)addTableView
{
    self.myTableView = [[UITableView alloc]initWithFrame:
                        CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height -40)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorColor = [UIColor clearColor];
    
    _loadingView = [[ADSimpleLoadingView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 100)];
    _loadingView.hidden = YES;
    [self.myTableView addSubview:_loadingView];

    self.myTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [UIColor bg_lightYellow];
    
    //add infi
    __weak ADStoryDetailViewController *weakSelf = self;
    // setup infinite scrolling
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addKeyboardNotification];

    [self.inputToolbar.textView resignFirstResponder];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Activity_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Activity_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateUI:)
                                                name:haveSomeOneLikeSecretNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(dismissImgView:)
                                                name:tapImgNotification
                                              object:nil];
}

- (void)Activity_keyboardWillHide:(NSNotification *)notification
{
    /* Move the toolbar back to bottom of the screen */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[[notification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = _inputToolbar.frame;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    }
    else {
        frame.origin.y = SCREEN_WIDTH - frame.size.height;
    }
    _inputToolbar.frame = frame;
    [UIView commitAnimations];
}

- (void)updateUI:(NSNotification *)notification
{
    [self.inputToolbar.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadMore
{
    _reloading = YES;
    [self getCommentBeginWith:[NSString stringWithFormat:@"%ld", (long)_currentPos]
                      andSize:@"20"
                 complication:^(void){
                     _reloading = NO;
                        if (!_haveMoreData) {
                            _allComment = YES;
                            [ADHelper showToastWithText:@"没有更多评论了" frame:CGRectMake(0, SCREEN_HEIGHT- 100, SCREEN_WIDTH, 50)];
                            [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.1];
                        } else {
                         [self.myTableView reloadData];
                     }
                     
                     if (self.myTableView.infiniteScrollingView.state != SVInfiniteScrollingStateStopped) {
                         [self.myTableView.infiniteScrollingView stopAnimating];
                         self.myTableView.showsInfiniteScrolling = NO;
                     }
                 }];
}

- (void)scrollToBottom
{
    if (self.myTableView.contentSize.height > self.myTableView.bounds.size.height) {
        [self.myTableView setContentOffset:
         CGPointMake(0, self.myTableView.contentSize.height -self.myTableView.bounds.size.height) animated:YES];
         [self.myTableView.infiniteScrollingView stopAnimating];
    }
}

- (void)getASecretWithId:(NSInteger)aSecretId finish:(FinishRequstBlock)aFinishBlock
{
//    NSLog(@"aId:%ld",(long)aSecretId);
    [[ADMomSecertNetworkHelper shareInstance]getASecretWithId:aSecretId
                                               andFinishBlock:
     ^(NSArray *resultArray) {
         NSDictionary *resultDic = resultArray[0];
         NSString *commentNum = resultDic[@"commentCount"];
         //        NSString *likeNum = resultDic[@"praiseCount"];
         _localCommentNum = commentNum.intValue;
         //        _localLikeNum = likeNum.intValue;
         
         _aSecret = resultDic;
         _uid = _aSecret[@"uid"];
         
         NSString *content = resultDic[@"body"];
         [self calcFristCellHeightWithContent:content];
         if (aFinishBlock) {
             aFinishBlock();
         }
         [self loadingStop];
    } failed:^{
        [self loadingStop];
    }];
}

- (void)getCommentBeginWith:(NSString *)aStart
                    andSize:(NSString *)aSize
               complication:(FinishRequstBlock)aRequstBlock
{
    NSString *postId = _aSecret[@"postId"];
    if (postId.length == 0) {
        postId = [NSString stringWithFormat:@"%ld", (long)_postId];
    }
    
//    NSLog(@"GET ONCE");
    
    [[ADMomSecertNetworkHelper shareInstance]getCommentWithPostId:postId
                                                      andStartInx:aStart
                                                          andSize:aSize
                                                   andFinishBlock:^(NSArray *resultArray)
     {
         _reloading = NO;
         [self.commentArray addObjectsFromArray:resultArray];
         _currentPos += resultArray.count;
         
         if (resultArray.count > 0) {
             _haveMoreData = YES;
         } else {
             _isDelete = YES;
             _haveMoreData = NO;
         }
         
         if(aRequstBlock)
             aRequstBlock();
         [self loadingStop];
     } failed:^{
         _reloading = NO;
         
         [self loadingStop];
     }];
}

- (void)back
{
    //save draft
    [[NSUserDefaults standardUserDefaults]setMomSecretCommentDraft:_inputToolbar.textView.text];
    if ([self.delegate respondsToSelector:@selector(changeStatusAtIndex:withObjc:)]) {
        [self.delegate changeStatusAtIndex:_fromRow withObjc:_aSecret];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemMethod:(UIButton *)sender
{
    [_inputToolbar.textView.internalTextView resignFirstResponder];
    [MobClick event:lightforum_entry_share];
    [self resignFirstResponder];

    [self showBgview];

    _aShareView =
    [[ADShareView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, 180)
                          andParentVC:self
                            showTitle:YES];
    [_bgView addSubview:_aShareView];
    
    UITapGestureRecognizer *disMissTap2 =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    
    [_aShareView addGestureRecognizer:disMissTap2];
}

- (void)showBgview
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.appDelegate.window addSubview:_bgView];
    
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                     } completion:^(BOOL finished) {
                     }];
    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *disMissTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    [_bgView addGestureRecognizer:disMissTap];
}

- (void)dismissActionSheet
{
    [self dismissExBgView];
}

- (void)dismissExBgView
{
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _bgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_bgView removeFromSuperview];
                     }];
}

#pragma mark - UITableview method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count +1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_isTopic == YES) {
//            NSLog(@"isTopic");
            NSString *reuseStr = @"topicCell";
            _aTopicCell = [[ADTopicTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:reuseStr
                                                               topic:_topic
                                                          showDetail:YES];
            _aTopicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *commentStr = _aSecret[@"commentCount"];
            NSString *likeStr = _aSecret[@"praiseCount"];
            if (commentStr.intValue > 999) {
                commentStr = [NSString stringWithFormat:@"%dK",commentStr.intValue/1000];
            }
            _aTopicCell.commentLabel.text = commentStr;
            
            if (likeStr.intValue > 999) {
                likeStr = [NSString stringWithFormat:@"%dK",likeStr.intValue/1000];
            }
            _aTopicCell.likeLabel.text = likeStr;
            
            NSString *isComment = _aSecret[@"isComment"];
            _aTopicCell.isComment = isComment.boolValue;
            _aTopicCell.isLike = _aSecret[@"isPraise"];
            
            _aTopicCell.likeBtn.tag = indexPath.row;
            [_aTopicCell.likeBtn
             addTarget:self action:@selector(changeTopicLikeStatus:) forControlEvents:UIControlEventTouchUpInside];
            _aTopicCell.placeAndDueLabel.text = @"来自加丁妈妈";
            
            return _aTopicCell;
        } else {
            NSString *reuseStr = @"StoryCell";
            _aStoryCell =
            [[CustomStoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
            _aStoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            _aStoryCell.passThoughTouch = NO;
            _aStoryCell.parentVC = self;
            
            MomStory *aStory = [[MomStory alloc]initWithImgData:nil
                                                     contentStr:_aSecret[@"body"]
                                                       placeStr:_aSecret[@"cityName"]
                                                         dueStr:@""
                                                     commentStr:_aSecret[@"commentCount"]
                                                        likeStr:_aSecret[@"praiseCount"]];
            _aStoryCell.summaryStory.text = aStory.contentStr;
            _aStoryCell.placeAndDueLabel.text = aStory.placeStr;
            
            NSString *likeNumStr = aStory.likeNumStr;
            if (likeNumStr.intValue > 999) {
                likeNumStr = [NSString stringWithFormat:@"%dK",likeNumStr.intValue/1000];
            }
            
            _aStoryCell.likeLabel.text = likeNumStr;
            
            NSString *isHot = _aSecret[@"isHot"];
            _aStoryCell.isHot = isHot.boolValue;
            
            _aStoryCell.isLike = _aSecret[@"isPraise"];
            NSString *isComment = _aSecret[@"isComment"];
            
            if (isComment.boolValue == NO) {
                _aStoryCell.isComment = _isComment;
            } else {
                _aStoryCell.isComment = YES;
            }
            
            NSString *commentNum = _aSecret[@"commentCount"];

            _localCommentNum = commentNum.integerValue;
//            NSLog(@"commentNum:%@",_aSecret[@"commentCount"]);
            _aStoryCell.commentLabel.text = _aSecret[@"commentCount"];
            
            [_aStoryCell.likeBtn addTarget:self action:@selector(changeLikeStatus:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *imageUrls = _aSecret[@"imageUrl"];
            NSData* xmlData = [imageUrls dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *imageUrlArray = nil;
            if(xmlData != nil) {
                imageUrlArray = [NSJSONSerialization JSONObjectWithData:xmlData
                                                                options:NSJSONReadingAllowFragments
                                                                  error:nil];
            }
            
            _aStoryCell.showReport = YES;
            _aStoryCell.imageUrlArray = imageUrlArray;
            
            [_aStoryCell.showReportBtn addTarget:self action:@selector(showSummmarySheet)
                                forControlEvents:UIControlEventTouchUpInside];
            
            return _aStoryCell;
        }
    } else {
//        NSString *reuseStr = [NSString stringWithFormat:@"CommentCell%ld",(long)indexPath.row];
        NSString *reuseStr = @"CommentCell";
        
        ADCommentTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
        if (customCell == nil) {
            customCell = [[ADCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:reuseStr];
        }

        //NSLog(@"commentArray:%@",_commentArray);
        NSDictionary *aComment = _commentArray[indexPath.row -1];
        
        NSString *commentName = nil;
        if (aComment[@"commentedName"] != [NSNull null]) {
            commentName = aComment[@"commentedName"];
        }
        
        NSNumber *isSelf = aComment[@"isSelf"];
        
        NSNumber *isPraised = aComment[@"isPraised"];
        NSNumber *isHot = aComment[@"isHot"];
        customCell.isHot = isHot.boolValue;

        [customCell.likeBtn setSelected:isPraised.boolValue];
        [customCell.likeBtn addTarget:self
                               action:@selector(changeCommentLikeStatus:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        [customCell.momLookReportBtn addTarget:self
                                        action:@selector(showASheet:)
                              forControlEvents:UIControlEventTouchUpInside];

//        [customCell.commentBtn addTarget:self
//                                  action:@selector(commentOne:)
//                        forControlEvents:UIControlEventTouchUpInside];
        
        if ([_uid isEqualToString:aComment[@"uid"]]) {
                customCell.userLabel.text = @"楼主";
                if (commentName.length == 0) {
                    customCell.userLabel.textColor = UIColorFromRGB(0xffa300);
                }
        } else if (isSelf.boolValue == YES) {
            customCell.userLabel.text = [NSString stringWithFormat:@"%@(自己)",aComment[@"nickname"]];
        } else {
            customCell.userLabel.text = aComment[@"nickname"];
        }
        
        if (commentName.length > 0) {
            if ([aComment[@"commentedUid"] isEqualToString:_uid]) {
                commentName = @"楼主";
            }
            NSString *finalStr =
            [NSString stringWithFormat:@"%@ 回复 %@", customCell.userLabel.text, commentName];
            
            NSMutableAttributedString* aAttributedString =
            [[NSMutableAttributedString alloc] initWithString:finalStr
                                                   attributes:
             @{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            
            [aAttributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor font_LightBrown]}
                                       range:[finalStr rangeOfString:@"回复"]];
            
            [aAttributedString setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffa300)}
                                       range:[finalStr rangeOfString:@"楼主"]];
            if ([commentName isEqualToString:@"楼主"]) {
                [aAttributedString setAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xffa300)}
                                           range:NSMakeRange(finalStr.length -2, 2)];
            }
            
            customCell.userLabel.attributedText = aAttributedString;
            customCell.userLabel.font = [UIFont systemFontOfSize:13];
        }
        customCell.commentLabel.text = aComment[@"body"];
        customCell.likeLabel.text = aComment[@"praiseCount"];
        
        NSString *timestamp = aComment[@"createTime"];
        NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timestamp.intValue];
        NSInteger hour = [createDate hoursBeforeDate:[NSDate date]];
        if (hour == 0) {
            NSInteger min = [createDate minutesBeforeDate:[NSDate date]];
            if (min == 0) {
                customCell.floorAndHourLabel.text = [NSString stringWithFormat:@"%ld楼·刚刚", (long)indexPath.row];
            } else {
                customCell.floorAndHourLabel.text =
                [NSString stringWithFormat:@"%ld楼·%ld分钟前", (long)indexPath.row, (long)min];
            }
        } else if (hour >= 24) {
            NSInteger day = [createDate daysBeforeDate:[NSDate date]];
            customCell.floorAndHourLabel.text =
            [NSString stringWithFormat:@"%ld楼·%ld天前", (long)indexPath.row, (long)day];
        } else {
            customCell.floorAndHourLabel.text =
            [NSString stringWithFormat:@"%ld楼·%ld小时前", (long)indexPath.row, (long)hour];
        }
        
        return customCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"select:%ld",(long)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row > 0) {
        [self showReportSheetAtRow:indexPath.row -1];
    }
}

- (void)showASheet:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
    [self showReportSheetAtRow:indexPath.row -1];
}

//- (void)commentOne:(UIButton *)sender
//{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
//    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
//    
//    _toReplyComment = _commentArray[indexPath.row -1];
//    if ([_uid isEqualToString:_toReplyComment[@"uid"]]) {
//        self.inputToolbar.textView.placeholder = @"回复 楼主:";
//    } else {
//        self.inputToolbar.textView.placeholder =
//        [NSString stringWithFormat:@"回复 %@:", _toReplyComment[@"nickname"]];
//    }
//    
//    [self.inputToolbar.textView.internalTextView becomeFirstResponder];
//}
//
- (void)showSummmarySheet
{    
    [self.inputToolbar.textView.internalTextView resignFirstResponder];
    ADActionSheetView *actionSheet;
    
    NSLog(@" my uid %@",[NSUserDefaults standardUserDefaults].addingUid);
    
    NSLog(@"uid == %@,uidsecend = %@",[NSUserDefaults standardUserDefaults].addingUid,_uid);
    if (![[NSUserDefaults standardUserDefaults].addingUid isEqualToString:_uid]) {
        actionSheet= [[ADActionSheetView alloc] initWithTitleArray:@[@"回复", @"举报"]
                                                       cancelTitle:@"取消"
                                                  actionSheetTitle:@"请选择"];

    }else{
        actionSheet= [[ADActionSheetView alloc] initWithTitleArray:@[@"回复", @"删除"]
                                                       cancelTitle:@"取消"
                                                  actionSheetTitle:@"请选择"];
    }
    actionSheet.delegate = self;
    actionSheet.tag = -1;
    [actionSheet show];
}

- (void)showReportSheetAtRow:(NSInteger)aRow
{
    [self.inputToolbar.textView.internalTextView resignFirstResponder];
    _toReplyComment = _commentArray[aRow];
    ADActionSheetView *actionSheet;
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ([uid isEqualToString:_toReplyComment[@"uid"]]&&[_toReplyComment[@"uid"] isEqualToString:[NSUserDefaults standardUserDefaults].addingUid]) {
        actionSheet= [[ADActionSheetView alloc] initWithTitleArray:@[@"回复", @"删除"]
                                                                           cancelTitle:@"取消"
                                                                      actionSheetTitle:@"请选择"];
    }else{
        actionSheet = [[ADActionSheetView alloc] initWithTitleArray:@[@"回复", @"举报"]
                                                                           cancelTitle:@"取消"
                                                                      actionSheetTitle:@"请选择"];
    }
    actionSheet.tag = aRow;
    actionSheet.delegate = self;
    [actionSheet show];
}

- (void)changeLikeStatus:(UIButton *)sender
{
    [self changeASecret:sender withStatus:!sender.selected finish:^(){
        [self getASecretWithId:_postId finish:^(){
            [self.myTableView reloadData];
        }];
    }];
}

- (void)changeTopicLikeStatus:(UIButton *)sender
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.4)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [sender.layer addAnimation:k forKey:@"SHOW"];

    [self changeASecret:sender withStatus:!sender.selected finish:^{
        [self getASecretWithId:_postId finish:^(){
            [self.myTableView reloadData];
        }];
    }];
    
    _aTopicCell.isLike = [NSString stringWithFormat:@"%d", !sender.selected];
}

- (void)changeCommentLikeStatus:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTableView];
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:buttonPosition];
//    NSIndexPath *newPath = [NSIndexPath indexPathForRow:indexPath.row +1 inSection:0];
//    NSLog(@"row:%d", indexPath.row);
    ADCommentTableViewCell *aCell =
    (ADCommentTableViewCell *)[self.myTableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"index:%ld",(long)indexPath.row);
    if (_commentArray.count == 0) {
        return;
    }
    
    NSString *aCommentId = _commentArray[indexPath.row -1][@"commentId"];

    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.4)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [sender.layer addAnimation:k forKey:@"SHOW"];

    if (sender.selected == NO) {
        [self changeCommentLikeWithStatus:YES andCommentId:aCommentId andCell:aCell];
    } else {
        [self changeCommentLikeWithStatus:NO andCommentId:aCommentId andCell:aCell];
    }
    
}

- (void)changeCommentLikeWithStatus:(BOOL)status
                       andCommentId:(NSString *)aCommentId
                            andCell:(ADCommentTableViewCell *)aCell
{
    NSString *aPostId = _aSecret[@"postId"];
    [[ADMomSecertNetworkHelper shareInstance] changeACommentWithId:aCommentId
                                                         andPostId:aPostId
                                                         andStatus:status
                                                    andFinishBlock:
     ^{
//         aCell.likeBtn.enabled = NO;
         [self.commentArray removeAllObjects];
         [self getCommentBeginWith:@"0"
                           andSize:[NSString stringWithFormat:@"%ld",(long)_currentPos]
                      complication:^{
                          [self getASecretWithId:_postId finish:^(){
                              [self.myTableView reloadData];
//                              aCell.likeBtn.enabled = YES;
                          }];
                      }];
    } failed:^{
    }];
    
    if (status == YES) {
        [aCell.likeBtn setSelected:YES];
    } else {
        [aCell.likeBtn setSelected:NO];
    }
}

- (void)replySomeoneWithComment:(NSDictionary *)aComment
{
    
    [[ADMomSecertNetworkHelper shareInstance]replayCommentWithId:aComment[@"commentId"]
                                                         andBody:self.inputToolbar.textView.text
                                                       andPostId:_aSecret[@"postId"]
                                                  andFinishBlock:
     ^{
         _toReplyComment = nil;
         // reload data
         
         [self getCommentBeginWith:[NSString stringWithFormat:@"%ld", (long)_currentPos]
                           andSize:@"50"
                      complication:^(void){
                          
                          [self getASecretWithId:_postId finish:^{
                              
                              
                              [self.myTableView reloadData];
                          }];
                      }];
         self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,
                                             self.view.frame.size.height -self.inputToolbar.frame.size.height);

         _inputToolbar.textView.placeholder = @"";
     }];
}

- (void)changeASecret:(UIButton *)sender withStatus:(BOOL)likeStatus finish:(FinishRequstBlock)aFinishBlock
{
    NSString *aPostId = _aSecret[@"postId"];
    
    NSMutableDictionary *aSecret = [NSMutableDictionary dictionaryWithDictionary:self.aSecret];
//    NSInteger praiseCount = [_aStoryCell.likeLabel.text integerValue];
//    if (sender.selected == YES) {
//        sender.selected = NO;
//        praiseCount --;
//    }else{
//        sender.selected = YES;
//        praiseCount ++;
//    }
//
//    //改变model状态
//    _aSecret = aSecret;
//    
//    _aStoryCell.likeLabel.text = [NSString stringWithFormat:@"%d",praiseCount];
//
    
    //    NSLog(@"a likeStatus:%d", likeStatus);
    if (likeStatus == YES) {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.4)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [_aStoryCell.likeBtn.layer addAnimation:k forKey:@"SHOW"];
        
        [_aStoryCell.likeBtn setSelected:YES];
        _localLikeNum += 1;
        
        [aSecret setObject:[NSString stringWithFormat:@"%ld",(long)_localLikeNum] forKey:@"praiseCount"];
        [aSecret setObject:[NSNumber numberWithBool:YES] forKey:@"isPraise"];

    } else {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.4),@(1.0)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [_aStoryCell.likeBtn.layer addAnimation:k forKey:@"SHOW"];
        
        [_aStoryCell.likeBtn setSelected:NO];
        _localLikeNum -= 1;
        
        [aSecret setObject:[NSString stringWithFormat:@"%ld",(long)_localLikeNum] forKey:@"praiseCount"];
        [aSecret setObject:[NSNumber numberWithBool:NO] forKey:@"isPraise"];
    }
    
    //大于四位数
    NSString *likeStr = [NSString stringWithFormat:@"%d",_localLikeNum];
    if (likeStr.intValue > 999) {
        likeStr = [NSString stringWithFormat:@"%dK",likeStr.intValue/1000];
    }
    _aTopicCell.likeLabel.text = likeStr;
    
    [[ADMomSecertNetworkHelper shareInstance]changeAPostWithId:aPostId andStatus:likeStatus complication:^{
        if (aFinishBlock) {
            aFinishBlock();
        }
    } failed:^{
        [ADHelper showToastWithText:ConnectError];
        sender.selected = !sender.selected;
        if (likeStatus) {
            _localLikeNum -=1;
            [aSecret setObject:[NSNumber numberWithBool:NO] forKey:@"isPraise"];

        }else{
            _localLikeNum += 1;
            [aSecret setObject:[NSNumber numberWithBool:YES] forKey:@"isPraise"];

        }
        
        [aSecret setObject:[NSString stringWithFormat:@"%ld",(long)_localLikeNum] forKey:@"praiseCount"];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_isTopic) {
            _cellHeight = SCREEN_WIDTH * (1012 /1080.0) +12 +40;
            
            if (_commentArray.count == 0) {
                [self loadLoadingViewFromHeight:_cellHeight];
            }
            return _cellHeight;
        } else {
            if (_commentArray.count == 0) {
                if (!_isDelete) {
                    [self loadLoadingViewFromHeight:_cellHeight];
                }
            }
            return _cellHeight;
        }
    } else {
        NSDictionary *aComment = _commentArray[indexPath.row -1];
//        NSLog(@"Acomment:%@ commentArray:%@", aComment, _commentArray);
        NSString *body = aComment[@"body"];
        
        CGRect textRect = [body boundingRectWithSize:CGSizeMake(SCREEN_WIDTH -30, 1000)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont momSecretCell_title_font]}
                                             context:nil];

        return textRect.size.height +72;
    }
}

#pragma mark -share method
- (void)shareContent:(UIButton *)sender
{
    [self dismissExBgView];
    
    _aShareContent = [[ADShareContent alloc]initWithTitle:@"加丁妈妈"
                                                   andDes:_aSecret[@"body"]
                                                   andUrl:
                      [NSString stringWithFormat:@"http://www.addinghome.com/pa/lightforum?postId=%ld",(long)_postId]
                                                   andImg:[UIImage imageNamed:@"AppIcon60x60"]];
    
//    NSLog(@"aShareContent:%@", _aShareContent.url);
    if (sender.tag == 1) {
        //微博
        NSString *des = [NSString stringWithFormat:@"加丁妈妈 - %@ %@",_aSecret[@"body"], _aShareContent.url];
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:des andImg:_aShareContent.img];
    } else if (sender.tag == 2) {
        //微信
        
        if(!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])){
            [ADHelper showToastWithText:@"您还没有安装微信"];
        }
        
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_aShareContent.url
                                                                title:_aShareContent.title
                                                          description:_aShareContent.des
                                                            shareType:weixin_share_tpye
                                                                image:_aShareContent.img
                                                                isImg:NO];
    } else if (sender.tag == 3) {
        //朋友圈
        if(!([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])){
            [ADHelper showToastWithText:@"您还没有安装微信"];
        }
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            
        }
        
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_aShareContent.url
                                                                title:_aShareContent.des
                                                          description:_aShareContent.des
                                                            shareType:friend_share_type
                                                                image:_aShareContent.img
                                                                isImg:NO];
    }
}

-(NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

#pragma mark - UITextField 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //textField.frame = CGRectMake(0, SCREEN_HEIGHT - 250, textField.frame.size.width, textField.frame.size.height);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    } else {
        if ([self getToInt:textField.text] > MAXLENGTH) {
            [ADHelper showToastWithText:@"字数太多了，简化后再评论吧"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - UIScrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"Did Scroll");
    [self.inputToolbar.textView.internalTextView resignFirstResponder];
    
//    NSLog(@"offset: %f", scrollView.contentSize.height - scrollView.contentOffset.y);
    if ((_myTableView.infiniteScrollingView.state !=
         SVInfiniteScrollingStateLoading) &&
        ([_myTableView numberOfRowsInSection:0] > 1) &&
        scrollView.contentSize.height - scrollView.contentOffset.y < 604.0 &&
        self.myTableView.contentSize.height > SCREEN_HEIGHT) {
        //[self.myTableView triggerInfiniteScrolling];
        self.myTableView.showsInfiniteScrolling = YES;
    }
    
    self.myTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height -self.inputToolbar.frame.size.height);
}

#pragma mark - inputToolbar 代理
-(void)inputButtonPressed:(NSString *)inputText
{
    //    _sendButton.enabled = NO;
    if (inputText.length == 0) {
        [ADHelper showToastWithText:@"写点内容再评论吧"];
    }
    
    if ([ADHelper getToInt:inputText] > TEXTLANGTH) {
        [ADHelper showToastWithText:@"最大支持150字哦"];
    } else if (_toReplyComment != nil) {
        [self replySomeoneWithComment:_toReplyComment];
        [self.inputToolbar.textView resignFirstResponder];
        [self.inputToolbar.textView clearText];
    } else {
        [self createComment];
        [self.inputToolbar.textView resignFirstResponder];
        [self.inputToolbar.textView clearText];
    }
}

- (void)inputToolbatFrameAfterKeyBoardShowWithKeyboardWidth:(CGFloat)height
{
    //_inputToolbar.frame = CGRectMake(0, _inputToolbar.frame.origin.y - height, SCREEN_WIDTH, _inputToolbar.frame.size.height);
    _inputToolbar.frame = CGRectMake(0, SCREEN_HEIGHT - _inputToolbar.frame.size.height - height, SCREEN_WIDTH, _inputToolbar.frame.size.height);

}

- (void)inputToolbatFrameAfterKeyBoardHidden
{
    _inputToolbar.frame = CGRectMake(0, SCREEN_HEIGHT - _inputToolbar.frame.size.height, SCREEN_WIDTH, _inputToolbar.frame.size.height);

}

- (void)createComment
{
    [[ADMomSecertNetworkHelper shareInstance]createCommentWithPostId:_aSecret[@"postId"]
                                                             andBody:self.inputToolbar.textView.text
                                                          onFinish:
     ^{
         [self.commentArray removeAllObjects];
         [self getCommentBeginWith:@"0"
                           andSize:@"50"
                      complication:^(){
                          [self getASecretWithId:_postId finish:^{
                              [self.myTableView reloadData];
                          }];
                          _isComment = YES;
                      }];
     } onFailed:^{
        [self.inputToolbar.textView resignFirstResponder];
     }];
}


- (void)Activity_keyboardWillShow:(NSNotification *)notification
{
    /* Move the toolbar to above the keyboard */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    NSDictionary* info = [notification userInfo];
    
    //---obtain the size of the keyboard---
    NSValue *aValue = info[UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    CGRect frame = _inputToolbar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - keyboardSize.height;

    _inputToolbar.frame = frame;
    [UIView commitAnimations];
}

#pragma mark - 图片浏览器
- (void)touchImg:(UITapGestureRecognizer *)aGes
{
    [_inputToolbar.textView resignFirstResponder];
    UIImageView *tapImgView = (UIImageView *)aGes.view;
    //show bigger img
    _aImgVc = [[ADCustomImageVC alloc]initWithImgUrls:_aStoryCell.imageUrlArray
                                      andCurrentIndex:aGes.view.tag -20
                                        andCurrentImg:tapImgView.image];
    
    [self.appDelegate.window addSubview:_aImgVc.view];
    
    _aImgVc.view.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _aImgVc.view.alpha = 1;
    [UIView commitAnimations];
}

- (void)dismissImgView:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    _aImgVc.view.alpha = 0;
    [UIView commitAnimations];
    [_aImgVc.currentImgView removeFromSuperview];
    [_aImgVc.pageScroll removeFromSuperview];
    [_aImgVc.view removeFromSuperview];
    _aImgVc = nil;
}

#pragma mark - actionSheet

- (void)actionSheet:(ADActionSheetView *)actionSheet clickedCustomButtonAtIndex:(NSNumber *)buttonIndex
{
    NSString *title = nil;
    NSInteger index = [buttonIndex integerValue];
    if (index < actionSheet.titleArray.count) {
        title = [actionSheet.titleArray objectAtIndex:index];
    }
    
    _toReplyComment = _commentArray[actionSheet.tag];
    if(index == 1){
        if (actionSheet.tag == -1) {
            if ([title isEqualToString:@"删除"]) {
                ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定删除？" cancelTitle:@"取消" confirmTitle:@"删除"];
                [alert showWithConfirm:^{
                    [[ADMomSecertNetworkHelper shareInstance] deleteSecertWithCommandId:nil PostId:_aSecret[@"postId"] onFinish:^(NSDictionary *resultDic) {
                        if (resultDic[@"result"]) {
                            if (_isDeleteReturnBlock) {
                                _isDeleteReturnBlock(YES,_cellIndex);
                            }
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } onFailed:^{
                        
                    }];
                }];
            }else if ([title isEqualToString:@"举报"]){
                ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定举报？" cancelTitle:@"取消" confirmTitle:@"举报"];
                [alert showWithConfirm:^{
                    NSString *commentId = _toReplyComment[@"commentId"];
                    [[ADMomSecertNetworkHelper shareInstance] reportCommentWithId:commentId andPostId:_aSecret[@"postId"]];
                    return;
                }];

            }

        }else{
            
            if ([title isEqualToString:@"删除"]) {
                
                ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定删除？" cancelTitle:@"取消" confirmTitle:@"删除"];
                [alert showWithConfirm:^{
                    NSString *commentId = _toReplyComment[@"commentId"];
                    
                    [[ADMomSecertNetworkHelper shareInstance]deleteSecertWithCommandId:commentId PostId:_aSecret[@"postId"] onFinish:^(NSDictionary *resultDic) {
                        [ADHelper showToastWithText:@"删除成功，请继续。。。" frame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
                        [_commentArray removeAllObjects];
                        _currentPos = 0;
                        [self getCommentBeginWith:@"0" andSize:@"15" complication:^{
                            _isDelete = YES;
                            [self.myTableView reloadData];
                        }];
                        
                    } onFailed:^{
                    }];
                }];

            }else if([title isEqualToString:@"举报"]){
                ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定举报？" cancelTitle:@"取消" confirmTitle:@"举报"];
                [alert showWithConfirm:^{
                    NSString *commentId = _toReplyComment[@"commentId"];
                    [[ADMomSecertNetworkHelper shareInstance] reportCommentWithId:commentId andPostId:_aSecret[@"postId"]];
                    return;
                }];
            }
        }
    } else if (index == 0) {
        
        if ([_uid isEqualToString:_toReplyComment[@"uid"]]) {
            self.inputToolbar.textView.placeholder = @"回复 楼主:";
            
        } else {
            NSString *replyStr = _toReplyComment[@"nickname"];
            NSString *commentStr = @"";
            if (replyStr.length == 0) {
                commentStr = @"回复 楼主:";
            } else {
                commentStr = [NSString stringWithFormat:@"回复 %@:", replyStr];
            }
            
            self.inputToolbar.textView.placeholder = commentStr;
        }
        
        [self.inputToolbar.textView.internalTextView becomeFirstResponder];
    }
}

- (void)loadLoadingViewFromHeight:(CGFloat)height
{
//    if (_loadingView) {
//        return;
//    }
    
    if (_localCommentNum == 0) {
        return;
    }
    _loadingView.frame = CGRectMake(0, height + 60, SCREEN_WIDTH, 100);
    _loadingView.hidden = NO;
}

- (void)loadingStop
{
    _loadingView.hidden = YES;
    [_loadingView endAnimation];
//    [_loadingView removeFromSuperview];
//    _loadingView = nil;
}

- (void)isDeleteReturnBackBlock:(isdeleteReturnBlock)block{
    self.isDeleteReturnBlock = block;
}


#pragma mark - 键盘处理
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardDidShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [self inputToolbatFrameAfterKeyBoardShowWithKeyboardWidth:keyboardRect.size.height];
}
- (void)keyboardDidHide:(NSNotification *)notification {
    _inputToolbar.inputButton.enabled = YES;
    [self inputToolbatFrameAfterKeyBoardHidden];
//    self.inputButton.enabled = YES;
//    if ([self.inputDelegate respondsToSelector:@selector(inputToolbatFrameAfterKeyBoardHidden)]) {
//        [self.inputDelegate inputToolbatFrameAfterKeyBoardHidden];
//    }else{
//        NSLog(@"键盘消失后没有改变inputView的frame的方法");
//    }
}

- (void)keyboardWillHiden:(NSNotification *)notification
{
    
}

@end