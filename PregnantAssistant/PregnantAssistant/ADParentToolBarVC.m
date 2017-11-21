//
//  ADParentToolBarVC.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/4/23.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADParentToolBarVC.h"
#import "ADAdWebVC.h"
#import "ADParentToolBabyTitleView.h"
#import "ADPopEditView.h"
#import "ADEditToolTableViewCell.h"
#import "ADAllToolViewController.h"
#import "UIImage+Tint.h"
#import "ADPregNotifyViewController.h"
#import "ADParentsNotifViewController.h"
#import "ADCollectToolDAO.h"
#import "ADHtmlToolViewController.h"
#import "ADMomLookContentDetailVC.h"
#import "AFNetworking.h"
#import "ADToolIconDAO.h"

#define TITLEVIEW_HEIGHT 130
#define COLLECTIONTOOLVIEW_HEIGHT 50


static NSString *collectionReuseId = @"allIconCollectId";
static NSString *reuseId = @"editToolCell";

@interface ADParentToolBarVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>{

    UIView *_bgView;
    UIButton *_shadowSetButton;
    UIButton *_leftBtn;
    UIView *_collectionTool;
    
    UIScrollView *_backScrollView ;
    ADParentToolBabyTitleView *_titleView;
    NSMutableArray *_babyData;
    
    UICollectionView *_myCollectionView;
    ADPopEditView *_aPopView;
    NSMutableArray *_displayToolArray;
    NSMutableArray *_toRemoveToolArray;
    NSMutableArray *_editToolArray;
    
    float _collectionViewHeight;
    float _titleViewHeight;
    
    UILabel *collectionToolLabel;
 
    RLMResults *_favResult;
    
    //    BOOL _navHiddenAnimate;

}

@end

@implementation ADParentToolBarVC

#pragma mark 视图周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [MobClick event:tool_display];
    

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(finishSort)
                                                name:finishSortToolNotification
                                              object:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self readToolData];
    
    [ADCollectToolDAO syncAllDataOnGetData:^(NSArray *res, NSError *error) {
    } onUploadProcess:^(NSError *error) {
    } onUpdateFinish:^(NSError *error) {
        [self loadData];
    }];

}

- (void)viewDidLoad{
    [super viewDidLoad];
    _displayToolArray = [[NSMutableArray alloc] init];
    [self readToolData];
    [self addTitleView];
    [self layoutUIWithStartY:_titleViewHeight];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark UI初始化
- (void)layoutUIWithStartY:(NSInteger)startY
{
    
    _collectionTool = [[UIView alloc] initWithFrame:CGRectMake(0, startY, SCREEN_WIDTH, COLLECTIONTOOLVIEW_HEIGHT)];
    _collectionTool.backgroundColor = [UIColor whiteColor];
    [_backScrollView addSubview:_collectionTool];
    
    collectionToolLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 14, 85, 21)];
    collectionToolLabel.text = @"收藏的工具";
    collectionToolLabel.font = [UIFont fontWithName:@"FZLTXHK" size:16.0];
    collectionToolLabel.textColor = [UIColor darkGrayColor];
    [_collectionTool addSubview:collectionToolLabel];
    
    UIButton *collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionButton.frame = CGRectMake(0, 2, 34, 40);
    collectionButton.center = CGPointMake(SCREEN_WIDTH -28, collectionButton.center.y);
    [collectionButton setImage:[[UIImage imageNamed:@"set"] imageWithTintColor:[UIColor blackColor]]forState:UIControlStateNormal];
    [collectionButton addTarget:self action:@selector(showPopEditView) forControlEvents:UIControlEventTouchUpInside];
    startY += COLLECTIONTOOLVIEW_HEIGHT;
    [_collectionTool addSubview:collectionButton];
    
    [self addCollectionViewWithY:startY];// 添加小工具按钮
}

