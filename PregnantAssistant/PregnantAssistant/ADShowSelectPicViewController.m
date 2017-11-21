//
//  ADShowSelectPicViewController.m
//  PregnantAssistant
//
//  Created by D on 14/11/7.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShowSelectPicViewController.h"
#import "ADBabyPhoto.h"
#import "ADExportImageViewController.h"
#import "UIImage-Extension.h"

@interface ADShowSelectPicViewController ()

@end

@implementation ADShowSelectPicViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择图片";
    
    self.navigationController.navigationBar.translucent = NO;
    [self setNavigationItem];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"pic:%@", self.photoArray);
    //add Select Pics
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -64)];

    [self.view addSubview:self.myScrollView];
    [self addSeletPic];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeDoneEnable)
                                                name:@"kChangeDoneEnable"
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(changeDoneUnenable)
                                                name:@"kChangeDoneUnenable"
                                              object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.tintColor = [UIColor defaultTintColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

- (void)changeDoneEnable
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)changeDoneUnenable
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)addSeletPic
{
    int row = 0;
    float tubeSize = 78.5;
    _photoImgViewArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (int i = 0; i < self.photoArray.count; i++) {
        row = i / 4;
        int col = i % 4;
//        ADBabyPhoto *aBabyPhoto = self.photoArray[i];
        UIImage *aBabyPhoto = self.photoArray[i];
        
//        float radio = aBabyPhoto.babyImg.size.height / aBabyPhoto.babyImg.size.width;
        UIImage *smallImg = [aBabyPhoto resizedImageToSize:CGSizeMake(tubeSize, tubeSize)];
        
        ADSelectPicView *aImgView =
        [[ADSelectPicView alloc]initWithFrame:CGRectMake(col*(tubeSize+ 2), 8+ row*(tubeSize*0.75 +2),
                                                         tubeSize, tubeSize)
                                       andImg:smallImg];

        [self.myScrollView addSubview:aImgView];
        [_photoImgViewArray addObject:aImgView];
    }
    
    self.myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 14 +(row+1)*(tubeSize +2));
}

- (void)setNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissVc:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(done:)];

    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)dismissVc:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(UIButton *)sender
{
    ADExportImageViewController *export = [[ADExportImageViewController alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSMutableArray *selectImgArray = [[NSMutableArray alloc]initWithCapacity:1];
    
    for (int i = 0; i < _photoImgViewArray.count; i++) {
        ADSelectPicView *aPhoto = _photoImgViewArray[i];
        if (aPhoto.isSelect) {
            ADBabyPhoto *aBabyPhoto = self.photoArray[i];
            [selectImgArray addObject:aBabyPhoto];
        }
    }
    export.selectImgArray = selectImgArray;
    [self.navigationController.navigationBar setBarTintColor:[UIColor defaultTintColor]];
    [self.navigationController pushViewController:export animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
