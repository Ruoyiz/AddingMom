//
//  ADBabyShotViewController.m
//  PregnantAssistant
//
//  Created by D on 14/10/31.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBabyShotViewController.h"
#import "ADPhotoTableViewCell.h"
#import "ADDiaryHeaderView.h"
#import "ADExportImageViewController.h"
#import "ADShowSelectPicViewController.h"
#import "ADShareHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ADBabyShotDAO.h"
#import "ADImageUploader.h"
#import "UIImage+ADHandleImage.h"

//#import "PregnantAssistant-Swift.h"

#define ADDBTNHEIGHT 48

static NSString *imageDateKey = @"imagePhotoDateKey";
static NSString *imageUrlArrayKey = @"ImageUrlArrayKey";

@interface ADBabyShotViewController ()

@property (nonatomic, strong) RLMNotificationToken *notification;

@end

@implementation ADBabyShotViewController

#pragma mark - view life circle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    self.myTableView.dataSource = nil;
    self.myTableView.delegate = nil;
    self.myPicker.delegate = nil;
    _aShotVc.scNaigationDelegate = nil;
    _imgCropperViewController.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([UIApplication sharedApplication].statusBarHidden == YES) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
//    [ADBabyShotDAO uploadOldDataOnFinish:^{
//        [self syncAllDataOnFinish:^(NSError *error) {
//        }];
//    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self syncAllDataOnFinish:^(NSError *error) {
        [self reloadData];
    }];
    self.myTitle = @"大肚成长记";
//    [self showSyncAlert];
    self.view.backgroundColor = [UIColor whiteColor];

    [self addBottomButton];
    
    self.allBabyPhotoRLMArray = [ADBabyShotDAO readAllData];
    
    if (self.allBabyPhotoRLMArray.count > 0) {
        [self addTableView];
        [self addLineView];
    } else {
        [self addEmptyAllTipView];
    }
}


#pragma mark － 本地读取数据
- (void)reloadData
{
    self.allBabyPhotoRLMArray = [ADBabyShotDAO readAllData];

    if (self.allBabyPhotoRLMArray.count > 0) {
        [self removeEmptyView];
        [self addTableView];
        [self addLineView];
        [self.myTableView reloadData];
    } else {
        [self.myTableView removeFromSuperview];
        [_lineView removeFromSuperview];
        [self addEmptyAllTipView];
    }
}

#pragma mark - navigation mehtod
- (void)syncMethod:(UIButton *)sender
{
    [self syncAllDataOnFinish:^(NSError *error) {
    }];
}

#pragma mark - set view
- (void)addLineView
{
    if (_lineView.superview == nil) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, 1.5, SCREEN_HEIGHT)];
        _lineView.backgroundColor = [UIColor light_green_Btn];
        [self.view addSubview:_lineView];
    }
}

- (void)addTableView
{
    if (self.myTableView.superview == nil) {
//        int naviHeight = [ADHelper getNavigationBarHeight];
        self.myTableView =
        [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -ADDBTNHEIGHT -64)];
        
        self.myTableView.delegate = self;
        self.myTableView.dataSource = self;
        
        self.myTableView.backgroundColor = [UIColor bg_lightYellow];
        self.myTableView.separatorColor = [UIColor clearColor];
        
        [self.view addSubview:self.myTableView];
    }
}

- (void)addEmptyAllTipView
{
    [self addEmptyIconView];
    [self addShotComment];
    [self addSeeEgBtn];
}

- (void)addEmptyIconView
{
    if ([ADHelper isIphone4]) {
        _emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -105)/2, 26 +64, 105, 161)];
    } else {
        _emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -105)/2, 62 +64, 105, 161)];
    }

    _emptyImgView.image = [UIImage imageNamed:@"暂无记录绿色"];
    
    [self.view addSubview:_emptyImgView];
}

