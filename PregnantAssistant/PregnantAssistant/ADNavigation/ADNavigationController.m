//
//  ADNavigationController.m
//  FetalMovement
//
//  Created by wangpeng on 14-3-2.
//  Copyright (c) 2014年 wang peng. All rights reserved.
//

#import "ADNavigationController.h"

@implementation ADNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"vc %@", viewController);
    if ([viewController isKindOfClass:NSClassFromString(@"PregnantAssistant.LookRootViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"ADToolIconViewController")] ||
////        [viewController isKindOfClass:NSClassFromString(@"ADMomSecretViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"ADSettingViewController")] ||
        [viewController isKindOfClass:NSClassFromString(@"ADParentToolBarVC")]) {
//
    } else {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

-(void)setHideBottomLine:(BOOL)hideBottomLine
{
    _hideBottomLine = hideBottomLine;
    UIImageView *shadow = [self findHairlineImageViewUnder:self.navigationBar];
    if (_hideBottomLine) {
        shadow.hidden = YES;
    } else {
        shadow.hidden = NO;
    }
}

//-(id)initWithRootViewController:(UIViewController *)rootViewController
//{
//    ADNavigationController *nvc = [super initWithRootViewController:rootViewController];
////    self.interactivePopGestureRecognizer.delegate = self;
////    nvc.delegate = self;
//    return nvc;
//}

//-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
