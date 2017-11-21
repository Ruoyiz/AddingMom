//
//  ADLookCommentViewController.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADLookCommentViewController.h"
#import "AFNetworking.h"
#import "SVPullToRefresh.h"
#import "ADUserInfoSaveHelper.h"
#import "ADAlertView.h"
#import "ADLookCommentNetwork.h"
#import "ADLoginControl.h"
#import "ADNavigationController.h"
#import "ADGetTextSize.h"
#import "ADToastHelp.h"

#define NavItemTag 3000

#define MAXLENGTH 600
#define BARHEIGHT 48
#define TEXTLANGTH 300
#define NavContentTag 4000

typedef enum : NSUInteger {
    ADContinueComment = 1,
    ADContinuePrise,
} ADContinue;

@interface ADLookCommentViewController ()

@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation ADLookCommentViewController{
    //所有评论和热门评论数组
    NSMutableArray *_allCommentArray;
//    NSMutableArray *_hotCommentArray;

    //判断是否正在加载
    BOOL _reloading;
    UIView *_customTabBar;
    
    //用于评论点赞
    ADMomLookCommentModel *_selectedModel;
    
    //评论草稿的model
    ADMomLookCommentModel *_selectedCommentModel;
    
    NSString *_commentName;
    
    //底部tabbar的输入框
    UIButton *_textButton;
    
    ADContinue _continueToDo;
    
    UIButton *_priseButton;
    ADLookCommentTableViewCell *_priseCell;
    BOOL _duringLogin;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_duringLogin) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self addKeyboardNotification];
    [MobClick event:adco_content_normal_comment_load];
}

- (void)continueTodo
{
    if (_continueToDo == ADContinuePrise) {
        [self commentCell:_priseCell clickedPraiseButton:_priseButton];
    }else if(_continueToDo == ADContinueComment){
        [self newComment];
    }
    
    _continueToDo = 0;
}
//
//- (void)loginAccountSuccessful
//{
//    [self performSelector:@selector(continueTodo) withObject:nil afterDelay:0.7];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [ADToastHelp dismissSVProgress];
    [[NSNotificationCenter defaultCenter] removeObserver:_myInputBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadTableView];
    [self configNavigaionView];

    self.view.backgroundColor = [UIColor whiteColor];
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addingLoginSuccess) name:loginWeiSucessNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelLogin) name:cancelLogin object:nil];
}

#pragma mark - 登录后的处理
- (void)addingLoginSuccess
{
    _duringLogin = NO;
    [self continueTodo];
}

//- (void)AddingLoginCancel
//{
//}

- (void)loadTableView
{
    //_hotCommentArray = [NSMutableArray array];
    _allCommentArray = [NSMutableArray array];

    _myCommentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
    _myCommentTableView.delegate = self;
    _myCommentTableView.dataSource = self;
    _myCommentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myCommentTableView];
    
    //添加上拉加载更多
    [self addRefreshAndInfi];

    [self p_startLoadingAnimation];
    //请求评论数据
    //[self startRequest];
    [self performSelector:@selector(startLoadData) withObject:nil afterDelay:0.2];
}

- (void)startLoadData
{
    [self addInputBar];
    [self startRequest];
}

#pragma mark - 导航条以及底部评论框
- (void)configNavigaionView
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = _titleLabel;
    
    if([_commentCount isEqual:[NSNull null]] || _commentCount == nil || _commentCount.integerValue == 0){
        _titleLabel.text = @"评论";
    }else{
        _titleLabel.text = [NSString stringWithFormat:@"评论 %@",_commentCount];
    }
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self configCustomTabBar];
}

