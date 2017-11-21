//
//  ADToolIconViewController.m
//  PregnantAssistant
//
//  Created by D on 15/3/18.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADToolIconViewController.h"
#import "ADAllToolViewController.h"
#import "ADEditToolTableViewCell.h"
#import "ADHtmlToolViewController.h"
#import "ADToolRootViewController.h"
#import "UIImage+Tint.h"
#import "ADPregNotifyViewController.h"
#import "ADCollectToolDAO.h"
#import "ADToolIconDAO.h"

#define TITLEVIEW_HEIGHT 130
#define COLLECTIONVIEW_HEIGHT (SCREEN_HEIGHT -TITLEVIEW_HEIGHT -50 -64) /3
static NSString *reuseId = @"editToolCell";
static NSString *collectionReuseId = @"allIconCollectId";

@implementation ADToolIconViewController
//    BOOL _navHiddenAnimate;
//}

#pragma mark - view circle life
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ADCollectToolDAO changeWebToVCWithTitle:@"胎儿发育图" VCName:@"ADGestationViewController"];
    [MobClick event:tool_display];
    if (iPhone6 || iPhone6Plus) {
        _collectionViewHeight = COLLECTIONVIEW_HEIGHT;
    } else {
        _collectionViewHeight = 150;
    }

    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(finishSort)
                                                name:finishSortToolNotification
                                              object:nil];


    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (_aTitleView) {
        [self reloadTitleView];
    }
}

- (void)reloadData
{
    [self readToolData];
    [self updateScrollFrame];
    [self.myCollectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resetNavigationBar];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addRecIconToFav];
    [self reloadData];

    [ADCollectToolDAO updateDataBaseOnfinish:^{
        [ADCollectToolDAO syncAllDataOnGetData:^(NSArray *res, NSError *error) {
            if (res == 0) {
                [self addRecIconToFav];
            }
        } onUploadProcess:^(NSError *error) {
        } onUpdateFinish:^(NSError *error) {
            [self reloadData];
        }];
    }];
}

- (void)reloadTitleView
{
    [_aTitleView refreshData];
    
    NSDictionary *dictionary =
    [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BabyData" ofType:@"plist"]];
    NSArray *heightArray = dictionary[@"height"];
    NSArray *weightArray = dictionary[@"weight"];
    NSArray *descArray   = dictionary[@"desc"];
    
    self.babyData = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < heightArray.count; i++) {
        NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:0];
        [tmpArray addObject:heightArray[i]];
        [tmpArray addObject:weightArray[i]];
        [tmpArray addObject:descArray[i]];
        [self.babyData addObject:tmpArray];
    }
    
    NSInteger day = [[NSDate date] distanceInDaysToDate:self.appDelegate.dueDate];
    NSInteger passDay = 280 -day;
//    NSLog(@"passDay:%d",passDay);
    if(passDay < 280 && passDay > 0) {
        _aTitleView.lenLabel.text = [NSString stringWithFormat:@"%@ cm",self.babyData[passDay -1][0]];
        _aTitleView.weightLabel.text = [NSString stringWithFormat:@"%@ g",self.babyData[passDay -1][1]];
        _aTitleView.sizeLabel.text = [NSString stringWithFormat:@"%@",self.babyData[passDay - 1][2]];
        
    } else if(passDay >= 280) {
        _aTitleView.lenLabel.text = [NSString stringWithFormat:@"%@ cm",self.babyData[279][0]];
        _aTitleView.weightLabel.text = [NSString stringWithFormat:@"%@ g",self.babyData[279][1]];
        _aTitleView.sizeLabel.text = [NSString stringWithFormat:@"%@",self.babyData[279][2]];
    }
    
    [_leftBtn setTitle:_aTitleView.dayLabel.text forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.myScrollView.backgroundColor = [UIColor dirty_yellow];
    
    self.myScrollView.tag = 999;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.delegate = self;
    [self.view addSubview:self.myScrollView];
   
    [self addTitleView];
    
    self.myBarTitle.textColor = UIColorFromRGB(0x3E3467);
    
    self.myToolBar.frame = CGRectMake(0, TITLEVIEW_HEIGHT -20, SCREEN_WIDTH, 50);
    [self.myScrollView addSubview:self.myToolBar];
    self.myScrollView.bounces = NO;
    
    [self addCollectionView];
    
    [self addButtons];
    
    if ([[NSUserDefaults standardUserDefaults] haveLauchToolTab] == NO) {
        //shadowView
        [self buildGuideView];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleView) name:UIApplicationDidBecomeActiveNotification object:nil];