- (void)addShotComment
{
    _shotCommentView = [[UIImageView alloc]initWithFrame:
                        CGRectMake(24, _emptyImgView.frame.origin.y + _emptyImgView.frame.size.height +24, 554/2, 152/2)];
    _shotCommentView.center = CGPointMake(SCREEN_WIDTH /2, _shotCommentView.center.y);
    _shotCommentView.image = [UIImage imageNamed:@"ShotComment"];

    [self.view addSubview:_shotCommentView];
}

- (void)addSeeEgBtn
{
    _showEgBtn = [[UIButton alloc]initWithFrame:
                  CGRectMake(20, _emptyImgView.frame.origin.y + _emptyImgView.frame.size.height +124,SCREEN_WIDTH -40, 44)];
    
    _showEgBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_showEgBtn setTitle:@"看看美美的实例吧" forState:UIControlStateNormal];
    _showEgBtn.backgroundColor = [UIColor whiteColor];
    [_showEgBtn setTitleColor:[UIColor font_btn_color] forState:UIControlStateNormal];
    [_showEgBtn addTarget:self action:@selector(showEg:) forControlEvents:UIControlEventTouchUpInside];
    _showEgBtn.layer.borderColor = [UIColor dark_green_Btn].CGColor;
    _showEgBtn.layer.borderWidth = 1.;
    
    [_showEgBtn setClipsToBounds:YES];
    [_showEgBtn.layer setCornerRadius:8];

    [self.view addSubview:_showEgBtn];
}

- (void)removeEmptyView
{
    [_emptyImgView removeFromSuperview];
    [_shotCommentView removeFromSuperview];
    [_showEgBtn removeFromSuperview];
}

- (void)showEg:(UIButton *)sender
{
    [self addBgView];
}

- (void)addBgView
{
    _exBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _exBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    UIScrollView *aScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    aScrollView.contentSize = CGSizeMake(300, 989/2 +32 +10);
    
    _egImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 36, SCREEN_WIDTH -20, (SCREEN_WIDTH -20)*1.6483)];
    
    NSString *imgStr =
    [NSString stringWithFormat:@"http://static.addinghome.com/static/paAsset/image/other/shotEg.png"];
    
    NSURL *imgUrl = [NSURL URLWithString:imgStr];
    [_egImgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@""] options:SDWebImageProgressiveDownload];

    [aScrollView addSubview:_egImgView];
    [_exBgView addSubview:aScrollView];
    
    [self.appDelegate.window addSubview:_exBgView];
    
    _egImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissExBgView)];
    [_egImgView addGestureRecognizer:photoTap];
}

- (void)dismissExBgView
{
    [_exBgView removeFromSuperview];
    _egImgView = nil;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)showTakePhto
{
    _aShotVc = [[SCNavigationController alloc] init];
    _aShotVc.scNaigationDelegate = self;
    [_aShotVc showCameraWithParentController:self];
}

