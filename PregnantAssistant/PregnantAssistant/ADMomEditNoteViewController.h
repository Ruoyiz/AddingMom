//
//  ADMomEditNoteViewController.h
//  PregnantAssistant
//
//  Created by D on 14-9-20.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADNote.h"
#import "ADAddPhotoView.h"
#import "ADNotePreviewView.h"
#import "ADNoteDAO.h"
//#import "UzysImageCropperViewController.h"

@interface ADMomEditNoteViewController : ADBaseViewController <
//UzysImageCropperDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, retain) UITextView *myTextView;
@property (nonatomic, retain) NSDate *createNewNoteDate;

//@property (nonatomic, copy) NSString *cellTitle;
@property (nonatomic, retain) RLMResults *allNoteArray;

@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *dueLabel;

@property (nonatomic, assign) NSInteger noteIndex;
@property (nonatomic, assign) BOOL isEditHaveNote;

@property (nonatomic, assign) BOOL allowShowDelBtn;

@property (nonatomic, retain) UIView *devideLine;

@property (nonatomic, retain) ADNewNote *myNote;
@property (nonatomic, retain) NSMutableArray *photoArray;

@property (nonatomic, retain) ADAddPhotoView *addPhotoView;
@property (nonatomic, retain) UIImagePickerController *aImagePicker;
@property (nonatomic, retain) NSMutableArray *photoImgArray;

@property (nonatomic, retain) UIView *photoBgView;
@property (nonatomic, assign) int toDelTag;

@property (nonatomic, retain) NSMutableArray *picNameArray;

@property (nonatomic, assign) BOOL writeFinish;
@property (nonatomic, retain) ADNotePreviewView *preview;

@property (nonatomic, copy) NSString *currentNotePicUrlsStr;
@property (nonatomic, retain) NSMutableArray *currentNotePicUrlsArray;

- (void)tapPhotoView:(UITapGestureRecognizer *)sender;

@end