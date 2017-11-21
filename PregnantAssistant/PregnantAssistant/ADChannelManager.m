//
//  ADChannelManager.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/5/22.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADChannelManager.h"
#import "ADNavigationController.h"
#import "ADToolIconViewController.h"
#import "ADMomSecretViewController.h"
#import "ADSettingViewController.h"
#import "ADParentToolBarVC.h"
#import "ADMomLookNetwork.h"
#import "PregnantAssistant-Swift.h"

@implementation ADChannelManager

static ADChannelManager *sharedChannelManager = nil;

+ (ADChannelManager *)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedChannelManager = [[ADChannelManager alloc] init];
    });
    return sharedChannelManager;
}

- (void)setCustomBar
{
    [[UITabBarItem appearance] setTitleTextAttributes:
     @{NSFontAttributeName: [UIFont systemFontOfSize:9.0],
       NSForegroundColorAttributeName: [UIColor darkGrayColor]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x27c3b0)}
                                             forState:UIControlStateSelected];
    
    ADNavigationController *c1 = [[ADNavigationController alloc] initWithRootViewController:
                                  [[LookRootViewController alloc] init]];
    
    
    c1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"看看"
                                                  image:[[UIImage imageNamed:@"first_normal"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          selectedImage:[[UIImage imageNamed:@"first_selected"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    c1.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -4.0);

    NSMutableArray *VCArray = [NSMutableArray array];
    [VCArray addObject:c1];
    
    ADNavigationController *c2 =
    [[ADNavigationController alloc] initWithRootViewController:[[ADToolIconViewController alloc]init]];
    c2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"工具"
                                                  image:[[UIImage imageNamed:@"second_normal"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          selectedImage:[[UIImage imageNamed:@"second_selected"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    c2.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -4.0);

    [VCArray addObject:c2];
    
    ADNavigationController *c4 =
    [[ADNavigationController alloc] initWithRootViewController:[[ADSettingViewController alloc] init]];
    c4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"更多"
                                                  image:[[UIImage imageNamed:@"fourth_normal"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                          selectedImage:[[UIImage imageNamed:@"fourth_selected"]
                                                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    c4.tabBarItem.titlePositionAdjustment = UIOffsetMake(0.0, -4.0);

    
    [VCArray addObject:c4];
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    myApp.customTabBar = [[UITabBarController alloc]init];
    
//    myApp.customTabBar.delegate = self;
    
    myApp.customTabBar.viewControllers = VCArray;
    
    [self setCustomTabBarGestureRecognizer];
}

- (void)setCustomTabBarGestureRecognizer
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];

    CGFloat count = 3;
    CGFloat space = 20;
    
    CGFloat barViewWidth = (SCREEN_WIDTH - (count - 1.0) * space * 1.5 - 2*space) / count;
    for (int i = 0; i < count; i++) {
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(space + (1.5 * space + barViewWidth) * i, 0, barViewWidth, 49)];
        barView.tag = 100 + i;
        [myApp.customTabBar.tabBar addSubview:barView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
        tap.numberOfTapsRequired = 1;
        [barView addGestureRecognizer:tap];
        
        if( i == 0){
            UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
            [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
            [barView addGestureRecognizer:doubleTapGestureRecognizer];
        }
        //[tap requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    }
}

- (void)viewTaped:(UITapGestureRecognizer *)tapGes
{
    NSInteger index = tapGes.view.tag - 100;
    [self setSelectVCAtIndex:index];
}

- (void)doubleTap:(UITapGestureRecognizer *)tapGes
{
    NSInteger index = tapGes.view.tag - 100;
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myApp.customTabBar.selectedIndex != index) {
        [self setSelectVCAtIndex:index];
    }else{
        if (index == 0) {
            NSLog(@"需要刷新");
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshLookDataNoti object:nil];
        }
    }
}

- (void)setSelectVCAtIndex:(NSInteger)index
{
    ADAppDelegate *myApp = (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabBarController = myApp.customTabBar;
    tabBarController.selectedIndex = index;
    
    if (index == 1)
    {
        [MobClick event:tab_gongju];
        ADNavigationController *nc = tabBarController.viewControllers[1];
        ADAppDelegate *myappdelegate = APP_DELEGATE;
        if ([myappdelegate.userStatus isEqualToString:@"1"]) {
            nc.viewControllers = @[[[ADToolIconViewController alloc] init]];
            
        } else {
            nc.viewControllers = @[[[ADParentToolBarVC alloc]init]];
        }
        
    } else if (tabBarController.selectedIndex == 0){
        //        [self changeMomLookChannels];
        [MobClick event:tab_kankan];
    } else if (tabBarController.selectedIndex == 2){
        [MobClick event:tab_gengduo];
    }
}

- (void)getChannelIds
{
    [ADMomLookNetwork getChannelListSuccess:^(id responseObject) {
        NSMutableArray *myMutableArr = [NSMutableArray arrayWithArray:responseObject];
        NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]];
        [myMutableArr sortUsingDescriptors:sortDescriptors];
        
        NSMutableArray *channelIds = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *channelNames = [NSMutableArray arrayWithCapacity:1];
        for (int i=0; i<[myMutableArr count]; i++) {
            [channelIds addObject:[[myMutableArr objectAtIndex:i] objectForKey:@"channelId"]];
            [channelNames addObject:[[myMutableArr objectAtIndex:i] objectForKey:@"name"]];
        }
        
        if ([channelIds count] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:channelIds] forKey:kMomLookChannelIds];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([channelNames count] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:channelNames] forKey:kMomLookChannelNames];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        

    } failure:^(NSString *errorMessage) {
       
    }];
}

//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    
//}


@end
