//
//  ADWriteSecretViewController.m
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADWriteSecretViewController.h"
#import "ADImageUploader.h"
#import "ADMomSecertDAO.h"
#import "UIImage+ADHandleImage.h"

@interface ADWriteSecretViewController ()

@end

@implementation ADWriteSecretViewController

-(void)dealloc
{
    self.myTextView.delegate = nil;
    self.locationManager.delegate = nil;
    self.aImagePicker.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myTitle = @"发布秘密";
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    
    [self setRightItemWithStrPublish];
    
    [self addScrollView];
    [self addTextField];
    [self getLocation];

    _imgArray = [ADMomSecertDAO readImage];
    
    for (ADMomSecertImage *image in _imgArray) {
        NSLog(@"image Index %d",image.index);
    }
    [self addAddImageBtn];
    
    _unUploadImgs = [[NSMutableArray alloc]initWithCapacity:0];

    _isUploadImg = NO;
}

- (void)addScrollView
{
    _scrollViewBg = [[UIScrollView alloc]initWithFrame:
                     CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollViewBg.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT +36);
    _scrollViewBg.backgroundColor = [UIColor bg_lightYellow];
    [self.view addSubview:_scrollViewBg];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
    //[SVProgressHUD dismiss];
    [ADToastHelp dismissSVProgress];
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)back
{
    NSString *draft = [self.myTextView.text copy];
    NSRange aRange =
    [draft rangeOfString:[NSString stringWithFormat:@"#%@# ",_topicString]];
    //NSLog(@"aRange:%lu", (unsigned long)aRange.length);
    if (aRange.length > 0) {
       draft = [draft stringByReplacingCharactersInRange:aRange withString:@""];
    }
    
    [[NSUserDefaults standardUserDefaults] setAddingMomSecret:draft];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [ADLocationManager shareLocationManager].location.longitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    [ADLocationManager shareLocationManager].location.latitude = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    [manager stopUpdatingLocation];
}

- (void)addAddImageBtn
{
    NSMutableArray *finalImgArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i =0; i < _imgArray.count; i++) {
        [finalImgArray addObject:_imgArray[i]];
    }
    _addImageView = [[ADAddSecertImageView alloc]initWithFrame:CGRectZero
                                                         andPhotos:finalImgArray
                                                       andParentVC:self];
    _addImageView.delegate = self;

    [self.scrollViewBg addSubview:_addImageView];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize =
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    /* 通过 kbSize.height
     * 就可以得到屏幕键盘的高度，这样就可以据以调整其他的屏幕元素了 */
    
    if ([ADHelper isIphone4]) {
        self.myTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kbSize.height -64 -72);
    } else {
        self.myTextView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kbSize.height -64 -128);
    }
    
    if ([ADHelper isIphone4]) {
        _addImageView.frame = CGRectMake(0, SCREEN_HEIGHT - kbSize.height -64 -68, SCREEN_WIDTH, 68);
    } else {
        _addImageView.frame = CGRectMake(4, SCREEN_HEIGHT - kbSize.height -64 -128, SCREEN_WIDTH, 160);
    }
}

- (void)addNewImage
{
    [self.myTextView resignFirstResponder];
    NSArray *array = [NSArray arrayWithObjects:@"拍照", @"从手机相册中选取", nil];
    
    ADActionSheetView *actionSheet = [[ADActionSheetView alloc] initWithTitleArray:array cancelTitle:@"取消"actionSheetTitle:@"请选择照片"];
    actionSheet.delegate = self;
    [actionSheet show];
}

//- (void)addAImg:(UIButton *)sender
//{
//    [self.myTextView resignFirstResponder];
//    NSArray *array = [NSArray arrayWithObjects:@"拍照", @"从手机相册中选取", nil];
//    
//    ADActionSheetView *actionSheet = [[ADActionSheetView alloc] initWithTitleArray:array cancelTitle:@"取消"actionSheetTitle:@"请选择照片"];
//    actionSheet.delegate = self;
//    [actionSheet show];
//}