- (void)configCustomTabBar
{
    _customTabBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    _customTabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customTabBar];
    
    UIView *sharpLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sharpLineView.backgroundColor = [UIColor separator_line_color];
    [_customTabBar addSubview:sharpLineView];
    
    CGFloat iconWidth = 50 - 16;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, iconWidth, iconWidth)];
    NSString *uid = [[NSUserDefaults standardUserDefaults] addingUid];
    if ([uid isEqualToString:@"0"]) {
        icon.image = [UIImage imageNamed:@"无头像"];
    }else{
        icon.image = [ADUserInfoSaveHelper readIconData];
    }
    icon.layer.cornerRadius = iconWidth / 2.0;
    icon.layer.masksToBounds = YES;
    [_customTabBar addSubview:icon];
    
    _textButton = [[UIButton alloc] initWithFrame:CGRectMake(30 + iconWidth, 0, SCREEN_WIDTH - 2 * (30 + iconWidth), 50)];
    _textButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_textButton setTitle:@"在这里说点什么吧..." forState:UIControlStateNormal];
    _textButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_textButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_textButton addTarget:self action:@selector(newComment) forControlEvents:UIControlEventTouchUpInside];
    [_customTabBar addSubview:_textButton];
    
    UIButton *publishButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - iconWidth, 0, iconWidth + 15, 50)];
    [publishButton setTitle:@"发表" forState:UIControlStateNormal];
    publishButton.titleLabel.font = [UIFont ADTraditionalFontWithSize:15];
    [publishButton setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    publishButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [publishButton addTarget:self action:@selector(publishNewComment) forControlEvents:UIControlEventTouchUpInside];
    [_customTabBar addSubview:publishButton];
}

#pragma mark - 加载更多控件
- (void)addRefreshAndInfi
{
    __weak ADLookCommentViewController *weakSelf = self;
    
    [self.myCommentTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    self.myCommentTableView.showsInfiniteScrolling = YES;
}

- (void)insertRowAtBottom
{    
    __weak ADLookCommentViewController *weakSelf = self;
    [self.myCommentTableView.infiniteScrollingView startAnimating];
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (_reloading) {
            
        }else{
            [weakSelf.myCommentTableView.infiniteScrollingView stopAnimating];

            [self getCommentListFromStartPos:_allCommentArray.count length:10 success:^(NSInteger commentCount) {
                
                if(_allCommentArray.count == 0){
                    NSLog(@"加载更多");
                }
            } failure:^{
                [weakSelf.myCommentTableView.infiniteScrollingView stopAnimating];
            }];
        }
    });
}

- (void)scrollToBottom
{
    if (_myCommentTableView.contentSize.height > _myCommentTableView.frame.size.height) {
        if (_allCommentArray.count == 0) {
            [self.myCommentTableView setContentOffset:CGPointMake(0, self.myCommentTableView.contentSize.height -self.myCommentTableView.bounds.size.height - 20) animated:YES];
        }else{
            [self.myCommentTableView setContentOffset:CGPointMake(0, self.myCommentTableView.contentSize.height -self.myCommentTableView.bounds.size.height) animated:YES];
        }
    }
}

#pragma mark - 获取网络数据
- (void)startRequest
{
    if(_failLoadingView){
        [_failLoadingView removeFromSuperview];
        _failLoadingView = nil;
    }
    if (_allCommentArray.count == 0 && !_emptyView) {
        [self p_startLoadingAnimation];
    }
    
    [self getCommentListFromStartPos:0 length:10 success:^(NSInteger commentCount) {} failure:^{}];
}

- (void)getCommentListFromStartPos:(NSInteger)startPos length:(NSInteger)length success:(void (^) (NSInteger commentCount))success failure:(void (^) (void))failure
{
    if (_reloading) {
        return;
    }
    
    _reloading = YES;
    
    NSString *commentId = nil;
    if (startPos != 0) {
        ADMomLookCommentModel *model = [_allCommentArray firstObject];
        commentId = model.commentId;
    }
    
    [ADLookCommentNetwork getCommentListFromStartPos:startPos size:length contentId:_contentId commentId:commentId success:^(id responseObject, NSInteger count) {
        if (count != _commentCount.integerValue) {
            _commentCount = [NSString stringWithFormat:@"%ld",(long)count];
            if (count == 0) {
                self.titleLabel.text = [NSString stringWithFormat:@"评论"];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCommentCountNoti object:[NSString stringWithFormat:@"%@",@"0"]];

            }else{
                self.titleLabel.text = [NSString stringWithFormat:@"评论 %@",_commentCount];
                [[NSNotificationCenter defaultCenter] postNotificationName:ChangeCommentCountNoti object:[NSString stringWithFormat:@"%@",_commentCount]];
            }
        }
        [_failLoadingView removeFromSuperview];
        _failLoadingView = nil;
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        
        if (startPos == 0) {
            [_allCommentArray removeAllObjects];
        }
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)responseObject;
            if (array.count == 0 ) {
                if (self.myCommentTableView.contentOffset.y + self.myCommentTableView.frame.size.height > self.myCommentTableView.contentSize.height) {
                    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.5];

                }
            }else{
                [_allCommentArray addObjectsFromArray:[ADMomLookCommentModel conversionResponseObjectToModelArray:responseObject]];
            }
        }
        [self finishedReloadData];
        success(count);
        
        if (_allCommentArray.count == 0) {
            [self loadEmptyView];
        }
        
    } failure:^(NSError *error) {
        [self performSelector:@selector(finishedReloadData) withObject:nil afterDelay:0.3];
        if (_allCommentArray.count == 0) {
            [self performSelector:@selector(failedLoadData) withObject:nil afterDelay:0.8];
        }
        NSLog(@"获取评论列表失败:%@",error.localizedDescription);
        failure();
    }];
}

