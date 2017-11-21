//
//  ADMomEditNoteViewController.m
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADMomEditNoteViewController.h"
#import "ADCustomButton.h"
#import "JGActionSheet.h"
#import "ADImageUploader.h"

@interface ADMomEditNoteViewController (){

    NSString *_photoUrlStringArray;
    NSMutableArray *_imageStringArray;
    NSMutableArray *_photoImageArray;
    NSString *_noteEditTimer;
}
@end

@implementation ADMomEditNoteViewController

-(void)dealloc
{
    self.aImagePicker.delegate = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UITextView appearance] setTintColor:[UIColor dark_green_Btn]];
    [[UITextField appearance] setTintColor:[UIColor dark_green_Btn]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor bg_lightYellow];
    [self registerForKeyboardNotifications];
    [self setLeftBackItemWithImage:nil andSelectImage:nil];
    _imageStringArray = [[NSMutableArray alloc] init];
    _photoImageArray = [[NSMutableArray alloc] init];
    _noteEditTimer = @"";
    if (_isEditHaveNote == YES) {
        [self setRightItemWithStrEdit];
        _allowShowDelBtn = NO;
    } else {
        [self setRightItemWithStrDone];
        _allowShowDelBtn = YES;
    }
    
    self.myTitle = @"孕妈日记";
    
    self.allNoteArray = [ADNoteDAO readAllData];
    
    [self addDateView];
    
    [self addTextView];
    
    [self setNoteText];
//    _iscomPleteUploading = YES;

    self.writeFinish = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [[UITextView appearance] setTintColor:[UIColor defaultTintColor]];
    [[UITextField appearance] setTintColor:[UIColor defaultTintColor]];
}

- (void)addDateView
{
    int naviHeight = 64;
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 12 + naviHeight, 200, 20)];
    _dateLabel.font = [UIFont systemFontOfSize:16];
    _dateLabel.textColor = [UIColor dark_green_Btn];
    
    [self.view addSubview:_dateLabel];
    
    _dueLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 24 +12 + naviHeight, 200, 20)];
    _dueLabel.font = [UIFont systemFontOfSize:14];
    _dueLabel.textColor = [UIColor dark_green_Btn];
    
    [self.view addSubview:_dueLabel];
    
    _devideLine = [[UIView alloc]initWithFrame:CGRectMake(12, 64 + naviHeight, SCREEN_WIDTH -24, 0.5)];
    _devideLine.backgroundColor = [UIColor dark_green_Btn];
    [self.view addSubview:_devideLine];
}

- (void)addTextView
{
    self.myTextView =
    [[UITextView alloc]initWithFrame:CGRectMake(12, 64 +64, SCREEN_WIDTH-24, SCREEN_HEIGHT -60 -64 -12 -64)];
    
    self.myTextView.font = [UIFont systemFontOfSize:16];
    self.myTextView.textColor = [UIColor font_Brown];
    self.myTextView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.myTextView];
    
    if (_isEditHaveNote) {
        self.myTextView.editable = NO;
    } else {
        [self.myTextView becomeFirstResponder];
    }
}

#pragma mark － 加载图片
- (void)setNoteText
{
    _picNameArray = [[NSMutableArray alloc]initWithCapacity:0];
    _photoImgArray = [[NSMutableArray alloc]initWithCapacity:0];
    _currentNotePicUrlsArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    if (_isEditHaveNote == YES) {
        _myNote = self.allNoteArray[self.noteIndex];
        
        _dateLabel.text = [ADHelper getDateLabelStrWithDate:_myNote.publishDate];
        _dueLabel.text = [ADHelper getDueLabelStrWithDate:_myNote.publishDate];
        
        NSLog(@"set photoImgArray:%@ %@", _myNote.note, _myNote.photoNames);
        
//        _currentNotePicUrlsArray = [[NSMutableArray alloc]initWithArray:
//                                    [_myNote.photoUrls componentsSeparatedByString:@","]];
//        for (int i = 0; i < _myNote.photoNames.count; i ++) {
//            
//        }
//        for (NSString *aUrl in _currentNotePicUrlsArray) {
//            if (aUrl.length == 0) {
//                [_currentNotePicUrlsArray removeObject:aUrl];
//            }
//        }
        
    
        [self addPreviewView];
    
        if (_dueLabel.text.length == 0) {
            [self adjustPos];
        }
    } else {
        self.createNewNoteDate = [NSDate date];
        _dateLabel.text = [ADHelper getDateLabelStrWithDate:_createNewNoteDate];
        
        _dueLabel.text = [ADHelper getDueLabelStrWithDate:_createNewNoteDate];
        
        if (_dueLabel.text.length == 0) {
            _dueLabel.hidden = YES;
            
            [self adjustPos];
        }
        
        [self addAPhotoView];
    }
}