- (void)showChoosPic
{
    self.myPicker = [[UIImagePickerController alloc]init];
    self.myPicker.delegate = self;
    [self.myPicker.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    self.myPicker.navigationBar.tintColor = [UIColor defaultTintColor];

    [self.navigationController presentViewController:self.myPicker
                                            animated:YES
                                          completion:^(void)
     {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
     }];
}

- (void)showOutPut
{
//    NSLog(@"picNum:%d", (int)self.allBabyPhotoArray.count);
    //showSelect
    if(self.allBabyPhotoRLMArray.count > 0) {
        ADShowSelectPicViewController *sPic = [[ADShowSelectPicViewController alloc]init];
        sPic.photoArray = [[NSMutableArray alloc]initWithCapacity:0];
        for (int i = 0; i < self.allBabyPhotoRLMArray.count; i++) {
            ADShotPhoto *aPhoto = self.allBabyPhotoRLMArray[i];
            UIImage *aImg = [UIImage imageWithData:aPhoto.shotImg];
            [sPic.photoArray addObject:aImg];
        }
//        sPic.photoArray = ;
        UINavigationController *aNav = [[UINavigationController alloc]initWithRootViewController:sPic];
        [self presentViewController:aNav animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"亲爱的"
                                    message:@"您还没有拍摄照片哦，拍张照片再试试吧"
                                   delegate:self
                          cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    }
}

- (void)addBottomButton
{
//    int naviHeight = [ADHelper getNavigationBarHeight];

    UIView *bottomBar = [[UIView alloc]initWithFrame:
                         CGRectMake(0, SCREEN_HEIGHT -ADDBTNHEIGHT, SCREEN_WIDTH, ADDBTNHEIGHT)];
//    bottomBar.backgroundColor = [UIColor defaultTintColor];
    bottomBar.backgroundColor = [UIColor light_green_Btn];
    
    UIButton *exportBtn = [self buildButtonWithFrame:CGRectMake(0, 4, 43, 40)
                                            normalImgStr:@"output"
                                         highlightImgStr:@""
                                          selectedImgStr:@""
                                                  action:@selector(showOutPut)];
    CGPoint exportBtnCenter = exportBtn.center;
    exportBtnCenter.x = SCREEN_WIDTH/4 -8;
    exportBtn.center = exportBtnCenter;
    
    [bottomBar addSubview:exportBtn];
    
    UIButton *takePhotoBtn = [self buildButtonWithFrame:CGRectMake(0, 4, 43, 40)
                                           normalImgStr:@"camera"
                                        highlightImgStr:@""
                                         selectedImgStr:@""
                                                 action:@selector(showTakePhto)];
    CGPoint takePhotoBtnCenter = takePhotoBtn.center;
    takePhotoBtnCenter.x = SCREEN_WIDTH/2;
    takePhotoBtn.center = takePhotoBtnCenter;

    [bottomBar addSubview:takePhotoBtn];
    
    UIButton *choosePhotoBtn = [self buildButtonWithFrame:CGRectMake(0, 4, 43, 40)
                                             normalImgStr:@"album"
                                          highlightImgStr:@""
                                           selectedImgStr:@""
                                                   action:@selector(showChoosPic)];
    [bottomBar addSubview:choosePhotoBtn];
    
    CGPoint choosePhotoBtnCenter = choosePhotoBtn.center;
    choosePhotoBtnCenter.x = SCREEN_WIDTH * 3/4 +8;
    choosePhotoBtn.center = choosePhotoBtnCenter;
    
    [self.view addSubview:bottomBar];
}

- (void)addDelBtnAndShareBtn
{
    if ([ADHelper isIphone4]) {
        _delBtn = [[UIButton alloc]initWithFrame:CGRectMake(28, SCREEN_WIDTH, 104, 35)];
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -28 -104, SCREEN_WIDTH, 104, 35)];
    } else {
        _delBtn = [[UIButton alloc]initWithFrame:CGRectMake(28, SCREEN_WIDTH-16, 104, 35)];
        _shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -28 -104, SCREEN_WIDTH -16, 104, 35)];
    }

    [_delBtn setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    
    [_biggerimageBgView addSubview:_delBtn];
    

    [_shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareImg) forControlEvents:UIControlEventTouchUpInside];
    
    [_biggerimageBgView addSubview:_shareBtn];
}

