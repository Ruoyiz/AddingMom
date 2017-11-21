//
//  ADBaseViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-15.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "UIImage+Tint.h"

#define ITEM_EDGE 4

@interface ADBaseViewController (){
    UIButton *_aTitleButton;
}

@end

@implementation ADBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = APP_DELEGATE;

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(reachabilityChanged:)
//                                                 name:kReachabilityChangedNotification
//                                               object:nil];
    
//    _reachable = YES;
    self.view.backgroundColor = [UIColor base_BackgroundColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.view.backgroundColor = [UIColor base_BackgroundColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:YES];
//}

//- (void)reachabilityChanged:(NSNotification*)note
//{
//    Reachability* reach = [note object];
//    
//    if ([reach isReachable]) {
//        NSLog(@"reachable");
//        _reachable = YES;
//    } else {
//        NSLog(@"notreachable");
//        _reachable = NO;
//    }
//}

- (void)setMyTitle:(NSString *)myTitle
{
    _myTitle = myTitle;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 42)];
    [label setFont:[UIFont ADTraditionalFontWithSize:15]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:UIColorFromRGB(0x333333)];
    [label setTextAlignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = label;
    
    [label setText:_myTitle];
}


- (void)setLeftBackItemWithImage:(UIImage *)aImage
                  andSelectImage:(UIImage *)sImage
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (aImage) {
        [backButton setImage:aImage forState:UIControlStateNormal];
    }else{
        [backButton setImage:[UIImage imageNamed:@"navBack"] forState:UIControlStateNormal];
    }
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton addTarget:self action:@selector(leftItemMethod) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 24, 24)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)leftItemMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setRightItemWithImage:(UIImage *)aImage
               andSelectImage:(UIImage *)sImage
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:aImage forState:UIControlStateNormal];
    [button setImage:sImage forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 24, 24 + ITEM_EDGE)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, ITEM_EDGE, 0, -ITEM_EDGE)];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightItemWithStrEdit
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 44, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, -14)];
    [button setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightItemWithStrDone
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 44, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 14, 0, -14)];
    [button setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightItemWithStrPublish
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 44, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 12, 0, -12)];
    [button setTitleColor:[UIColor btn_green_bgColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightItemWithTxt:(NSString *)aStr
                   andColor:(UIColor *)aColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:aStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 56, 30)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    [button setTitleColor:aColor forState:UIControlStateNormal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)setRightItemWithImgCollect
{
    UIImage *aImage = [UIImage imageNamed:@"naviCollect"];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:aImage forState:UIControlStateNormal];

    [backButton addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 27, 27 + 6)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setRightItemWithImgCollectAndSync
{
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"naviCollect"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"naviCollected"] forState:UIControlStateSelected];
    [_collectBtn addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn setFrame:CGRectMake(0, 0, 27, 27)];
    
    self.syncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.syncBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    
    if ([[NSUserDefaults standardUserDefaults]addingToken].length == 0) {
        self.syncBtn.hidden = YES;
    }
    
    [_syncBtn addTarget:self action:@selector(syncMethod:) forControlEvents:UIControlEventTouchUpInside];
    [_syncBtn setFrame:CGRectMake(0, 0, 20, 20)];
    
    UIBarButtonItem *negativeSpacer =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil action:nil];
    negativeSpacer.width = -8;
    
    UIBarButtonItem *negativeSpacer2 =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                  target:nil action:nil];
    negativeSpacer2.width = 16;
    
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,
                                                [[UIBarButtonItem alloc] initWithCustomView:_collectBtn],
                                                negativeSpacer2,
                                                [[UIBarButtonItem alloc] initWithCustomView:_syncBtn]];
}

