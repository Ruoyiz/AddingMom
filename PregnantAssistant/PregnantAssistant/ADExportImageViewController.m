//
//  ADExportImageViewController.m
//  PregnantAssistant
//
//  Created by D on 14/11/1.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADExportImageViewController.h"
//#import "MRProgressOverlayView.h"
#import "ADShareHelper.h"

@interface ADExportImageViewController ()

@end

@implementation ADExportImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.selectImgArray.count > 0) {
        _allImageArray = self.selectImgArray;
    }
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];

    self.myTitle = @"导出图片";
    [self setRightItemWithStrDone];
    
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    self.view.backgroundColor = [UIColor bg_lightYellow];
    
    [self addTip];
    
    self.aLibrary = [[ALAssetsLibrary alloc] init];
    
    [self addImagesAndBtns];
    
    //default select
    [self defaultSelectColumn];
    
    [self addSelectBtns];
}

- (void)defaultSelectColumn
{
    _selectedStyle = columnStyle;
    [self addBorderAtView:_columnView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)addSelectBtns
{
    _columnSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tubeSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    int selBtnSize = 32;
    if ([ADHelper isIphone4]) {
        _columnSelBtn.frame = CGRectMake(256, 124, selBtnSize, 25);
        _tubeSelBtn.frame = CGRectMake(256, 300, selBtnSize, 25);
    } else {
        _columnSelBtn.frame = CGRectMake(256, 136, selBtnSize, 25);
        _tubeSelBtn.frame = CGRectMake(256, 328, selBtnSize, 25);
    }
    [_columnSelBtn setImage:[UIImage imageNamed:@"export_Unselect"] forState:UIControlStateNormal];
    [_columnSelBtn setImage:[UIImage imageNamed:@"export_Select"] forState:UIControlStateSelected];
    [_columnSelBtn addTarget:self action:@selector(selectColumnBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tubeSelBtn setImage:[UIImage imageNamed:@"export_Unselect"] forState:UIControlStateNormal];
    [_tubeSelBtn setImage:[UIImage imageNamed:@"export_Select"] forState:UIControlStateSelected];
    [_tubeSelBtn addTarget:self action:@selector(selectTubeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [_columnSelBtn setSelected:YES];
    
    [self.view addSubview:_columnSelBtn];
    [self.view addSubview:_tubeSelBtn];
}

- (void)selectColumnBtn:(UIButton *)sender
{
    [sender setSelected:YES];
    [_tubeSelBtn setSelected:NO];
    //change select border
    [self addBorderAtView:_columnView];
    //change style
    _selectedStyle = columnStyle;
}

- (void)selectTubeBtn:(UIButton *)sender
{
    [sender setSelected:YES];
    [_columnSelBtn setSelected:NO];
    //change select border
    [self addBorderAtView:_tubeView];
    //change style
    _selectedStyle = tubeStyle;
}

- (void)addTip
{
    UILabel *tip = [[UILabel alloc]initWithFrame:CGRectMake(0, 16, SCREEN_WIDTH, 20)];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.font = [UIFont systemFontOfSize:14];
    tip.textColor = [UIColor font_Brown];
    tip.text = @"选择您想要的模版";
    [self.view addSubview:tip];
}

- (void)addImagesAndBtns
{
    _columnView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 112, 150)];
    _columnView.image = [UIImage imageNamed:@"竖排"];
    [self.view addSubview:_columnView];
    
    _columnView.userInteractionEnabled = YES;
    UITapGestureRecognizer *columnTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectColumn:)];
    [_columnView addGestureRecognizer:columnTap];
    
    _tubeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 133, 133)];
    _tubeView.image = [UIImage imageNamed:@"九宫"];
    [self.view addSubview:_tubeView];
    
    _tubeView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tubeTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTube:)];
    [_tubeView addGestureRecognizer:tubeTap];
    
    if ([ADHelper isIphone4]) {
        _columnView.center = CGPointMake(160, 16 +20 +24 +150/2);
        _tubeView.center = CGPointMake(160, 16 +20 +24 +150 +36 +133/2);
    } else {
        _columnView.center = CGPointMake(160, 16 +20 +40 +150/2);
        _tubeView.center = CGPointMake(160, 16 +20 +40 +150 +52 +133/2);
    }
}