- (void)addPreviewView
{
//    NSLog(@"note: %@ url:%@", _myNote.note, _myNote.photoUrls);
//
//    NSArray *photoUrls = [_myNote.photoUrls componentsSeparatedByString:@","];
//
//    NSLog(@"photoUrls: %@", photoUrls);
    for (ADMotherDirPhoto *motherDir in _myNote.motherPhotoModes) {
        UIImage *iamge = [UIImage imageWithData:motherDir.imageData];
        [_photoImageArray addObject:iamge];
    }
    NSLog(@"phooImageArray: %@",_photoImageArray);
    _preview = [[ADNotePreviewView alloc] initWithFrame:CGRectMake(10, 64 +4 +64, SCREEN_WIDTH -20, SCREEN_HEIGHT -65 -64 -10) andNote:_myNote.note andImgArray:_photoImageArray];
//    _preview =
//    [[ADNotePreviewView alloc]initWithFrame:CGRectMake(10, 64 +4 +64, SCREEN_WIDTH -20, SCREEN_HEIGHT -65 -64 -10)
//                                    andNote:_myNote.note
//                             andImgUrlArray:photoUrls];

    [self.view addSubview:_preview];
    
}

- (void)addAPhotoView
{
    CGRect photoViewFrame = CGRectZero;
    if (_isEditHaveNote == NO) {
        if ([ADHelper isIphone4]) {
            photoViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        } else {
            photoViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        }
        
        _addPhotoView = [[ADAddPhotoView alloc] initWithFrame:photoViewFrame showAddBtn:YES andPhotos:nil andParentVC:self];
        
    } else {
        if ([ADHelper isIphone4]) {
            photoViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
        } else {
            photoViewFrame = CGRectMake(0, 0, SCREEN_WIDTH, 88);
        }
        
        NSLog(@"current pic array:%@", _currentNotePicUrlsArray);
        _addPhotoView = [[ADAddPhotoView alloc] initWithFrame:photoViewFrame showAddBtn:YES andPhotos:_photoImageArray andParentVC:self];
    }
    
    _addPhotoView.hidden = YES;
    [self.view addSubview:_addPhotoView];
    
    [_addPhotoView.addBtn addTarget:self
                             action:@selector(addAPhoto:)
                   forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapPhotoView:(UITapGestureRecognizer *)sender
{
    _toDelTag = (int)sender.view.tag;

    [self.myTextView resignFirstResponder];
    //add Bigger bgView
    CGRect newRect = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64);
    _photoBgView = [[UIView alloc]initWithFrame:newRect];
    _photoBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    //addBigger ScrollView
    UIScrollView *bigScrollView =
    [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64 -20 -64)];

    //add bigger image
    UIImageView *biggerImgView = [[UIImageView alloc]init];
    
    biggerImgView.userInteractionEnabled = YES;

    NSLog(@"photoImageArray:%@", _picNameArray);
    NSLog(@"toDelTag:%d", _toDelTag);
    
    [biggerImgView sd_setImageWithURL:_currentNotePicUrlsArray[_toDelTag -10]
                            completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         if (image) {
             float radio = image.size.height / image.size.width;
             if ([ADHelper isIphone4]) {
                 biggerImgView.frame = CGRectMake(10, 0, 300, 300 *radio);
             } else {
                 biggerImgView.frame = CGRectMake(10, 0, (SCREEN_WIDTH -20), (SCREEN_WIDTH -20) *radio);
             }
             
             bigScrollView.contentSize = CGSizeMake((SCREEN_WIDTH -20), (SCREEN_WIDTH -20) *radio);
             [bigScrollView addSubview:biggerImgView];
             
             UITapGestureRecognizer *biggerTap =
             [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBiggerView)];
             [biggerImgView addGestureRecognizer:biggerTap];
             
             [_photoBgView addSubview:bigScrollView];
             [self.view addSubview:_photoBgView];
             
             //add delBtn
             if (_allowShowDelBtn == YES) {
                 [self addDelBtn];
             }
         }
     }];
}

- (void)addDelBtn
{
    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -46, 20, 44, 32)];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delImage:) forControlEvents:UIControlEventTouchUpInside];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_photoBgView addSubview:delBtn];
}