- (void)addTitleView{
    _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backScrollView.bounces = NO;
    _backScrollView.showsVerticalScrollIndicator = NO;
    _backScrollView.delegate = self;
    _backScrollView.tag = 99;
    [_backScrollView setBackgroundColor:[UIColor dirty_yellow]];
    [self.view addSubview:_backScrollView];
    
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ParentToolData" ofType:@"plist"]];
    _titleView = [[ADParentToolBabyTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TITLEVIEW_HEIGHT) andParentVC:self];
    _titleView.refeshData = dictionary;
    [self.view addSubview:_titleView];
    
    _shadowSetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_shadowSetButton setImage:[[UIImage imageNamed:@"set"] imageWithTintColor:[UIColor whiteColor]]
                      forState:UIControlStateNormal];
    [_shadowSetButton addTarget:self action:@selector(showPopEditView) forControlEvents:UIControlEventTouchUpInside];
    [_shadowSetButton setFrame:CGRectMake(0, -60, 34, 40)];
    [_titleView addSubview:_shadowSetButton];
    _titleView.clipsToBounds = YES;
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:18];
    [_leftBtn setFrame:CGRectMake(22, -60, SCREEN_WIDTH-32-50, 32)];
    [_leftBtn setTitle:_titleView.oldLable.text forState:UIControlStateNormal];
    _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftBtn addTarget:self action:@selector(titleViewDetail:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:_leftBtn];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleViewDetail:)];
    [_titleView addGestureRecognizer:tap];
    
    _titleViewHeight = _titleView.frame.size.height;

}

- (void)addCollectionViewWithY:(float)startY
{
    if (iPhone6 || iPhone6Plus) {
        _collectionViewHeight = 130;
    } else {
        _collectionViewHeight = 150;
    }
    RLMResults *parentsResults = [ADCollectToolDAO readAllParentToolData];
    NSInteger allToolCnt = parentsResults.count +1;
    NSInteger row  = allToolCnt /3;
    if (allToolCnt %3 > 0) {
        row += 1;
    }
    CGFloat height = row * _collectionViewHeight;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _myCollectionView =
    [[UICollectionView alloc]initWithFrame:CGRectMake(0, startY, SCREEN_WIDTH, TITLEVIEW_HEIGHT +height)
                      collectionViewLayout:layout];
    
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.scrollEnabled = NO;
    _myCollectionView.backgroundColor = [UIColor dirty_yellow];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:@"ADBigToolCollectionIcon" bundle:nil];
    [_myCollectionView registerNib:cellNib forCellWithReuseIdentifier:collectionReuseId];
    [_backScrollView addSubview:_myCollectionView];
    startY += _myCollectionView.frame.size.height;
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, startY - _collectionViewHeight*5/13);
}

#pragma mark 点击事件

- (void)titleViewDetail:(UITapGestureRecognizer *)tap{
  
    if ([self getWeekIndex] < 52) {
        ADParentsNotifViewController *aNotifyVc = [[ADParentsNotifViewController alloc]init];
        [MobClick event:yuerxiangqing_tab_top];
        [self.navigationController pushViewController:aNotifyVc animated:YES];
    }
}

#pragma mark - unCollect action
- (void)tapUnCollected:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_aPopView.sortTableView];
    NSIndexPath *indexPath = [_aPopView.sortTableView indexPathForRowAtPoint:buttonPosition];
    
    ADTool *aTool = _editToolArray[indexPath.row];
    if (sender.selected == YES) {
        if (_editToolArray.count -_toRemoveToolArray.count <=5) {
            [ADHelper showToastWithText:atLeastIconNumTip
                            andFontSize:12
                               andFrame:CGRectMake(0, 130, SCREEN_WIDTH, 50)];
            return;
        }
        
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(1.0),@(1.3),@(1.0)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
        k.calculationMode = kCAAnimationPaced;
        
        [sender.layer addAnimation:k forKey:@"favIcon"];
        
        [sender setSelected:NO];
        [_toRemoveToolArray addObject:aTool];
    } else {
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.6),@(1.0),@(1.3)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [sender.layer addAnimation:k forKey:@"SHOW"];
        
        [sender setSelected:YES];
        NSLog(@"toRemove: %@ aTool: %@", _toRemoveToolArray, aTool);
        [_toRemoveToolArray removeObject:aTool];
    }
}

#pragma mark - set icon method
- (void)showPopEditView
{
    if (_bgView.superview != nil) {
        return;
    }
    [self showBgview];

    [MobClick event:tool_sort_display];
    
    _toRemoveToolArray = [[NSMutableArray alloc]initWithCapacity:0];
    _editToolArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (ADTool *tool in _displayToolArray) {
        ADTool *aTool = [[ADTool alloc] initWithTitle:tool.title];
        aTool.isMananullyCollect = tool.isMananullyCollect;
        aTool.isParentTool = tool.isParentTool;
        aTool.isWeb = tool.isWeb;
        aTool.myVc = tool.myVc;
        aTool.uid = tool.uid;
        [_editToolArray addObject:aTool];
    }    
    //_editToolArray = [_displayToolArray mutableCopy];
    _aPopView =
    [[ADPopEditView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- TITLEVIEW_HEIGHT)
                            andParentVC:self];
    _aPopView.sortTableView.dataSource = self;
    _aPopView.sortTableView.delegate = self;
    [_aPopView.sortTableView setEditing:YES animated:YES];
    [self.appDelegate.window addSubview:_aPopView];
    
    UINib *nib = [UINib nibWithNibName:@"ADEditToolTableViewCell" bundle:nil];
    [_aPopView.sortTableView registerNib:nib forCellReuseIdentifier:reuseId];
    
    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _aPopView.frame = CGRectMake(0, TITLEVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- TITLEVIEW_HEIGHT);
                     } completion:^(BOOL finished) {
                     }];
}


