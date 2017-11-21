//
//  ADAllToolViewController.m
//  PregnantAssistant
//
//  Created by D on 15/3/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADAllToolViewController.h"
#import "ADHtmlToolViewController.h"
#import "ADToastCollectView.h"
#import "ADCollectToolDAO.h"
#import "ADAdWebVC.h"
#import "ADToolIconDAO.h"

static NSString *collectionStr = @"collectionId";
@implementation ADAllToolViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    for (UICollectionView *aCollectionView in self.collectionViewArray) {
        [aCollectionView reloadData];
        //NSLog(@"reload");
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    self.myTitle = @"加丁妈妈·全部工具";

    if ([[ADUserInfoSaveHelper readUserStatus]isEqualToString:@"1"]) {
        self.titleArray = @[@"孕妈参考", @"孕妈记录", @"生男生女", @"其它工具"];
        self.iconArray = [ADToolIconDAO getToolInAllToolTabIsAlreadyMom:NO];
    } else {
        self.titleArray = @[@"育儿工具",@"孕妈参考", @"孕妈记录", @"生男生女", @"其它工具"];
        self.iconArray = [ADToolIconDAO getToolInAllToolTabIsAlreadyMom:YES];
    }

    [self setupBgScrollView];
}

- (void)setupBgScrollView
{
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgScrollView];
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.titleArray.count *(150 +40) +20);
//    self.bgScrollView.contentInset = UIEdgeInsetsMake(44,0,0,0);

    [self addAllIconView];
}

- (void)addAllIconView
{
    self.collectionViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i < _titleArray.count; i++) {
        UIView *headerView = [self buiderHeaderviewWithTitle:_titleArray[i]];
        headerView.frame = CGRectMake(0, i*190, SCREEN_WIDTH, 40);
        [self.bgScrollView addSubview:headerView];
        
        // add collection view
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        UICollectionView *aCollectionView = [[UICollectionView alloc]initWithFrame:
                    CGRectMake(0, headerView.frame.origin.y +headerView.frame.size.height, SCREEN_WIDTH, 150)
                                             collectionViewLayout:layout];
        aCollectionView.showsHorizontalScrollIndicator = NO;
        aCollectionView.backgroundColor = [UIColor whiteColor];
        aCollectionView.delegate = self;
        aCollectionView.dataSource = self;
        
        aCollectionView.tag = 100 *i;
        
//        NSLog(@"colletionView tag:%d", aCollectionView.tag);
        [self.collectionViewArray addObject:aCollectionView];
        [self.bgScrollView addSubview:aCollectionView];
        
        UINib *cellNib = [UINib nibWithNibName:@"ADToolCollectionView" bundle:nil];
        [aCollectionView registerNib:cellNib forCellWithReuseIdentifier:collectionStr];
    }
}

- (UIView *)buiderHeaderviewWithTitle:(NSString *)aTitle
{
    UILabel *headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor dirty_yellow];
    headerView.text = aTitle;
    headerView.font = [UIFont systemFontOfSize:15];
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.textColor = UIColorFromRGB(0x85818D);
    
    return headerView;
}


#pragma mark - collection view method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSArray *smallArray = self.iconArray[collectionView.tag /100];
    return smallArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionStr
                                                                           forIndexPath:indexPath];
    
    NSArray *smallArray = self.iconArray[collectionView.tag /100];
    ADTool *aTool;
    UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:10];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:11];
    
    aTool = smallArray[indexPath.row];
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@大",aTool.title]];
    
//    if (aTool.isParentTool) {
//        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"育儿%@大", aTool.title]];
//    }else{
//        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@大", aTool.title]];
//    }
//    
    iconImageView.image = image;

    titleLabel.text = aTool.title;
    for (UIButton *collectBtn in cell.subviews) {
        if ([collectBtn isKindOfClass:[UIButton class]]) {
            [collectBtn removeFromSuperview];
        }
    }
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(0, 114, cell.frame.size.width, 30);
    [collectBtn setImage:[UIImage imageNamed:@"iconCollect"] forState:UIControlStateNormal];
    [collectBtn setImage:[UIImage imageNamed:@"iconCollected"] forState:UIControlStateSelected];
    
    [cell addSubview:collectBtn];
    collectBtn.tag = collectionView.tag + indexPath.row;
    
    [collectBtn addTarget:self action:@selector(touchCollect:) forControlEvents:UIControlEventTouchUpInside];
    
    [collectBtn setSelected:NO];
    BOOL isCollect = [ADCollectToolDAO hasCollectAToolWithTitle:titleLabel.text];
    if (isCollect) {
        [collectBtn setSelected:YES];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone6) {
        return CGSizeMake(SCREEN_WIDTH /3.5, 150);
    } else {
        return CGSizeMake(92, 150);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self jumpToVcWithSection:collectionView.tag/100 andRow:(long)indexPath.row];
}

- (void)QuestionnaireInvestigation
{
    ADAdWebVC *webVc = [[ADAdWebVC alloc] init];
    webVc.adUrl = @"http://api.addinghome.com/pregnantAssistant/survey";
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)jumpToVcWithSection:(NSInteger)aSec andRow:(NSInteger)aRow
{
    ADTool *aTool = self.iconArray[aSec][aRow];

//    if ([aTool.title isEqualToString:@"问卷调查"]) {
//        
//        [self QuestionnaireInvestigation];
//        return;
//    }
    
    if (aTool.isWeb == YES) {
        ADHtmlToolViewController *aHtmlToolVc = [[ADHtmlToolViewController alloc]init];
        aHtmlToolVc.vcName = aTool.title;
        [self.navigationController pushViewController:aHtmlToolVc animated:YES];
    } else {
        NSLog(@"myVc: %@", aTool.myVc);
        ADToolRootViewController *aVc = [[NSClassFromString(aTool.myVc) alloc] init];
        aVc.vcName = aTool.title;
        [self.navigationController pushViewController:aVc animated:YES];
    }
}

- (void)animationWithSender:(UIButton *)sender torstCollectView:(ADToastCollectView *)aToastView{

    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(1.0),@(1.3),@(1.0)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
    k.calculationMode = kCAAnimationPaced;
    [sender.layer addAnimation:k forKey:@"HIDE"];
    [sender setSelected:NO];
    [aToastView showUnCollectToast];
}

- (void)touchCollect:(UIButton *)sender
{
    NSInteger col = sender.tag/100;
    NSInteger row = sender.tag%100;
    ADTool *actTool = _iconArray[col][row];

    ADToastCollectView *aToastView = [[ADToastCollectView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)
                                                                     andTitle:actTool.title
                                                                 andParenView:self.view];

    if (sender.selected) {
        [ADCollectToolDAO unCollectAToolWithTitle:actTool.title onFinish:^(NSError *err) {
            if (err.code == ERRCODE_LESS_TOOL) {
                [ADHelper showToastWithText:atLeastIconNumTip andFontSize:12];
            } else {
                [self animationWithSender:sender torstCollectView:aToastView];
            }
        }];
        
    } else {
        [ADCollectToolDAO collectAToolWithTitle:actTool.title recordTime:YES];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.6),@(1.0),@(1.3)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.7),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        
        [sender.layer addAnimation:k forKey:@"SHOW"];

        [sender setSelected:YES];
        
        [aToastView showCollectToast];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end