- (void)shareImg
{
    if (_sheetView.superview != nil) {
        return;
    }
    
    if ([ADHelper isIphone4]) {
        _sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 110)];
    } else {
        _sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 140)];
    }
    
    //animate move img and delbtn
    
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        if ([ADHelper isIphone4]) {
            _biggerImgView.center = CGPointMake(self.view.frame.size.width /2, 120);
            _delBtn.frame = CGRectMake(28, 256, 104, 35);
            _shareBtn.frame = CGRectMake(self.view.frame.size.width -28 -104, 256, 104, 35);
        }
    } completion:^(BOOL finished) {
    }];
    
    
    _sheetView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH/3.0, 32)];
    weiboLabel.font = [UIFont systemFontOfSize:15];
    weiboLabel.textColor = [UIColor font_Brown];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.text = @"新浪微博";
    
    weiboLabel.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:weiboLabel];
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.tag = 1;
    weiboBtn.frame = CGRectMake(0, 0, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"微博分享"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.center = CGPointMake(SCREEN_WIDTH/6, 60);
    [_sheetView addSubview:weiboBtn];
    
    UILabel *weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3.0, 100, SCREEN_WIDTH/3.0, 32)];
    weixinLabel.font = [UIFont systemFontOfSize:15];
    weixinLabel.textColor = [UIColor font_Brown];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    weixinLabel.text = @"微信好友";
    
    weixinLabel.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:weixinLabel];
    
    UILabel *pengyouLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2/3.0, 100, SCREEN_WIDTH/3.0, 32)];
    pengyouLabel.font = [UIFont systemFontOfSize:15];
    pengyouLabel.textColor = [UIColor font_Brown];
    pengyouLabel.textAlignment = NSTextAlignmentCenter;
    pengyouLabel.text = @"朋友圈";
    
    pengyouLabel.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:pengyouLabel];
    
    UIButton *weixinBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.tag = 2;
    weixinBtn.frame = CGRectMake(0, 0, 70, 70);
    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    weixinBtn.center = CGPointMake(SCREEN_WIDTH/2, 60);
    [weixinBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:weixinBtn];
    
    UIButton *pengyouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pengyouBtn.tag = 3;
    pengyouBtn.frame = CGRectMake(0, 0, 70, 70);
    [pengyouBtn setImage:[UIImage imageNamed:@"朋友圈分享"] forState:UIControlStateNormal];
    [pengyouBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    pengyouBtn.center = CGPointMake(SCREEN_WIDTH *5/6, 60);
    [_sheetView addSubview:pengyouBtn];
    
    if ([ADHelper isIphone4]) {
        weiboBtn.center = CGPointMake(SCREEN_WIDTH/3.0 -54, 44);
        weixinBtn.center = CGPointMake(SCREEN_WIDTH*2/3.0 -54, 44);
        pengyouBtn.center = CGPointMake(SCREEN_WIDTH -54, 44);
        
        weiboLabel.frame = CGRectMake(0, 80, SCREEN_WIDTH/3.0, 32);
        weixinLabel.frame = CGRectMake(SCREEN_WIDTH/3.0, 80, SCREEN_WIDTH/3.0, 32);
        pengyouLabel.frame = CGRectMake(SCREEN_WIDTH*2/3.0, 80, SCREEN_WIDTH/3.0, 32);
    }
    
    if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
    } else {
        weixinLabel.hidden = YES;
        pengyouLabel.hidden = YES;
        weixinBtn.hidden = YES;
        pengyouBtn.hidden = YES;
    }

    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if ([ADHelper isIphone4]) {
                             _sheetView.frame = CGRectMake(0, SCREEN_HEIGHT -110 -64, SCREEN_WIDTH, 110);
                         } else {
                             _sheetView.frame = CGRectMake(0, SCREEN_HEIGHT -140 -64, SCREEN_WIDTH, 140);
                         }
                     } completion:^(BOOL finished) {
                     }];
    
    [_biggerimageBgView addSubview:_sheetView];
}

- (void)shareContent:(UIButton *)sender
{
    if (sender.tag == 1) {
        //微博
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:_aShareContent.des andImg:_aShareContent.img];
    } else if (sender.tag == 2) {
        //微信
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_aShareContent.url
                                                                title:_aShareContent.title
                                                          description:_aShareContent.des
                                                            shareType:weixin_share_tpye
                                                                image:_aShareContent.img
                                                                isImg:YES];
    } else if (sender.tag == 3) {
        //朋友圈
        [[ADShareHelper shareInstance] sendLinkToWeixinWithShare_Link:_aShareContent.url
                                                                title:_aShareContent.title
                                                          description:_aShareContent.des
                                                            shareType:friend_share_type
                                                                image:_aShareContent.img
                                                                isImg:YES];
    }
}