- (void)showBgview
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [self.appDelegate.window addSubview:_bgView];
    
    [UIView animateWithDuration:0.3 delay:0
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
                     } completion:^(BOOL finished) {
                     }];
    
    UITapGestureRecognizer *disMissTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    [_bgView addGestureRecognizer:disMissTap];
}

- (void)dismissExBgView
{
    _bgView.alpha = 1;
    [UIView animateWithDuration:0.5 delay:0.1
         usingSpringWithDamping:1 initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _bgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_bgView removeFromSuperview];
                     }];
    [UIView animateWithDuration:0.5 delay:0.
         usingSpringWithDamping:1 initialSpringVelocity:2
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _aPopView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- TITLEVIEW_HEIGHT);
                     } completion:^(BOOL finished) {
                     }];
}

- (void)finishSort
{
    [self dismissExBgView];
    _displayToolArray = _editToolArray;
    [_displayToolArray removeObjectsInArray:_toRemoveToolArray];
    NSMutableArray *copyTool = [[NSMutableArray alloc]initWithCapacity:0];
    //深拷贝 所有数据 删除旧的数据
    for (ADTool *tool in _displayToolArray) {
        ADTool *newTool = [[ADTool alloc]initWithTitle:tool.title];
        newTool.isParentTool = YES;
        newTool.isMananullyCollect = YES;
        [copyTool addObject:newTool];
    }
    [ADCollectToolDAO updateDataWithArray:copyTool];
    [_myCollectionView reloadData];
    [self updateCollectionScrollFrame];
}

- (void)updateCollectionScrollFrame{
    RLMResults *parentsResults = [ADCollectToolDAO readAllParentToolData];
    NSInteger allToolCnt = parentsResults.count +1;
    NSInteger row  = allToolCnt /3;
    if (allToolCnt %3) {
        row += 1;
    }
    CGFloat height = row * _collectionViewHeight;
    _myCollectionView.frame = CGRectMake(0,  TITLEVIEW_HEIGHT + COLLECTIONTOOLVIEW_HEIGHT, SCREEN_WIDTH, height + TITLEVIEW_HEIGHT);
    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,_myCollectionView.frame.origin.y + height + TITLEVIEW_HEIGHT - _collectionViewHeight*5/13);
}

- (NSInteger)getDaysWithDate:(NSDate *)date{
    NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
    return ((int)time)/(3600*24);
}

- (NSInteger)getWeekIndex{
    ADAppDelegate *myAPP = APP_DELEGATE;
    NSInteger days = [self getDaysWithDate:myAPP.babyBirthday];
    return days > 0?days/7:0;
}


#pragma mark - 加载数据

- (void)readToolData{
    [ADCollectToolDAO unCollectAToolWithTitle:@"问卷调查" recordTime:NO];
    [self addDefaultRecIconToFav];
    _favResult = [ADCollectToolDAO readAllParentToolData];
    if (_favResult.count) {
        [_displayToolArray removeAllObjects];
        for (ADTool *parentsCollectTool in _favResult) {
            if (![parentsCollectTool.title isEqualToString:@""]) {
                [_displayToolArray addObject:parentsCollectTool];
            }
        }
    }
    [self updateCollectionScrollFrame];
    [_myCollectionView reloadData];
}

- (void)loadData{
    RLMResults *preResults = [ADCollectToolDAO readAllPregToolData];
    for (ADTool *tool in preResults) {
        if (tool.isMananullyCollect) {
            [ADCollectToolDAO collectAToolWithTitle:tool.title recordTime:YES];
        }
    }
    [self readToolData];
}