//     self.fd_prefersNavigationBarHidden = NO;
}

- (void)addRecIconToFav
{
    _favToolArray = [ADCollectToolDAO readAllPregToolData];
    if (_favToolArray.count == 0) {
        //补齐 9个
        ADAppDelegate *appDelegate = APP_DELEGATE;
        NSTimeInterval time = [appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
        
        int days = ((int)time)/(3600*24);
        if (days < 0) {
            days = 0;
        }
        int passDay = 280 -days -1;
        int week = passDay /7;
         
        NSArray *recArray = [ADToolIconDAO getRecommandToolsForPreMomAtWeek:week];
        
        NSLog(@"old icon data: %@", _favToolArray);
 
        for (ADTool *aFavTool in recArray) {
            [ADCollectToolDAO autoCollectAToolWithTitle:aFavTool.title];
        }
    }
}

- (void)addButtons
{
    _setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setButton setFrame:CGRectMake(0, 2, 46, 46)];
    _setButton.center = CGPointMake(SCREEN_WIDTH -28, _setButton.center.y);

    [_setButton setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [_setButton addTarget:self action:@selector(showPopEditView) forControlEvents:UIControlEventTouchUpInside];

    [_myToolBar addSubview:_setButton];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    ADAppDelegate *appDelegate = APP_DELEGATE;
    
    NSTimeInterval time=[appDelegate.dueDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    if (days < 0) {
        days = 0;
    }
    int passDay = 280 -days -1;
    
    int week = passDay /7;
    int dueday = passDay %7;

    int leftDay = days+1;
    if (leftDay < 0) {
        leftDay = 0;
    }
    NSLog(@"dueDay == %d",dueday);
    [_leftBtn setTitle:[NSString stringWithFormat:@"孕%d周%d天  剩%d天", week, dueday, leftDay]
              forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    _leftBtn.titleLabel.font = [UIFont fontWithName:@"RTWSYueGoTrial-Light" size:18];
    [_leftBtn setFrame:CGRectMake(16, 0, SCREEN_WIDTH-32-50, 32)];
    
    _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_aTitleView addSubview:_leftBtn];
    
    _shadowSetButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [_shadowSetButton setImage:[[UIImage imageNamed:@"set"] imageWithTintColor:[UIColor whiteColor]]
                      forState:UIControlStateNormal];
    [_shadowSetButton addTarget:self action:@selector(showPopEditView) forControlEvents:UIControlEventTouchUpInside];
    [_shadowSetButton setFrame:CGRectMake(0, 2, 46, 46)];
    [_aTitleView addSubview:_shadowSetButton];
}

- (void)addTitleView
{
    _aTitleView = [[ADToolBabyTitleView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, TITLEVIEW_HEIGHT)
                                            andParentVC:self];
    [self.view addSubview:_aTitleView];
    
    [self reloadTitleView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 999) {
        CGFloat offsetY = scrollView.contentOffset.y;

        if (offsetY < 44) {
            _aTitleView.frame = CGRectMake(0, -offsetY -20, SCREEN_WIDTH, TITLEVIEW_HEIGHT);
        } else {
            _aTitleView.frame = CGRectMake(0, -44 -20, SCREEN_WIDTH, TITLEVIEW_HEIGHT);
            //move title and btn
        }
        
        CGRect frame = [self.view convertRect:_myBarTitle.frame fromView:_myBarTitle];
        
        CGFloat btnCenterY = frame.origin.y -4;
        if (btnCenterY < 44) {
            btnCenterY = 44;
        }
        
        _leftBtn.center = CGPointMake(_leftBtn.center.x, btnCenterY +64);
        
//        NSLog(@"btn alpha:%f ,btn: %f", btnCenterY / 40., btnCenterY);
//        _shadowAllButton.center = CGPointMake(SCREEN_WIDTH -24, btnCenterY +64);
        _shadowSetButton.center = CGPointMake(SCREEN_WIDTH -28, btnCenterY +64);

        _leftBtn.alpha = (148- btnCenterY) /114;
        
        _aTitleView.dayLabel.alpha = (btnCenterY - 56) /110;
        _aTitleView.lenLabel.alpha = (btnCenterY -48) /110;
        _aTitleView.weightLabel.alpha = (btnCenterY -48) /110;
        _aTitleView.weightView.alpha = _aTitleView.weightLabel.alpha;
        _aTitleView.lengthView.alpha = _aTitleView.lenLabel.alpha;
        _aTitleView.arrowView.alpha = _aTitleView.lenLabel.alpha;
        _aTitleView.sizeImageView.alpha = _aTitleView.sizeLabel.alpha =_aTitleView.lenLabel.alpha;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)readToolData
{
    _favToolArray = [ADCollectToolDAO readAllPregToolData];
}

- (void)updateScrollFrame
{
    //collection
    NSInteger allToolCnt = _favToolArray.count +1;
    NSInteger row  = allToolCnt /3;
    if (allToolCnt %3 > 0) {
        row += 1;
    }
    
    CGFloat height = row * _collectionViewHeight;
    NSLog(@"col row:%ld", (long)row);
    _myCollectionView.frame =
    CGRectMake(0, _myToolBar.frame.origin.y +_myToolBar.frame.size.height, SCREEN_WIDTH, height);
    if (iPhone6 || iPhone6Plus) {
        _myScrollView.contentSize =
        CGSizeMake(SCREEN_WIDTH, _myCollectionView.frame.origin.y +_myCollectionView.frame.size.height +34);
    } else {
        _myScrollView.contentSize =
        CGSizeMake(SCREEN_WIDTH, _myCollectionView.frame.origin.y +_myCollectionView.frame.size.height +34);
    }
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    CGFloat originY = _myToolBar.frame.origin.y +_myToolBar.frame.size.height;
    _myCollectionView =
    [[UICollectionView alloc]initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT -originY)
                      collectionViewLayout:layout];
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.backgroundColor = [UIColor dirty_yellow];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"ADBigToolCollectionIcon" bundle:nil];
    [_myCollectionView registerNib:cellNib forCellWithReuseIdentifier:collectionReuseId];

    [self.myScrollView addSubview:_myCollectionView];
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
    
    _editToolArray = [[NSMutableArray alloc]initWithCapacity:_favToolArray.count];
    
    for (ADTool *aTool in _favToolArray) {
        [_editToolArray addObject:aTool];
    }
    
    _aPopView =
    [[ADPopEditView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- TITLEVIEW_HEIGHT)
                            andParentVC:self];
    _aPopView.sortTableView.dataSource = self;
    _aPopView.sortTableView.delegate = self;

    [_aPopView.sortTableView setEditing:YES animated:YES];

    [self.appDelegate.window addSubview:_aPopView];
    
    [_aPopView.sortTableView registerNib:[UINib nibWithNibName:@"ADEditToolTableViewCell" bundle:nil]
                  forCellReuseIdentifier:reuseId];

    [UIView animateWithDuration:0.3 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _aPopView.frame =
                         CGRectMake(0, TITLEVIEW_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT- TITLEVIEW_HEIGHT);
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
    
    //save fav array
    for (ADTool *toDelTool in _toRemoveToolArray) {
        for (int i = 0; i < _editToolArray.count; i++) {
            ADTool *aTool = _editToolArray[i];
            if ([toDelTool.title isEqualToString:aTool.title]) {
                [_editToolArray removeObjectAtIndex:i];
            }
        }
    }
    
    NSMutableArray *copyTool = [[NSMutableArray alloc]initWithCapacity:0];
    //深拷贝 所有数据 删除旧的数据
    for (ADTool *aTool in _editToolArray) {
        ADTool *newTool = [[ADTool alloc]initWithTitle:aTool.title];
        [copyTool addObject:newTool];
        NSLog(@"new tool:%@", newTool.title);
    }

    [ADCollectToolDAO updateDataWithArray:copyTool];
    
    [self readToolData];
    
    [_myCollectionView reloadData];
    
    [self updateScrollFrame];
}

#pragma mark - all btn method
- (IBAction)allBtnClick:(id)sender {
    ADAllToolViewController *allToolVc = [[ADAllToolViewController alloc]init];
    [self.navigationController pushViewController:allToolVc animated:YES];
}

#pragma mark - tableview method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADEditToolTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ADTool *aTool = _editToolArray[indexPath.row];
    aCell.cellTitle.text = aTool.title;

    aCell.cellImageView.image = [UIImage imageNamed:
                                 [NSString stringWithFormat:@"%@小", aTool.title]];
//    NSLog(@"icon title:%@",title);
    [aCell.collectionBtn setSelected:YES];
    for (ADTool *actIcon in _toRemoveToolArray) {
        if ([aTool.title isEqualToString:actIcon.title]) {
            [aCell.collectionBtn setSelected:NO];
            break;
        }
    }

    [aCell.collectionBtn addTarget:self action:@selector(tapUnCollected:)
                  forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    ADTool *toMoveTool = _editToolArray[fromIndexPath.row];
    [_editToolArray removeObjectAtIndex:fromIndexPath.row];
    [_editToolArray insertObject:toMoveTool atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - unCollect action
- (void)tapUnCollected:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_aPopView.sortTableView];
    NSIndexPath *indexPath = [_aPopView.sortTableView indexPathForRowAtPoint:buttonPosition];

//    NSLog(@"row:%ld",(long)indexPath.row);
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

    ADTool *editTool = _editToolArray[indexPath.row];
    
//    NSLog(@"editTool: %p", editTool);
    if (sender.selected == YES) {
        if (_favToolArray.count -_toRemoveToolArray.count <= 5) {
            [ADHelper showToastWithText:atLeastIconNumTip
                            andFontSize:12
                               andFrame:CGRectMake(0, 130, SCREEN_WIDTH, 50)];
            
            return;
        }
        
        k.values = @[@(1.0),@(1.3),@(1.0)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
        k.calculationMode = kCAAnimationPaced;
        
        [sender.layer addAnimation:k forKey:@"favIcon"];

        [sender setSelected:NO];
        [_toRemoveToolArray addObject:editTool];
    } else {
        k.values = @[@(0.6),@(1.0),@(1.3)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [sender.layer addAnimation:k forKey:@"SHOW"];

        [sender setSelected:YES];
        [_toRemoveToolArray removeObject:editTool];
    }
}

- (void)tapDetail:(UITapGestureRecognizer *)aTap
{
    if (_aTitleView.arrowView.alpha > 0.8) {
        ADPregNotifyViewController *aNotifyVc = [[ADPregNotifyViewController alloc]init];
        [self.navigationController pushViewController:aNotifyVc animated:YES];
    }
}

#pragma mark - collectionView method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _favToolArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseId forIndexPath:indexPath];
   
    UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
    
    if (indexPath.row == 0) {
        iconImageView.image = [UIImage imageNamed:@"全部工具"];
        [titleLabel setText:@"全部工具"];
        
        return cell;
    }
    
    ADTool *cellData = _favToolArray[indexPath.row -1];
    iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@大", cellData.title]];
    [titleLabel setText:cellData.title];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH /3.0, _collectionViewHeight);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    _navHiddenAnimate = YES;
    [self jumpToVcWithIndexPath:indexPath];
}

- (void)jumpToVcWithIndexPath:(NSIndexPath *)aIndexPath
{
    NSInteger aRow = aIndexPath.row;
    if (aRow == 0) {
        //all tool vc
        ADAllToolViewController *allToolVc = [[ADAllToolViewController alloc]init];
        [self.navigationController pushViewController:allToolVc animated:YES];
    } else {
        ADTool *aTool = self.favToolArray[aRow -1];
        
        if (aTool.isWeb == YES) {
            ADHtmlToolViewController *aHtmlToolVc = [[ADHtmlToolViewController alloc]init];
            aHtmlToolVc.vcName = aTool.title;
            
            [self.navigationController pushViewController:aHtmlToolVc animated:YES];
        } else {
            ADToolRootViewController *aVc = [[NSClassFromString(aTool.myVc) alloc] init];
            @try {
                aVc.vcName = aTool.title;
            } @catch (NSException *exception) {
            }
            
            [self.navigationController pushViewController:aVc animated:YES];
        }
    }
}

- (void)resetNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - guide view
- (void)buildGuideView
{
    _guideBgView = [[ADShadowView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_HEIGHT -130 -50)];
    [_guideBgView beginBlurMaskingWithOrigin:CGPointMake(300, 300) andDiameter:0];
    
    [self.view addSubview:_guideBgView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _aTitleView.frame.size.height)];
    [button addTarget:self action:@selector(titleClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    
    _tipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 568 /2, 75)];
    _tipView.center = CGPointMake(SCREEN_WIDTH /2, 200 -130);
    _tipView.image = [UIImage imageNamed:@"孕期提醒"];
    _tipView.tag = 10;
   
    [_guideBgView addSubview:_tipView];
    
    _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 130, 10, 129. /3)];
    _arrowView.image = [UIImage imageNamed:@"箭头"];
    _arrowView.center = CGPointMake(SCREEN_WIDTH /2., _arrowView.center.y -130);
    [_guideBgView addSubview:_arrowView];
    
    _nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 85, 40)];
    
    UITapGestureRecognizer *aGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(nextAction:)];
    [_nextLabel addGestureRecognizer:aGes];
    
    _nextLabel.text = @"下一步";
    _nextLabel.textAlignment = NSTextAlignmentCenter;
    _nextLabel.backgroundColor = [UIColor whiteColor];
    _nextLabel.textColor = [UIColor title_darkblue];
    _nextLabel.clipsToBounds = YES;
    [_nextLabel.layer setCornerRadius:_nextLabel.frame.size.height /2.];
    _nextLabel.center = CGPointMake(SCREEN_WIDTH /2., SCREEN_HEIGHT - 50 -40 -130);
    _nextLabel.userInteractionEnabled = YES;
    [_guideBgView addSubview:_nextLabel];
    
    _aTitleView.userInteractionEnabled = NO;
}