- (void)loadEmptyView
{
    _emptyView = [[ADEmptyView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 64) title:@"还没有人抢沙发" image:[UIImage imageNamed:@"shafa"]];
    [self.view addSubview:_emptyView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyViewTaped)];
    [_emptyView addGestureRecognizer:tap];
}

- (void)emptyViewTaped
{
    [self cancelSendComment];
//    if (_myInputBar) {
//        [_myInputBar.inputTextView resignFirstResponder];
//    }
}

- (void)failedLoadData
{
    _failLoadingView = [[ADFailLodingView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 64) tapBlock:^{
        [self startRequest];
    }];
    
    _failLoadingView.backgroundColor = [UIColor clearColor];
    _failLoadingView.delegate = self;
    [_failLoadingView showInView:self.view];
    
    [self.view bringSubviewToFront:_myInputBar];
}

- (void)emptyAreaTaped
{
    [_myInputBar.inputTextView resignFirstResponder];
}

- (void)p_startLoadingAnimation
{
    if (!self.customLoadingView) {
        self.customLoadingView =[[ADLoadingView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 50 - 64)];
        [self.view addSubview:_customLoadingView];
        [_customLoadingView adLodingViewStartAnimating];
    }
}

- (void)p_stopLoadingAnimation
{
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _customLoadingView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_customLoadingView removeFromSuperview];
                         _customLoadingView = nil;
                     }];
}


- (void)finishedReloadData
{
    [_myCommentTableView reloadData];
    _reloading = NO;
    
    [self p_stopLoadingAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADMomLookCommentModel *model = [_allCommentArray objectAtIndex:indexPath.row];
    
    static NSString *cellName = @"ADLookCommentTableViewCell";
    ADLookCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ADLookCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.commentDelegate = self;
        
    }

    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADMomLookCommentModel *model = [_allCommentArray objectAtIndex:indexPath.row];
    
//    if (indexPath.row == 0 || indexPath.row == _hotCommentArray.count) {
//        return [ADLookCommentTableViewCell cellHeightFromModel:model comnentStyle:ADCommentStyleAll];
//    }
    
    return [ADLookCommentTableViewCell cellHeightFromModel:model];
}

#pragma mark - cell被点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self inputViewshouldDismiss];
    
    NSString *addingtoken = [[NSUserDefaults standardUserDefaults] addingToken];
    if (addingtoken.length == 0) {
        _continueToDo = 0;
        
        [self pushLoginVc];
        return;
    }
    
    [self showActionSheetAtIndex:indexPath.row];
}

#pragma mark - scrollView  delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self cancelSendComment];
}

#pragma mark - ADActionSheet 相关
- (void)setupSelectModelAtIndex:(NSInteger)index
{
    if (index == -1) {
        _selectedModel = nil;
    }else{
        _selectedModel = [_allCommentArray objectAtIndex:index];
    }
    [self setupCommentName];
}

- (void)setupCommentName
{
    if (_selectedModel == nil) {
        
        _commentName = [NSString stringWithFormat:@"%@:",[ADUserInfoSaveHelper readUserName]];
    }else{
        
        _commentName = [NSString stringWithFormat:@"回复 %@:",_selectedModel.commentName];
    }
}