- (void)dismissBiggerView
{
    [_photoBgView removeFromSuperview];
    [self.myTextView becomeFirstResponder];
}

- (void)delImage:(UIButton *)sender
{
    [self dismissBiggerView];
    
    [_addPhotoView removePhotoWithIndex:_toDelTag];
    
    [_currentNotePicUrlsArray removeObjectAtIndex:_toDelTag -10];
}

- (void)addAPhoto:(UIButton *)sender
{
    [self.myTextView resignFirstResponder];
    //show actionsheet
    JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:@"请选择照片"
                                                                    message:nil
                                                               buttonTitles:@[@"拍照", @"从手机相册中选取"]
                                                                buttonStyle:JGActionSheetButtonStyleDefault];
    JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil
                                                                         message:nil
                                                                    buttonTitles:@[@"取消"]
                                                                     buttonStyle:JGActionSheetButtonStyleCancel];
    
    NSArray *sections = @[section1, cancelSection];
    
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
    
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        if (indexPath.section == 0) {
            if(indexPath.row == 0) {
                NSLog(@"take");
                [self showTakePhotoView];
            } else if (indexPath.row == 1) {
                NSLog(@"select");
                [self showSelectPhotoView];
            }
        } else if (indexPath.section == 1) {
            NSLog(@"cancel");
            [self.myTextView becomeFirstResponder];
        }
        
        [sheet dismissAnimated:YES];
    }];
    
    [sheet showInView:self.view animated:YES];
}

- (void)showTakePhotoView
{
    //判断是否可以打开相机，模拟器此功能无法使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;

        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else {
        //如果没有提示用户
        [[[UIAlertView alloc] initWithTitle:@"亲爱的"
                                    message:@"你的设备没有摄像头"
                                   delegate:nil
                          cancelButtonTitle:@"好的"
                          otherButtonTitles:nil] show];
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
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    float radio = image.size.height/image.size.width;
    image = [ADHelper scaleImg:image toSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*radio)];
    //SAVE Image on a thead
    
    NSString *imageLocaName = [ADImageUploader generateImageName];
    NSString *imgPath =
    [NSString stringWithFormat:@"/pa/momNote/%@.jpeg", imageLocaName];
    NSString *fullPath = [NSString stringWithFormat:@"http://addinghome.b0.upaiyun.com%@", imgPath];
    
    [_addPhotoView addAPhotoView:image andUrl:imgPath];
    
    [_picNameArray addObject:imageLocaName];
    
    
    if (_myNote.publishTimer.length == 0) {
        if ([ADNoteDAO readNewNoteWithNSTimer:_noteEditTimer].count > 0) {
            ADNewNote *newNote =[ADNoteDAO readNewNoteWithNSTimer:_noteEditTimer].firstObject;
            self.myNote = newNote;
            _noteEditTimer = newNote.publishTimer;
        }else{
            _noteEditTimer =[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]] ;
        }
    }else{
        _noteEditTimer = _myNote.publishTimer;
    }
    
    if (_photoUrlStringArray.length) {
        _photoUrlStringArray = [NSString stringWithFormat:@"%@,%@",_photoUrlStringArray,fullPath];
    }else{
        _photoUrlStringArray = fullPath;
    }
    
    ADMotherDirPhoto *motherDir = [[ADMotherDirPhoto alloc] initWithImageName:imageLocaName ImageDate:image isUpload:NO];
//    [_imageStringArray addObject:motherDir];
    
    [ADNoteDAO addDiaryModelWithNote:self.myTextView.text photosNames:motherDir photosUrls:_photoUrlStringArray publishDate:_noteEditTimer imageName:imageLocaName newNotoe:self.myNote];
   
    [_photoImgArray addObject:UIImageJPEGRepresentation(image, 0.75)];
    [self dismissViewControllerAnimated:YES completion:^{
        [ADImageUploader uploadWithImage:image toPath:imgPath
                           progressBlock:^(CGFloat percent, long long requestDidSendBytes) {
                           } completeBlock:^(NSError *error, NSDictionary *result, NSString *imgUrl, BOOL completed) {
                               if (completed) {
                                   [ADNoteDAO updateWithPublishDate:_noteEditTimer photosName:imageLocaName isUpload:YES];
                               }else{
                                   [ADHelper showToastWithText:@"上传图片失败"];
                               }
                           }];
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.myTextView becomeFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.myTextView becomeFirstResponder];
}