-(void)nextAction:(UITapGestureRecognizer *)aGes
{
    _guideBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -48);
    
    if (_tipView.tag == 10) {
        _guideBgView.blurFilterOrigin = CGPointMake(SCREEN_WIDTH -28, 24 +130);
        _guideBgView.blurFilterDiameter = 36;
        [_guideBgView refreshBlurMask];
        
        [_arrowView removeFromSuperview];
        
        _tipView.image = [UIImage imageNamed:@"排序文字"];
        
        UIButton *allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        allButton.backgroundColor = [UIColor clearColor];
        allButton.center = CGPointMake(SCREEN_WIDTH -28, 25 +130);
        [allButton addTarget:self action:@selector(setClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_guideBgView addSubview:allButton];

        _tipView.tag = 30;
        _tipView.center = CGPointMake(_tipView.center.x, _tipView.center.y +132);
        _nextLabel.center = CGPointMake(_nextLabel.center.x, _nextLabel.center.y +132);

    } else if (_tipView.tag == 20) {
    } else {
        [_guideBgView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setHaveLauchToolTab:YES];
        _aTitleView.userInteractionEnabled = YES;
    }
}

//- (void)allClicked:(UIButton *)button
//{
//    [button removeFromSuperview];
//    [self allBtnClick:nil];
//    _tipView.tag = 20;
//    [self nextAction:nil];
//}

- (void)setClicked:(UIButton *)button
{
    [button removeFromSuperview];
    _tipView.tag = 30;
    [self showPopEditView];
    [self nextAction:nil];
}

- (void)titleClicked:(UIButton *)button
{
    [button removeFromSuperview];
    _tipView.tag = 10;
    [self tapDetail:nil];
    [self nextAction:nil];
}

@end