- (void)showActionSheetAtIndex:(NSInteger)index
{
    //NSLog(@"cccc %d" ,index);
    [self setupSelectModelAtIndex:index];
    
    NSArray *array = [NSArray arrayWithObjects:@"回复", @"举报", nil];
    
    if(_selectedModel.isSelf){
        array = [NSArray arrayWithObjects: @"回复", @"删除", nil];
    }
    
    ADActionSheetView *actionSheet = [[ADActionSheetView alloc] initWithTitleArray:array cancelTitle:@"取消" actionSheetTitle:@"请选择"];
    actionSheet.tag = index;
    actionSheet.delegate = self;
    [actionSheet show];
    
}

- (void)actionSheet:(ADActionSheetView *)actionSheet clickedCustomButtonAtIndex:(NSNumber *)buttonIndex
{
    NSString *title = nil;
    NSInteger index = [buttonIndex integerValue];
    if (index < actionSheet.titleArray.count) {
        title = [actionSheet.titleArray objectAtIndex:index];
    }
    
    if ([title isEqualToString:@"举报"]) {
        
        ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定举报?" cancelTitle:@"取消" confirmTitle:@"举报"];
        [alert showWithConfirm:^{
            [self reportCommentAtIndex: actionSheet.tag];
            
        }];
        
    }else if ([title isEqualToString:@"回复"]){
        [self writeCommentAtIndex:actionSheet.tag];
    }else if([title isEqualToString:@"删除"]){
        if(_selectedModel.isSelf){
            
            ADAlertView *alert = [[ADAlertView alloc] initWithTitle:@"确定删除?" cancelTitle:@"取消" confirmTitle:@"删除"];
            [alert showWithConfirm:^{
                [self deleteCommentAtIndex:actionSheet.tag];
            }];
        }else{
            NSLog(@"隐藏");
        }
    }
}

- (void)writeCommentAtIndex:(NSInteger)index
{
    [self setupSelectModelAtIndex:index];
    
    [self.view bringSubviewToFront:_myInputBar];
    NSString *str = [[_textButton.titleLabel.attributedText.string componentsSeparatedByString:@" "] lastObject];
    if ([str isEqualToString:@"在这里说点什么吧..."]) {
        _myInputBar.inputTextView.text = @"";
        
    }else{
        _selectedCommentModel = _selectedModel;
        _myInputBar.inputTextView.text = [NSString stringWithFormat:@"%@",str];
    }
    [_myInputBar setTextCenter];
    [_myInputBar.inputTextView becomeFirstResponder];
}

- (void)reportCommentAtIndex:(NSInteger)index
{
    [ADLookCommentNetwork reportCommentForContentId:_contentId commentId:_selectedModel.commentId success:^(id responseObject) {
        [ADToastHelp showSVProgressWithSuccess:@"举报成功"];
    } failure:^(NSError *error) {
        [ADToastHelp showSVProgressToastWithError:@"举报失败"];
    }];
}

- (void)deleteCommentAtIndex:(NSInteger)index
{
    [ADLookCommentNetwork deleteCommentForContentId:_contentId commentId:_selectedModel.commentId success:^(id responseObject) {
        [self getCommentListFromStartPos:0 length:_allCommentArray.count success:^(NSInteger commentCount) {} failure:^{}];
    } failure:^(NSError *error) {
        [ADToastHelp showSVProgressToastWithError:@"删除失败"];
    }];
}

-(NSInteger)getToInt:(NSString*)strtemp
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

#pragma mark - 自定义textView的代理
- (BOOL)ADTextView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if (range.location < _commentName.length ) {
//        if ([textView.text isEqualToString:_commentName]) {
//        }else{
//            textView.text = _commentName;
//        }
//        return NO;
//    }
    
    return YES;
}

- (void)ADTextView:(UITextView *)textView didClickedSendButton:(UIButton *)button
{
    NSString *inputText = textView.text;
    if (inputText.length <= 0) {
        [ADToastHelp showSVProgressToastWithError:@"写点内容再评论吧"];
        return;
    }
    
    if ([ADHelper getToInt:inputText] > TEXTLANGTH ) {
        [ADToastHelp showSVProgressToastWithError:@"最大支持150字哦"];
        return;
    }
    
    [self inputViewshouldDismiss];   
//    NSArray *textArray = [inputText componentsSeparatedByString:_commentName];
//    NSString *commentText = [textArray lastObject];
    [self sendCommentWithInputText:inputText];
}