- (void)rotateSyncBtn
{
    [self.syncBtn setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    CABasicAnimation *fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.delegate = self;
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    fullRotation.duration = 2.0;
    fullRotation.repeatCount = HUGE_VALF;
    [_syncBtn.layer addAnimation:fullRotation forKey:@"360"];
}

- (void)setNeedUploadBtn
{
    [self.syncBtn setImage:[UIImage imageNamed:@"need load"] forState:UIControlStateNormal];
    [_syncBtn.layer removeAllAnimations];
}

- (void)stopRotateSyncBtn
{
    [_syncBtn.layer removeAllAnimations];
    NSLog(@"animation");
//    [UIView animateWithDuration:0.3 delay:0.05
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//    self.syncBtn.alpha = 0;
//    self.syncBtn.hidden = YES;
//                         self.syncBtn.alpha = 1;
//    } completion:^(BOOL finished) {
//        
//    }];
}

- (void)setRightItemWithAddHeightWeight{

    UIImage *aImage = [UIImage imageNamed:@"addSecert"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:aImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 20, 23 + 4)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

}


- (void)setRightItemSecertShare
{
    UIImage *aImage = [UIImage imageNamed:@"secertShare"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:aImage forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 20, 23 + 4)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setRightItemWithImgFav
{
    UIImage *aImage = [UIImage imageNamed:@"naviCollected"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:aImage forState:UIControlStateNormal];

    [backButton addTarget:self action:@selector(rightItemMethod:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 27, 27 + 6)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 6, 0, -6)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)setZFLeftBackItemWithImage:(UIImage *)aImage
                    andSelectImage:(UIImage *)sImage
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftItemMethod) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 24, 24 +4)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)rightItemMethod:(UIButton *)sender
{
}

- (void)favAVideo:(UIButton *)sender
{
}

- (void)syncMethod:(UIButton *)sender
{
}

- (void)back
{
    [self leftItemMethod];
}


- (void)setStyleNaviWithTitle:(NSString *)aTitle
                     andTrans:(BOOL)trans
                   andBgColor:(UIColor *)aBgColor
                andTitleColor:(UIColor *)aTitleColor
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    _selfNavBar = [[UINavigationBar alloc] initWithFrame:
                   CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [_selfNavBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];

    [_selfNavBar setTranslucent:trans];
    [_selfNavBar setBarTintColor:aBgColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 42)];
    [label setFont:[UIFont fontWithName:@"RTWSYueGoTrial-Light" size:16.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:aTitleColor];
    
    [label setText:aTitle];
    [label setTextAlignment:NSTextAlignmentCenter];

    _selfNaviItem = [[UINavigationItem alloc] init];
    _selfNaviItem.titleView = label;
    [_selfNavBar setItems:@[_selfNaviItem]];

    [self.view addSubview:_selfNavBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"naviBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, 24, 24 +4)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
    _selfNaviItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

#pragma mark - 设置title
//设置导航的自定义titleView居中
- (void)setADCustomTitleViewWithTitle:(NSString *)title
{
    _aTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [_aTitleButton setTitle:title forState:UIControlStateNormal];
    [_aTitleButton setTitleColor:[UIColor title_darkblue] forState:UIControlStateNormal];
    [_aTitleButton addTarget:self action:@selector(titleViewClicked) forControlEvents:UIControlEventTouchUpInside];
    _aTitleButton.titleLabel.font = [UIFont ADTitleFontWithSize:16];
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    CGRect frame;
    
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    maxWidth += 40;
//    frame = _aTitleButton.frame;
    CGFloat width = SCREEN_WIDTH - maxWidth * 2;
    
    frame = CGRectMake(0, 0, width, 44);
    _aTitleButton.frame = frame;
    
    self.navigationItem.titleView = _aTitleButton;
}

- (void)addLoginBtnIsSecert:(BOOL)isSecert
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self.navigationController.navigationBar.translucent == YES) {
        frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
    
    _loginView = [[UIView alloc]initWithFrame:frame];
    
    _loginView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, 24, SCREEN_WIDTH -32, 1)];
    line.backgroundColor = [UIColor defaultTintColor];
    [_loginView addSubview:line];
    
    UIImageView *handView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 35, SCREEN_HEIGHT *0.33 -25 -64)];
    [handView setImage:[[UIImage imageNamed:@"refresh_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 100, 0)]];
    handView.center = CGPointMake(SCREEN_WIDTH /2, handView.center.y);
    
    [_loginView addSubview:handView];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake(0, 0, 111, 111);
    weixinBtn.center = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT*(1- 0.56) -111/2);
    [weixinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    
    [weixinBtn addTarget:self action:@selector(loginWechatAccount) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:weixinBtn];
    
    NSString *imageName = @"登陆微信";
    if (isSecert) {
        imageName = @"登陆秘密";
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageHeight = image.size.height;
    CGFloat imageWidth = image.size.width;
    
    UIImageView *label = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    label.center = CGPointMake(SCREEN_WIDTH /2, SCREEN_HEIGHT*(1 -0.3) -141/6);
    label.image = image;
    [_loginView addSubview:label];
    
    [self.view addSubview:_loginView];
}

- (void)loginWechatAccount
{
}

#pragma mark - title 被点击后的响应
- (void)titleViewClicked
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end