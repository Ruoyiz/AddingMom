//
//  SCNavigationController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-17.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCNavigationController.h"
#import "SCCaptureCameraController.h"

@interface SCNavigationController ()

@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;

@end

@implementation SCNavigationController

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
    
//    _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        //iOS7，需要plist里设置 View controller-based status bar appearance 为NO
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)dealloc {
    //status bar
    if ([UIApplication sharedApplication].statusBarHidden != _isStatusBarHiddenBeforeShowCamera) {
        [[UIApplication sharedApplication] setStatusBarHidden:_isStatusBarHiddenBeforeShowCamera withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - pop
- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    BOOL shouldToDismiss = YES;
    if ([self.scNaigationDelegate respondsToSelector:@selector(willDismissNavigationController:)]) {
        shouldToDismiss = [self.scNaigationDelegate willDismissNavigationController:self];
    }
    if (shouldToDismiss) {
        [super dismissModalViewControllerAnimated:animated];
    }
}

#pragma mark - action(s)
- (void)showCameraWithParentController:(UIViewController*)parentController {
    SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
    [self setViewControllers:@[con]];
    [parentController presentViewController:self animated:YES completion:^(){
//        self.navigationBarHidden = YES;
//       _isStatusBarHiddenBeforeShowCamera = [UIApplication sharedApplication].statusBarHidden;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }];
}

#define CAN_ROTATE  0

#pragma mark -------------rotate---------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
#else
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return YES;
#else
    return NO;
#endif
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
	return UIInterfaceOrientationPortrait;
}
#endif

@end