- (void)cancelSendComment
{
    [self inputViewshouldDismiss];

    if (_myInputBar && _myInputBar.inputTextView.text.length > 0) {
        
        NSDictionary *redColor = @{NSForegroundColorAttributeName:[UIColor redColor]};
        NSString *aString = [NSString stringWithFormat:@"[草稿] %@",_myInputBar.inputTextView.text];
        NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        [aAttributedString setAttributes:redColor range:[aString rangeOfString:@"[草稿]"]];
        [_textButton setAttributedTitle:aAttributedString forState:UIControlStateNormal];
    }else{
        NSString *aString = @"在这里说点什么吧...";
        NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        [_textButton setAttributedTitle:aAttributedString forState:UIControlStateNormal];
        [_textButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (void)ADTextViewDidChangeSelection:(UITextView *)textView
{
//    NSRange range = textView.selectedRange;
//    if (range.length > 0){
//        textView.text = _commentName;
//        [_myInputBar setTextCenter];
//    }
//    if (range.location < _commentNameLength) {
//        CGFloat length = range.length - _commentNameLength + range.location;
//        if (length < 0) {
//            length = 0;
//        }
//        textView.selectedRange = NSMakeRange(_commentNameLength, length);
//    }
}

- (void)sendCommentWithInputText:(NSString *)inputText
{
    NSString *aString = @"在这里说点什么吧...";
    NSMutableAttributedString *aAttributedString = [[NSMutableAttributedString alloc] initWithString:aString];
    [_textButton setAttributedTitle:aAttributedString forState:UIControlStateNormal];
    [_textButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _myInputBar.inputTextView.text = @"";
    
    NSString *replyCommentId = nil;
    if (_selectedModel != nil) {
        replyCommentId = _selectedModel.commentId;
    }

    [ADToastHelp showSVProgressToastWithTitle:@"正在发布评论"];
    [ADLookCommentNetwork createCommentForContentId:_contentId replyCommentId:replyCommentId commentbody:inputText success:^(id responseObject) {
        
        NSLog(@"回复成功 %@",responseObject);
        [self replaceListCommentComplete:^{
            [ADToastHelp showSVProgressWithSuccess:@"评论成功"];
        }];
    } failure:^(NSError *error) {
        [ADToastHelp showSVProgressToastWithError:@"评论失败"];
    }];
    
    
}

#pragma mark - 网络数据刷新
- (void)replaceListCommentComplete:(void (^) ())complete
{
    [self getCommentListFromStartPos:0 length:_allCommentArray.count+1 success:^(NSInteger commentCount){
        complete();
    } failure:^{
        complete();
    }];
}

- (void)inputToolbatFrameAfterKeyBoardHidden
{
    _myInputBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _myInputBar.frame.size.height);
}

- (void)inputViewshouldDismiss
{
    [_myInputBar.inputTextView resignFirstResponder];
    _myInputBar.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, _myInputBar.frame.size.height);
}


#pragma mark - 键盘处理
- (void)addKeyboardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Activity_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -
#pragma mark Responding to keyboard events
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
    
    CGRect frame = _myInputBar.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - keyboardSize.height + 1;
    
    _myInputBar.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    [_myInputBar setTextCenter];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    [self inputToolbatFrameAfterKeyBoardHidden];
}

- (void)keyboardWillHiden:(NSNotification *)notification
{
    [self inputToolbatFrameAfterKeyBoardHidden];
}


#pragma mark - comment的代理
- (void)commentCell:(ADLookCommentTableViewCell *)cell clickedPraiseButton:(UIButton *)button
{
    _selectedModel = cell.model;
    [self setupCommentName];
    
    
    NSString *addingtoken = [[NSUserDefaults standardUserDefaults] addingToken];
    if (addingtoken.length == 0) {
        _continueToDo = ADContinuePrise;
        _priseButton = button;
        _priseCell = cell;
        [self pushLoginVc];
        return;
    }
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.4)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [button.layer addAnimation:k forKey:@"SHOW"];
    
    NSInteger titleInt = [cell.priseCountLabel.text integerValue];
    //[button setTitle:@" 1" forState:UIControlStateNormal];
    
    if (!button.selected) {
        titleInt ++;
        cell.priseImageView.image = [UIImage imageNamed:@"赞过的"];
        cell.priseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)titleInt];
        [ADLookCommentNetwork createPraiseForContentId:_contentId commentId:_selectedModel.commentId success:^(id responseObject) {
            [self getCommentListFromStartPos:0 length:_allCommentArray.count success:^(NSInteger commentCount){
            } failure:^{
            }];
            
        } failure:^(NSError *error) {
            cell.priseImageView.image = [UIImage imageNamed:@"赞"];
            cell.priseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)titleInt-1];
            button.selected = !button.selected;
            
            [self getCommentListFromStartPos:0 length:_allCommentArray.count success:^(NSInteger commentCount){
            } failure:^{
            }];
            if (_continueToDo == ADContinuePrise) {
                [ADToastHelp showSVProgressToastWithError:@"已经点过赞了"];
            }else{
                [ADToastHelp showSVProgressToastWithError:@"点赞失败"];
            }
        }];
        
    }else{
        titleInt --;
        cell.priseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)titleInt];
        cell.priseImageView.image = [UIImage imageNamed:@"赞"];
        [ADLookCommentNetwork deletePraiseForContentId:_contentId commentId:_selectedModel.commentId success:^(id responseObject) {
            
            [self getCommentListFromStartPos:0 length:_allCommentArray.count success:^(NSInteger commentCount){
            } failure:^{
            }];
        } failure:^(NSError *error) {
            cell.priseImageView.image = [UIImage imageNamed:@"赞"];
            cell.priseCountLabel.text = [NSString stringWithFormat:@"%ld",(long)titleInt+1];
            button.selected = !button.selected;
            
            [self getCommentListFromStartPos:0 length:_allCommentArray.count success:^(NSInteger commentCount){
            } failure:^{
            }];
            
            [ADToastHelp showSVProgressToastWithError:@"取消点赞失败"];
        }];
    }
    
    button.selected = !button.selected;
}