- (void)selectTube:(UITapGestureRecognizer *)aTap
{
    [self addBorderAtView:aTap.view];
    _selectedStyle = tubeStyle;
    [_tubeSelBtn setSelected:YES];
    [_columnSelBtn setSelected:NO];
}

- (void)selectColumn:(UITapGestureRecognizer *)aTap
{
    [self addBorderAtView:aTap.view];
    _selectedStyle = columnStyle;
    [_tubeSelBtn setSelected:NO];
    [_columnSelBtn setSelected:YES];
}

- (void)addBorderAtView:(UIView *)originView
{
    [_borderView removeFromSuperview];
    CGFloat borderWidth = 2.0f;
    
    _borderView =
    [[UIView alloc]initWithFrame:CGRectInset(originView.frame, -(4 +borderWidth), -(4 +borderWidth))];
    _borderView.backgroundColor = [UIColor clearColor];
    _borderView.layer.borderColor = UIColorFromRGB(0xb5a8a0).CGColor;
    _borderView.layer.borderWidth = borderWidth;
    [self.view addSubview:_borderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemMethod:(UIButton *)sender
{
    if (_finishBg.superview != nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self addFinishView];
        
        //export
        [self exportImgWithStyle:_selectedStyle];
    }
}

- (void)addFinishView
{
    CGRect newRect = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT -64);
    _finishBg = [[UIView alloc]initWithFrame:newRect];
    _finishBg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    _finishBg.alpha = 0;
    [self.view addSubview:_finishBg];
    
    UIImageView *okImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 87, 87)];
    okImgView.image = [UIImage imageNamed:@"ok"];
    okImgView.center = CGPointMake(self.view.frame.size.width /2, 24 +87/2.0);
    [_finishBg addSubview:okImgView];
    
    UILabel *tipLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, 80)];
    tipLabel.font = [UIFont systemFontOfSize:22];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.numberOfLines = 2;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.text = @"亲，导出成功\n请在照片中查看";
    [_finishBg addSubview:tipLabel];
    
    UIButton * shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 104, 35)];
    shareBtn.center = CGPointMake(self.view.frame.size.width /2.0, 240);

    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareContent) forControlEvents:UIControlEventTouchUpInside];

    [_finishBg addSubview:shareBtn];

    [UIView animateWithDuration:0.2 delay:0.05
         usingSpringWithDamping:1 initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _finishBg.alpha = 1;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)shareContent
{
    if (_sheetView.superview != nil) {
        return;
    }
    
    if ([ADHelper isIphone4]) {
        _sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 110)];
    } else {
        _sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 140)];
    }
    
    _sheetView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    UILabel *weiboLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH/3.0, 32)];
    weiboLabel.font = [UIFont systemFontOfSize:15];
    weiboLabel.textColor = [UIColor font_Brown];
    weiboLabel.textAlignment = NSTextAlignmentCenter;
    weiboLabel.text = @"新浪微博";
    
    weiboLabel.backgroundColor = [UIColor clearColor];
    [_sheetView addSubview:weiboLabel];
    
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
    
    UIButton *weiboBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weiboBtn.tag = 1;
    weiboBtn.frame = CGRectMake(0, 0, 70, 70);
    [weiboBtn setImage:[UIImage imageNamed:@"微博分享"] forState:UIControlStateNormal];
    [weiboBtn addTarget:self action:@selector(shareContent:) forControlEvents:UIControlEventTouchUpInside];
    weiboBtn.center = CGPointMake(SCREEN_WIDTH/6.0, 60);
    [_sheetView addSubview:weiboBtn];
    
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
    
    if([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
    } else {
        weixinLabel.hidden = YES;
        pengyouLabel.hidden = YES;
        weixinBtn.hidden = YES;
        pengyouBtn.hidden = YES;
    }

    
    if ([ADHelper isIphone4]) {
        weiboBtn.center = CGPointMake(SCREEN_WIDTH/3.0 -54, 44);
        weixinBtn.center = CGPointMake(SCREEN_WIDTH*2/3.0 -54, 44);
        pengyouBtn.center = CGPointMake(SCREEN_WIDTH -54, 44);
        
        weiboLabel.frame = CGRectMake(0, 80, SCREEN_WIDTH/3.0, 32);
        weixinLabel.frame = CGRectMake(SCREEN_WIDTH/3.0, 80, SCREEN_WIDTH/3.0, 32);
        pengyouLabel.frame = CGRectMake(SCREEN_WIDTH*2/3.0, 80, SCREEN_WIDTH/3.0, 32);
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

    [_finishBg addSubview:_sheetView];
}

- (void)shareContent:(UIButton *)sender
{
    [self setShareContentWithImg:_finalImage];
    if (sender.tag == 1) {
        //微博
        [[ADShareHelper shareInstance] sendWeiboShareWithDes:_aShareContent.des andImg:_aShareContent.img];
    } else if (sender.tag == 2) {
        //微信
        NSLog(@"url:%@,title:%@,des:%@,iamge:%@",_aShareContent.url,_aShareContent.title,_aShareContent.des,_aShareContent.img);

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

- (void)setShareContentWithImg:(UIImage *)aImg
{
    _aShareContent =
    [[ADShareContent alloc]initWithTitle:@"大肚子是怎样炼成的？看这里！"
                                  andDes:@"看着肚子一天天长大是很辛苦哒，其实大肚历史也能汇成一幅精美的图画，谁说大肚了就不能拍照啦？！"
                                  andUrl:@""
                                  andImg:aImg];
}

- (void)exportImgWithStyle:(ExportImageStyle)aStyle
{
    switch (aStyle) {
        case columnStyle: {
            [self combineImageWichColumn];
            [self saveImage];
            break;
        }
        case tubeStyle: {
            [self combineImageWichTube];
            [self saveImage];
            break;
        }

        default:
            break;
    }
}

- (void)combineImageWichColumn
{
    UIGraphicsBeginImageContext(CGSizeMake(640 +48, (480+24)*_allImageArray.count +24));
    for (int i = 0; i < _allImageArray.count; i++) {
        UIImage *aPhoto = _allImageArray[i];
        [aPhoto drawInRect:CGRectMake(24, 24 +(480+24)*i, 640, 480)];
    }
    
    self.finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)combineImageWichTube
{
    int rowCnt = (int)_allImageArray.count /3;
    if (_allImageArray.count %3 != 0) {
        rowCnt += 1;
    }
    int weight = 0;
    if (_allImageArray.count <3) {
        weight = (int)_allImageArray.count* (640+24) +24;
    } else if (_allImageArray.count == 4) {
        weight = 2* (640+24) +24;
    } else {
        weight = 3* (640+24) +24;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(weight, (480 +24)*rowCnt +24));
    if (_allImageArray.count == 4) {
        for (int i = 0; i < _allImageArray.count; i++) {
            UIImage *aPhoto = _allImageArray[i];
            int row = i / 2;
            int col = i % 2;
            [aPhoto drawInRect:CGRectMake(24 +(640 +24)*col, 24 +(480+24)*row, 640, 480)];
        }
    } else {
        for (int i = 0; i < _allImageArray.count; i++) {
//            ADBabyPhoto *aPhoto = _allImageArray[i];
            UIImage *aPhoto = _allImageArray[i];
            int row = i / 3;
            int col = i % 3;
            [aPhoto drawInRect:CGRectMake(24 +(640 +24)*col, 24 +(480+24)*row, 640, 480)];
        }
    }
    
    self.finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)saveImage
{
    [_aLibrary saveImage:_finalImage toAlbum:@"大肚成长记" completion:^(NSURL *assetURL, NSError *error) {
    } failure:nil];
}

@end