- (void)addDefaultRecIconToFav{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *uid = userDef.addingUid;
    NSString *version = [[NSBundle mainBundle]infoDictionary][@"CFBundleVersion"];
    NSString *loginVersion = [NSString stringWithFormat:@"%@%@login",version,uid];
    NSString *nouserVersion = [NSString stringWithFormat:@"%@nouser",version];
    if ([uid isEqualToString:@"0"]) {
        if (![userDef boolForKey:nouserVersion]) {
            [self addRecIconToFav];
            [userDef setBool:YES forKey:nouserVersion];
        }
    }else{
        if (![userDef boolForKey:loginVersion]) {
            [self addRecIconToFav];
            [userDef setBool:YES forKey:loginVersion];
        }
    }
}

- (void)addRecIconToFav
{
    NSArray *favArray = [ADToolIconDAO getRecommandToolsForAlreadyMom];
    NSLog(@"favArray: %@", favArray);
    for (ADTool *tool in favArray) {
        [ADCollectToolDAO autoCollectAToolWithTitle:tool.title];
    }
    [ADCollectToolDAO sortLocalArrayOnCompletion:nil];
}

#pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_displayToolArray.count > 5) {
        if (scrollView.tag == 99) {
            CGFloat offsetY = scrollView.contentOffset.y;
            
            if (offsetY < 64) {
                _titleView.frame = CGRectMake(0, -offsetY , SCREEN_WIDTH, _titleViewHeight);
            } else {
                _titleView.frame = CGRectMake(0, -64, SCREEN_WIDTH, _titleViewHeight);
            }
            CGRect frame = [self.view convertRect:collectionToolLabel.frame fromView:collectionToolLabel];
            CGFloat btnCenterY = frame.origin.y -4;
            if (btnCenterY < 44) {
                btnCenterY = 44;
            }
            _leftBtn.center = CGPointMake(_leftBtn.center.x, btnCenterY +64);
            _shadowSetButton.hidden = NO;
            _shadowSetButton.center = CGPointMake(SCREEN_WIDTH -28, btnCenterY +64);
            _titleView.alpheFromVC =(TITLEVIEW_HEIGHT- offsetY)/TITLEVIEW_HEIGHT;
        }
    }
}


#pragma mark - tableview method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADEditToolTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    aCell.editing = YES;
    ADTool *aTool  = _editToolArray[indexPath.row];
    aCell.cellTitle.text = aTool.title;
    
    NSString *smallTitle= [NSString stringWithFormat:@"%@小", aTool.title];
    aCell.cellImageView.image = [UIImage imageNamed:smallTitle];
    [aCell.collectionBtn setSelected:YES];
    for (ADTool *actIcon in _toRemoveToolArray) {
        if ([aTool.title isEqualToString:actIcon.title]) {
            [aCell.collectionBtn setSelected:NO];
            break;
        }
    }
    [aCell.collectionBtn addTarget:self action:@selector(tapUnCollected:) forControlEvents:UIControlEventTouchUpInside];
    return aCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _editToolArray.count;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    ADTool *toMoveTool = _editToolArray[fromIndexPath.row];
    [_editToolArray removeObjectAtIndex:fromIndexPath.row];
    [_editToolArray insertObject:toMoveTool atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



#pragma mark - UICollectionViewDelegate -----datasouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _displayToolArray.count + 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseId forIndexPath:indexPath];
        
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:10];
        iconImageView.image = [UIImage imageNamed:@"育儿全部工具"];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        [titleLabel setText:@"全部工具"];
        
        return cell;
    } else {

        UICollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseId forIndexPath:indexPath];
        UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:10];
        ADTool *tool = _displayToolArray[indexPath.row-1];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@大", tool.title]];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
        [titleLabel setText:tool.title];
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(SCREEN_WIDTH/3.0, _collectionViewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    _navHiddenAnimate = YES;
    if (indexPath.row ==0) {
        ADAllToolViewController *allToolVc = [[ADAllToolViewController alloc]init];
        [self.navigationController pushViewController:allToolVc animated:YES];
    }else {
        ADTool *aTool = _displayToolArray[indexPath.row-1];
        NSLog(@"displaycount: %lu,%@",(unsigned long)_displayToolArray.count,_displayToolArray);
        NSLog(@"atool: %@,isweb: %d",aTool,aTool.isWeb);
        if (aTool.isWeb == YES) {
            ADHtmlToolViewController *aHtmlToolVc = [[ADHtmlToolViewController alloc]init];
            aHtmlToolVc.vcName = aTool.title;
            [self.navigationController pushViewController:aHtmlToolVc animated:YES];
        } else {
            ADToolRootViewController *aVc = [[NSClassFromString(aTool.myVc) alloc] init];
            aVc.vcName = aTool.title;
            [self.navigationController pushViewController:aVc animated:YES];
        }
    }

}

@end