#pragma mark - button -event
- (void)navItemBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)newComment
{
    NSString *addingtoken = [[NSUserDefaults standardUserDefaults] addingToken];
    if (addingtoken.length == 0) {
        _continueToDo = ADContinueComment;
        [self pushLoginVc];
        return;
    }
    
    [self writeCommentAtIndex:-1];
}

- (void)publishNewComment
{
    NSString *addingtoken = [[NSUserDefaults standardUserDefaults] addingToken];
    if (addingtoken.length == 0) {
        _continueToDo = ADContinueComment;
        [self pushLoginVc];
        return;
    }
    
    NSString *str = [[_textButton.titleLabel.attributedText.string componentsSeparatedByString:@" "] lastObject];
    if ([str isEqualToString:@"在这里说点什么吧..."]) {
        [self writeCommentAtIndex:-1];
    }else{
        _selectedModel = _selectedCommentModel;
        [self sendCommentWithInputText:str];
    }
}

- (void)addInputBar
{
    if (_myInputBar == nil) {
        _myInputBar = [[ADInputBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 130)];
        _myInputBar.inputDelegate = self;
        [self.view addSubview:_myInputBar];
    }
}

- (void)pushLoginVc
{
    _duringLogin = YES;
    ADLoginControl *loginVc = [[ADLoginControl alloc] init];
    loginVc.subTitle = @"评论和点赞，随时参与互动";
    ADNavigationController *nc = [[ADNavigationController alloc] initWithRootViewController:loginVc];
    
    [ADHelper presentVc:nc atVc:self hiddenNavi:YES loginControl:loginVc];
//    [self presentViewController:nc animated:YES completion:^{
//        
//    }];
//    ADUserInfoListVC *listVC = [[ADUserInfoListVC alloc] init];
//    listVC.fromMonSecret = YES;
//    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)cancelLogin
{
    _continueToDo = 0;
    _duringLogin = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
