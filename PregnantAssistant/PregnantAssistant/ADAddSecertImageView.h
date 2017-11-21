//
//  ADAddSecertImageView.h
//  PregnantAssistant
//
//  Created by D on 14/12/23.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddImageDelegate <NSObject>

- (void)addNewImage;

@end

#define MAXPICNUM 6

@interface ADAddSecertImageView : UIView

@property (nonatomic, retain) NSMutableArray *photoImgArray;
@property (nonatomic, retain) NSMutableArray *photoViewArray;
@property (nonatomic, retain) NSMutableArray *uploadIndicatorArray;

@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, assign) BOOL showAddBtn;

@property (nonatomic, retain) UIViewController *parentVC;

@property (nonatomic, assign) float squareSize;

@property (nonatomic,assign) id <AddImageDelegate> delegate;

- (id)initWithFrame:(CGRect)frame
          andPhotos:(NSMutableArray *)aPhotoArray
        andParentVC:(UIViewController *)aParentVC;

- (void)addAPhotoView:(UIImage *)aImage;

- (void)showAddPhotoBtn;

- (void)removePhotoWithIndex:(int)tag;

@end