- (void)tapPhotoView:(UITapGestureRecognizer *)sender
{
    _toDelTag = (int)sender.view.tag;
//    NSLog(@"to del tag %d,%d",sender.view.tag,self.imgArray.count);
    if (_toDelTag -10 < _imgArray.count) {
        [self.myTextView resignFirstResponder];
        //add Bigger bgView
        CGRect newRect = CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT);
        _photoBgView = [[UIView alloc]initWithFrame:newRect];
        _photoBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        
        //addBigger ScrollView
        UIScrollView *bigScrollView = [[UIScrollView alloc]initWithFrame:
                                       CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT -80)];
        
        //add bigger image
        UIImageView *biggerImgView = [[UIImageView alloc]init];
        ADMomSecertImage *aImg = _imgArray[_toDelTag -10];
        
        //UIImageView *imageView = (UIImageView *)sender.view;
        biggerImgView.image = [UIImage imageWithData:aImg.shotImg];
        
        //    NSLog(@"w:%f h:%f", biggerImgView.image.size.width, biggerImgView.image.size.height);
        float radio = biggerImgView.image.size.height / biggerImgView.image.size.width;
        
        if ([ADHelper isIphone4]) {
            biggerImgView.frame = CGRectMake(10, 0, (SCREEN_WIDTH -20), (SCREEN_WIDTH -20) *radio);
        } else {
            biggerImgView.frame = CGRectMake(10, 0, (SCREEN_WIDTH -20), (SCREEN_WIDTH -20) *radio);
        }
        
        biggerImgView.userInteractionEnabled = YES;
        
        bigScrollView.contentSize = CGSizeMake(SCREEN_WIDTH -20, (SCREEN_WIDTH -20) *radio);
        
        [bigScrollView addSubview:biggerImgView];
        
        UITapGestureRecognizer *biggerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBiggerView)];
        [biggerImgView addGestureRecognizer:biggerTap];
        
        [_photoBgView addSubview:bigScrollView];
        [self.appDelegate.window addSubview:_photoBgView];
        
        //add delBtn
        [self addDelBtn];
    }
}

- (void)addDelBtn
{
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 46, 28, 44, 32)];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_photoBgView addSubview:delBtn];
}

- (void)delImage:(UIButton *)sender
{
    [self dismissBiggerView];
    
    ADMomSecertImage *toDelImg = self.imgArray[_toDelTag -10];
    
    [ADMomSecertDAO removeImage:toDelImg];
    
    _imgArray = [ADMomSecertDAO readImage];

    [_addImageView removePhotoWithIndex:_toDelTag];
    
}

- (void)dismissBiggerView
{
    [_photoBgView removeFromSuperview];
    [self.myTextView becomeFirstResponder];
}

