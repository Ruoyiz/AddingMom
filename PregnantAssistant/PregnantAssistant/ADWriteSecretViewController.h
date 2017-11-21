//
//  ADWriteSecretViewController.h
//  PregnantAssistant
//
//  Created by D on 14/12/5.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ADMomSecretViewController.h"
#import "ADAddSecertImageView.h"
#import "ADMomSecertImage.h"
#import "ADActionSheetView.h"

@interface ADWriteSecretViewController : ADBaseViewController <
UITextViewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
CLLocationManagerDelegate,ADActionSheetDelegate,AddImageDelegate
>

@property (nonatomic, retain) UIScrollView *scrollViewBg;
@property (nonatomic, retain) UITextView *myTextView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ADMomSecretViewController *aMomVc;

@property (nonatomic, retain) RLMResults *imgArray;

@property (nonatomic, retain) ADAddSecertImageView *addImageView;
@property (nonatomic, retain) UIImagePickerController *aImagePicker;

@property (nonatomic, assign) int toDelTag;
@property (nonatomic, retain) UIView *photoBgView;

//@property (nonatomic, retain) NSMutableArray *imgUrlArray;

@property (nonatomic, assign) BOOL isUploadImg;
@property (nonatomic, assign) BOOL haveErrWithUploadImg;

//@property (nonatomic, assign) NSInteger upUploadImgNum;

@property (nonatomic, retain) NSMutableArray *unUploadImgs;

@property (nonatomic, copy) NSString *topicString;

@property (nonatomic, retain) UIActivityIndicatorView *aIndicator;

@end