- (UIButton *)buildButtonWithFrame:(CGRect)frame
                      normalImgStr:(NSString*)normalImgStr
                   highlightImgStr:(NSString*)highlightImgStr
                    selectedImgStr:(NSString*)selectedImgStr
                            action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)dismissBiggerView:(UITapGestureRecognizer *)sender
{
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _biggerimageBgView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_biggerimageBgView removeFromSuperview];
                     }];
}

//shareContent

#pragma mark - SCPicker delegate
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image
{
    NSLog(@"takeimage width:%f height:%f", image.size.width, image.size.height);
    [self upLoadImg:image];
    [_aShotVc dismissViewControllerAnimated:YES completion:^(void) {
        
//        [self saveImageToPhotoAlbum:image andAtIndex:0];
    }];
}

#pragma mark - UITableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.allBabyPhotoRLMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdStr = @"aPhotoCell";
    
    ADPhotoTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    if (aCell == nil) {
        aCell = [[ADPhotoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:cellIdStr];
        aCell.selectionStyle = UITableViewCellSelectionStyleNone;
        aCell.photoView.userInteractionEnabled = YES;
    }
    
    ADShotPhoto *aPhoto = self.allBabyPhotoRLMArray[indexPath.section];
    
    aCell.photoView.image = [UIImage imageWithData:aPhoto.shotImg];
    
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoView:)];
    [aCell.photoView addGestureRecognizer:photoTap];

    return aCell;
}

-   (UIView*)tableView:(UITableView*)tableView
viewForHeaderInSection:(NSInteger)section
{
    ADDiaryHeaderView *aHeaderView =
    [[ADDiaryHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    
    aHeaderView.backgroundColor = [UIColor bg_lightYellow];
    ADShotPhoto *aPhoto = self.allBabyPhotoRLMArray[section];

    //大于280 或小于刚开始怀孕的那一天 不显示孕X周
    aHeaderView.titleLabel.text = [ADHelper getCellTitleWithDate:aPhoto.shotDate];
    
    return aHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

#pragma mark - Tap PhotoView method
- (void)tapPhotoView:(UITapGestureRecognizer *)sender
{
    CGRect newRect = CGRectMake(0, 64, self.view.frame.size.width, SCREEN_HEIGHT -64);
    _biggerimageBgView = [[UIView alloc]initWithFrame:newRect];
    _biggerimageBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    //read delurl
    CGPoint location = [sender locationInView:self.view];
    
    if (CGRectContainsPoint([self.view convertRect:self.myTableView.frame fromView:self.myTableView.superview], location))
    {
        CGPoint locationInTableview = [self.myTableView convertPoint:location fromView:self.view];
        NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:locationInTableview];
            _toDelIndex = (int)indexPath.section;
    }
    
    UIImageView *cellImg = (UIImageView *)sender.view;
    _biggerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 240)];
    _biggerImgView.image = cellImg.image;
    
    if ([ADHelper isIphone4]) {
        _biggerImgView.center = CGPointMake(self.view.frame.size.width /2, 180);
    } else {
        _biggerImgView.center = CGPointMake(self.view.frame.size.width /2, 120 +38);
    }
    [_biggerimageBgView addSubview:_biggerImgView];
    
    _biggerImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBiggerView:)];
    [_biggerImgView addGestureRecognizer:photoTap];
 
    _biggerimageBgView.alpha = 0;
    [self.view addSubview:_biggerimageBgView];
    
    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                            _biggerimageBgView.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
    
    _biggerimageBgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *photoBgTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBiggerView:)];
    [_biggerimageBgView addGestureRecognizer:photoBgTap];
    
    [self addDelBtnAndShareBtn];
    [self setShareContentWithImg:_biggerImgView.image];
}

- (void)setShareContentWithImg:(UIImage *)aImg
{
    _aShareContent =
    [[ADShareContent alloc]initWithTitle:@"妈妈的肚子又被我撑大啦"
                                  andDes:@"胎宝贝最大的乐趣其实是把妈妈的肚子一天天撑大，然后在里面动个不停..."
                                  andUrl:@""
                                  andImg:aImg];
}

#pragma mark - right item method
- (void)rightItemMethod:(UIButton *)sender
{
    [super rightItemMethod:sender];
}

