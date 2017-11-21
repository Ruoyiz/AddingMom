//
//  ADAddPhotoView.h
//  PhotoViewDemo
//
//  Created by D on 14/11/4.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAddPhotoView : UIView

@property (nonatomic, retain) NSMutableArray *photoImgArray;
@property (nonatomic, retain) NSMutableArray *photoImgUrlArray;
@property (nonatomic, retain) NSMutableArray *photoViewArray;
@property (nonatomic, retain) UIButton *addBtn;
@property (nonatomic, assign) BOOL showAddBtn;

@property (nonatomic, assign) BOOL isUseUrl;

@property (nonatomic, retain) UIViewController *parentVC;

- (id)initWithFrame:(CGRect)frame
         showAddBtn:(BOOL)showAdd
          andPhotos:(NSMutableArray *)aPhotoArray
        andParentVC:(UIViewController *)aParentVC;

- (id)initWithFrame:(CGRect)frame
         showAddBtn:(BOOL)showAdd
       andPhotoUrls:(NSMutableArray *)aPhotoUrlArray
        andParentVC:(UIViewController *)aParentVC;

- (void)addAPhotoView:(UIImage *)aImage
               andUrl:(NSString *)aUrl;

//- (void)addAPhotoViewWithUrl:(NSString *)aUrl;

- (void)removePhotoWithIndex:(int)tag;

@end