- (void)adjustPos
{
    //adjust pos
    CGPoint newCenter = _devideLine.center;
    newCenter.y -= 20;
    _devideLine.center = newCenter;
    
    CGPoint textNewCenter = _myTextView.center;
    textNewCenter.y -= 20;
    _myTextView.center = textNewCenter;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    _addPhotoView.hidden = NO;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    /* 通过 kbSize.height
     * 就可以得到屏幕键盘的高度，这样就可以据以调整其他的屏幕元素了 */
    
    if ([ADHelper isIphone4]) {
        self.myTextView.frame =
        CGRectMake(12, 65 + 64, SCREEN_WIDTH -24, SCREEN_HEIGHT - kbSize.height -44 -64 -48 -12);
        _addPhotoView.frame = CGRectMake(4, SCREEN_HEIGHT - kbSize.height -48, SCREEN_WIDTH, 44);
    } else {
        self.myTextView.frame = CGRectMake(12, 65 + 64, SCREEN_WIDTH -24, SCREEN_HEIGHT - kbSize.height -44 -64 -88);
        _addPhotoView.frame = CGRectMake(4, SCREEN_HEIGHT - kbSize.height -84, SCREEN_WIDTH, 80);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 完成或编辑按钮点击事件
- (void)rightItemMethod:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        _allowShowDelBtn = YES;
        
        [_preview removeFromSuperview];
        _myTextView.text = _myNote.note;
        
        [self addAPhotoView];
        
        [self changeViewToEdit];
    } else {
        //no action when text nil
        if ([self isEmpty:self.myTextView.text]) {
            [[[UIAlertView alloc] initWithTitle:@"亲爱的"
                                        message:@"您还没有输入文字"
                                       delegate:self
                              cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            return;
        } else {
//            NSLog(@"notedlkk: %@,timer:%@",self.myTextView.text,_noteEditTimer);
            
//            [ADNoteDAO updateNewNoteWithNote:self.myTextView.text publishTimer:_noteEditTimer];
            [self.navigationController popViewControllerAnimated:YES];
//            if (!_iscomPleteUploading) {
//                [[[UIAlertView alloc] initWithTitle:@"亲爱的"
//                                            message:@"图片上传中，请稍候"
//                                           delegate:self
//                                  cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
//                
//            } else {
//                
//                [self uploadAndUpdateLocalData];
//                [self.navigationController popViewControllerAnimated:YES];
//            }

//            if ([NSUserDefaults standardUserDefaults].addingToken.length > 0)
//            {
//            }else{
//                [self uploadAndUpdateLocalData];
//                [self.navigationController popViewControllerAnimated:YES];
//            }
        }
    }
}

- (BOOL)isEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (void)changeViewToEdit
{
    self.myTextView.editable = YES;
    [self.myTextView becomeFirstResponder];
    
    ADCustomButton *delBtn =
    [[ADCustomButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -60), 20 +64, 40, 30)];
    delBtn.titleStr = @"删除";
    
    if (_dueLabel.text.length == 0) {
        delBtn.frame = CGRectMake(SCREEN_WIDTH -60, 8 +64, 40, 30);
    }
    delBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    delBtn.buttonColor = [UIColor dark_green_Btn];
    
    [delBtn addTarget:self action:@selector(delNote) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:delBtn];
}

//- (void)uploadAndUpdateLocalData{
//    NSDate *noteEditDate = _myNote.publishDate;
//    if (noteEditDate == nil) {
//        noteEditDate = _createNewNoteDate;
//    }
//    NSLog(@"before currentUrls:%@ array:%@", _currentNotePicUrlsStr, _currentNotePicUrlsArray);
//    // array string
//    for (int i = 0; i < _currentNotePicUrlsArray.count; i++) {
//        NSString *aPicName = _currentNotePicUrlsArray[i];
//        if (_currentNotePicUrlsStr.length == 0) {
//            _currentNotePicUrlsStr = aPicName;
//        } else {
//            _currentNotePicUrlsStr = [NSString stringWithFormat:@"%@,%@",_currentNotePicUrlsStr, aPicName];
//        }
//    }
//
//    _myNote = [[ADNewNote alloc]initWithNote:self.myTextView.text
//                                 photosNames:_picNameArray
//                                  photosUrls:_currentNotePicUrlsStr
//                                   photoData:nil
//                              andPublishDate:noteEditDate];
//    
//    [ADNoteDAO createOrUpdateNote:_myNote];
//}

- (void)delNote
{
    [ADNoteDAO delNote:_myNote];
    [self.navigationController popViewControllerAnimated:YES];
}

@end