- (void)delImage:(UIButton *)sender
{
    //消失biggerImageView
    [self dismissBiggerView:nil];
    
//    NSLog(@"todelurl:%@",_toDelUrl);
//    NSLog(@"todelIndex:%d",_toDelIndex);
//    
    ADShotPhoto *toDelImg = self.allBabyPhotoRLMArray[_toDelIndex];
    [ADBabyShotDAO removeAPhoto:toDelImg onFinish:^{
        [self reloadData];
    }];
    
    //sync
    [self syncAllDataOnFinish:nil];
}

#pragma mark - image picker delegate method
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //get date
    NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset)
     {
         if (IOS8_OR_LATER) {
             NSDictionary* imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
             NSDictionary *tiff = [imageMetadata objectForKey:@"{TIFF}"];
             NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
             [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
             self.selectPicDate = [dateFormatter dateFromString:[tiff objectForKey:@"DateTime"]];
             if (self.selectPicDate == nil) {
                 self.selectPicDate = [asset valueForProperty:ALAssetPropertyDate];

             }
//             NSLog(@"%@",imageMetadata);
//             NSLog(@"ios 8 %@",self.selectPicDate);
         }else{
             self.selectPicDate = [asset valueForProperty:ALAssetPropertyDate];
         }
    }
            failureBlock:^(NSError *error) {
                self.selectPicDate = [NSDate date];
            }];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image.size.height > 2000 || image.size.width > 2000) {
        CGFloat rate = image.size.width > image.size.height ? 1500.0 / image.size.width : 1500.0 / image.size.height ;
        image = [image scaleImagetoScale:rate];
    }
    
    _imgCropperViewController =
    [[UzysImageCropperViewController alloc] initWithImage:image
                                             andframeSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)
                                              andcropSize:CGSizeMake(640, 480)];
    _imgCropperViewController.delegate = self;
    [picker presentViewController:_imgCropperViewController animated:YES completion:nil];
}

- (void)upLoadImg:(UIImage *)aImg
{
    NSString *imgPath =
    [NSString stringWithFormat:@"/pa/babyShot/%@.jpeg", [ADImageUploader generateImageName]];
    NSDate *date = [NSDate date];
    if (self.selectPicDate != nil) {
        date = self.selectPicDate;
    }
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@",imgPath];
    [ADBabyShotDAO savePhotoWithImage:aImg andUrl:imgUrl andDate:date isUpload:NO onFinish:^{
        [self reloadData];
    }];

    [ADImageUploader uploadWithImage:aImg toPath:imgPath
                       progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                       } completeBlock:^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
                           if (completed) {
                               [ADBabyShotDAO updatePhotoWithUrl:imgUrl toNewUrl:imgUrl isUpload:YES];
                           }
                       }];
    
    self.selectPicDate = nil;
}

#pragma mark - image cropper delegate method
- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image
{
    if (image.size.height > 2000 || image.size.width > 2000) {
        CGFloat rate = image.size.width > image.size.height ? 1500.0 / image.size.width : 1500.0 / image.size.height ;
        image = [image scaleImagetoScale:rate];
    }
    
    [self upLoadImg:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    [_myPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - save img to album method
- (void)saveImageToPhotoAlbum:(UIImage*)image andAtIndex:(NSInteger)aIndex
{
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc]init];
    //保存图片
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:ALAssetOrientationUp
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                          }];
}

#pragma mark - sync method
- (void)syncAllDataOnFinish:(void(^)(NSError *error))finishBlock
{
    [ADBabyShotDAO syncAllDataOnGetData:^(NSError *error) {
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    } onUploadProcess:^(NSError *error) {
        [self rotateSyncBtn];
    } onUpdateFinish:^(NSError *error) {
        [self stopRotateSyncBtn];
        if (error != nil) {
            if (error.code == 100) {
                self.syncBtn.hidden = YES;
            } else {
                [self setNeedUploadBtn];
            }
        }
    }];
}

@end