- (void)showTakePhotoView
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            [self.myTextView becomeFirstResponder];
        }];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"亲爱的" message:@"你的设备没有摄像头" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showSelectPhotoView
{
    self.aImagePicker = [[UIImagePickerController alloc]init];
    self.aImagePicker.delegate = self;
    [self.aImagePicker.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.aImagePicker.navigationBar.tintColor = [UIColor defaultTintColor];
    
    [self.navigationController presentViewController:self.aImagePicker
                                            animated:YES
                                          completion:^(void)
     {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
         [self.myTextView becomeFirstResponder];

     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"select image%@",info);
    [self setRightItemWithIndicator];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (image.size.height > 1500 || image.size.width > 1500) {
        CGFloat rate = image.size.width > image.size.height ? 1500.0 / image.size.width : 1500.0 / image.size.height ;
        image = [image scaleImagetoScale:rate];
    }
    
    NSLog(@"...... %f,%f",image.size.width ,image.size.height);
    if (image == nil) {
        NSData *data = [NSData dataWithContentsOfURL:info[UIImagePickerControllerReferenceURL]];
        image = [UIImage imageWithData:data];
        
        [self dismissViewControllerAnimated:YES completion:^(void){
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            [self.myTextView becomeFirstResponder];
        }];
        return;
    }

    
    [self replacePhotoViewImage:image];
    
    //TODO
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [NSThread detachNewThreadSelector:@selector(useImage:) toTarget:self withObject:image];
}

- (void)useImage:(UIImage *)image {
    
    @autoreleasepool {
        // Create a graphics image context
        [self dismissViewControllerAnimated:YES completion:^{
            CGSize newSize = CGSizeMake(320, 320 *(image.size.height /image.size.width));
            UIGraphicsBeginImageContext(newSize);
            // Tell the old image to draw in this new context, with the desired
            // new size
            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
            // Get the new image from the context
            UIImage* uploadImg = UIGraphicsGetImageFromCurrentImageContext();
            // End the context
            UIGraphicsEndImageContext();

            //replace Img
//            [self replacePhotoViewImage:image];
            
            [self uploadImg:uploadImg];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.myTextView becomeFirstResponder];
    }];
}

- (void)replacePhotoViewImage:(UIImage *)aImage
{
    [_addImageView addAPhotoView:aImage];
}

- (void)rightItemMethod:(UIButton *)sender
{
    if ([ADHelper getToInt:self.myTextView.text] < 6) {
        [ADHelper showToastWithText:@"字数太少，再加点儿吧"];
    } else if ([ADHelper getToInt:self.myTextView.text] > 300) {
        [ADHelper showToastWithText:@"最大支持300字哦"];
    } else {
        [self showToastView];
        [self.myTextView resignFirstResponder];
        NSString *noBlank = [self.myTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (noBlank.length > 0) {
            if (_isUploadImg == YES) {
                [ADHelper showToastWithText:@"图片上传中，请稍候再试"];
            } else {
                [self postSecert];
            }
            
        } else {
            [ADHelper showToastWithText:@"不能发空白字符"];
        }
    }
}

- (void)postSecert
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    NSMutableString *urlValue = [[NSMutableString alloc]initWithCapacity:0];
    
    for (int i = 0; i < _imgArray.count; i++) {
        ADMomSecertImage *img = _imgArray[i];
        if (i == 0) {
            [urlValue appendString:img.imgUrl];
        } else {
            [urlValue appendString:[NSString stringWithFormat:@",%@",img.imgUrl]];
        }
    }
    
    [_aIndicator startAnimating];
    
    if (_unUploadImgs.count > 0) {
        for (int i = 0; i < _unUploadImgs.count; i++) {
            UIImage *aImg = _unUploadImgs[i];
            [self uploadImg:aImg];
        }
        [ADToastHelp dismissSVProgress];
        //[SVProgressHUD dismiss];
        [ADHelper showToastWithText:@"网络不好，图片上传后请再试"];
    } else {
        [[ADMomSecertNetworkHelper shareInstance]postSecerrWithBody:_myTextView.text
                                                          andImgUrl:urlValue
                                                     andFinishBlock:
         ^{
             [[NSUserDefaults standardUserDefaults]setAddingMomSecret:@""];
             [ADToastHelp dismissSVProgress];

             //[SVProgressHUD dismiss];
             [self.navigationController popViewControllerAnimated:YES];
             
             self.aMomVc.isWriteVCBack = YES;
             
             [ADMomSecertDAO removeAllImg];
             
             [[NSUserDefaults standardUserDefaults]setObject:@[] forKey:addingMomSecretImagesKey];
         } failed:^{
             //[SVProgressHUD dismiss];
             [ADToastHelp dismissSVProgress];

             [self setRightItemWithStrPublish];
             self.navigationItem.rightBarButtonItem.enabled = YES;
         }];
    }
}

- (void)addTextField
{
    self.myTextView =
    [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -64)];
    self.myTextView.font = [UIFont systemFontOfSize:16];
    self.myTextView.textColor = [UIColor font_Brown];
    self.myTextView.delegate = self;
    
    NSString *draft = [[NSUserDefaults standardUserDefaults]addingMomSecret];
    if (_topicString.length > 0) {
        self.myTextView.text = [NSString stringWithFormat:@"#%@# %@",
                                _topicString, draft.length > 0 ? draft:@""];
    } else if (draft.length > 0) {
        self.myTextView.text = draft;
    }

    [self.scrollViewBg addSubview:self.myTextView];
    [self.myTextView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
        return YES;
    } else {
        if ([ADHelper getToInt:textView.text] > 300) {
            [ADHelper showToastWithText:@"长度不能大于300"];
            return NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)setRightItemWithIndicator
{
    _aIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _aIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_aIndicator];
}

#pragma ADActionSheet 代理
- (void)actionSheet:(ADActionSheetView *)actionSheet clickedCustomButtonAtIndex:(NSNumber *)buttonIndex
{
    NSInteger index = [buttonIndex integerValue];
    if (index == 0) {
        [self showTakePhotoView];
    }else if (index == 1){
        [self showSelectPhotoView];
    }else if(index == 2){
        [self.myTextView becomeFirstResponder];
    }
}

#pragma - upload img method
- (void)uploadImg:(UIImage *)uploadImg
{
    NSString *imgPath =
    [NSString stringWithFormat:@"/pa/secret/%@.jpeg", [ADImageUploader generateImageName]];
    [ADImageUploader uploadWithImage:uploadImg
                              toPath:imgPath
                       progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                           _isUploadImg = YES;
                           
                           [self setRightItemWithIndicator];
                           if (_aIndicator.isAnimating == NO) {
                               [_aIndicator startAnimating];
                           }
                       }completeBlock:^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
                           NSLog(@"up err:%@", error);
                           //finish change bool
                           _isUploadImg = NO;
                           if (completed == NO) {
                               NSLog(@" not complete");
                               if (![_unUploadImgs containsObject:uploadImg]) {
                                   [_unUploadImgs addObject:uploadImg];
                               }
                           } else {
                               
                               NSData *fileData = UIImagePNGRepresentation(uploadImg);
                               
                               NSLog(@"unUploadImgs:%@", _unUploadImgs);
                               if ([_unUploadImgs containsObject:uploadImg]) {
                                   [_unUploadImgs removeObject:uploadImg];
                                   NSLog(@"del one img");
                                   
                               }

                               int imageIndex = 0;
                               for(ADMomSecertImage *image in _imgArray){
                                   if (image.index > imageIndex) {
                                       imageIndex = image.index;
                                   }
                               };

                               ADMomSecertImage *aImg = [[ADMomSecertImage alloc]init];
                               aImg.shotImg = fileData;
                               aImg.imgUrl = imgUrl;
                               aImg.index = imageIndex + 1;
                               [ADMomSecertDAO saveImage:aImg];
                               _imgArray = [ADMomSecertDAO readImage];
                           }
                           
                           [self setRightItemWithStrPublish];
                           self.navigationItem.rightBarButtonItem.enabled = YES;
                       }];
}

- (void)showToastView
{
    [ADToastHelp showSVProgressToastWithTitle:@"正在发布秘密"];
}

@end