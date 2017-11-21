//
//  ADExportImageViewController.h
//  PregnantAssistant
//
//  Created by D on 14/11/1.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ADShareContent.h"

typedef NS_ENUM(NSInteger, ExportImageStyle) {
     columnStyle,
     tubeStyle
};

@interface ADExportImageViewController : ADBaseViewController

@property (nonatomic, retain)UIButton *columnStyleBtn;
@property (nonatomic, retain)UIButton *tubeStyleBtn;
@property (nonatomic, retain)NSMutableArray *allImageArray;
@property (nonatomic, retain)UIImage *finalImage;
@property (nonatomic, retain)ALAssetsLibrary *aLibrary;
@property (nonatomic, assign)ExportImageStyle selectedStyle;
@property (nonatomic, retain)UIView *borderView;

@property (nonatomic, retain)UIImageView *columnView;
@property (nonatomic, retain)UIImageView *tubeView;

@property (nonatomic, retain)UIButton *columnSelBtn;
@property (nonatomic, retain)UIButton *tubeSelBtn;

@property (nonatomic, retain)NSMutableArray *selectImgArray;

@property (nonatomic, retain)UIView *finishBg;

@property (nonatomic, retain)UIView *sheetView;
@property (nonatomic, retain)ADShareContent *aShareContent;

@end
