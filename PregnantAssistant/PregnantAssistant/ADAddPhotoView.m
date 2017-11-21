//
//  ADAddPhotoView.m
//  PhotoViewDemo
//
//  Created by D on 14/11/4.
//  Copyright (c) 2014年 D. All rights reserved.
//

#import "ADAddPhotoView.h"

@implementation ADAddPhotoView

- (id)initWithFrame:(CGRect)frame
         showAddBtn:(BOOL)showAdd
          andPhotos:(NSMutableArray *)aPhotoArray
        andParentVC:(UIViewController *)aParentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentVC = aParentVC;
        _photoImgArray = [[NSMutableArray alloc]initWithArray:aPhotoArray];
        _isUseUrl = NO;
        [self addPhotos];
        
        if (showAdd) {
            [self addPhotoBtn];
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
         showAddBtn:(BOOL)showAdd
       andPhotoUrls:(NSMutableArray *)aPhotoUrlArray
        andParentVC:(UIViewController *)aParentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        _parentVC = aParentVC;
        _photoImgUrlArray = [[NSMutableArray alloc]initWithArray:aPhotoUrlArray];
//        self.photoImgArray = aPhotoArray;
        _isUseUrl = YES;
        [self addPhotosWithUrl];
        
        if (showAdd) {
            [self addPhotoBtn];
        }
    }
    return self;
}

- (void)addPhotos
{
    self.photoViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    //read photo img
    
    //add photo view
    for (int i = 0; i < self.photoImgArray.count; i++) {
        UIImage *aPhoto = self.photoImgArray[i];
        UIImageView *aPhotoView = [[UIImageView alloc]init];
        
        aPhotoView.image = aPhoto;
        
        if ([ADHelper isIphone4]) {
            int posX = 12 +i *(32 +12);
            aPhotoView.frame = CGRectMake(posX, 12, 32, 32);
        } else {
            int posX = 6 +i *(64 +12);
            aPhotoView.frame = CGRectMake(posX +6, 12 +6, 60, 60);
        }
        
        aPhotoView.userInteractionEnabled = YES;
        aPhotoView.tag = 10 +i;
        
        UITapGestureRecognizer *photoTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
        [aPhotoView addGestureRecognizer:photoTap];
        
        [self.photoViewArray addObject:aPhotoView];
        [self addSubview:aPhotoView];
    }
}

- (void)addPhotosWithUrl
{
    self.photoViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //add photo view
    for (int i = 0; i < self.photoImgUrlArray.count; i++) {
        NSString *aPhotoUrl = self.photoImgUrlArray[i];
        UIImageView *aPhotoView = [[UIImageView alloc]init];
        [aPhotoView sd_setImageWithURL:[NSURL URLWithString:aPhotoUrl]
                             completed:
         ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
        
        if ([ADHelper isIphone4]) {
            int posX = 12 +i *(32 +12);
            aPhotoView.frame = CGRectMake(posX, 12, 32, 32);
        } else {
            int posX = 6 +i *(64 +12);
            aPhotoView.frame = CGRectMake(posX +6, 12 +6, 60, 60);
        }
        
        aPhotoView.userInteractionEnabled = YES;
        aPhotoView.tag = 10 +i;
        
        UITapGestureRecognizer *photoTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
        [aPhotoView addGestureRecognizer:photoTap];
        
        [self.photoViewArray addObject:aPhotoView];
        [self addSubview:aPhotoView];
    }
}

- (void)tapPhotoView:(UITapGestureRecognizer *)sender
{
}

- (void)removePhotoWithIndex:(int)tag
{
    //remove view
    for (UIView *aView in self.photoViewArray) {
        [aView removeFromSuperview];
    }
    
//    NSLog(@"view: %@ img: %@", self.photoViewArray, self.photoImgArray);
    [self.photoViewArray removeObjectAtIndex:tag -10];
//    NSLog(@"view: %@ img: %@", self.photoViewArray, self.photoImgArray);
    
    for (int i = 0; i < self.photoViewArray.count; i++) {
//        UIImage *aPhoto = self.photoImgArray[i];
//        UIImageView *aPhotoView = [[UIImageView alloc]init];
//        aPhotoView.image = aPhoto;
        
        UIImageView *aPhotoView = self.photoViewArray[i];
        
        if ([ADHelper isIphone4]) {
            int posX = 12 +i *(32 +12);
            aPhotoView.frame = CGRectMake(posX, 12, 32, 32);
        } else {
            int posX = 6 +i *(64 +12);
            aPhotoView.frame = CGRectMake(posX +6, 12 +6, 60, 60);
        }
        
        aPhotoView.userInteractionEnabled = YES;
        aPhotoView.tag = 10 +i;
        UITapGestureRecognizer *photoTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
        [aPhotoView addGestureRecognizer:photoTap];
        
//        [self.photoViewArray addObject:aPhotoView];
        [self addSubview:aPhotoView];
    }
    
    //if less 4 add btn
    if (self.photoViewArray.count < 4) {
        [self addSubview:_addBtn];
    }
    //set addBtn frame
    [self setAddBtnFrame];
    _addBtn.hidden = NO;
}

- (void)addPhotoBtn
{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setAddBtnFrame];
    [_addBtn setImage:[UIImage imageNamed:@"孕妈日记加号"] forState:UIControlStateNormal];
    
    [self addSubview:_addBtn];
    
    if (_isUseUrl == YES) {
        if (_photoImgUrlArray.count == 4) {
            _addBtn.hidden = YES;
        }
    } else {
        if (_photoImgArray.count == 4) {
            _addBtn.hidden = YES;
        }
    }
}

- (void)setAddBtnFrame
{
    if ([ADHelper isIphone4]) {
        int posX = 0;
        if (_isUseUrl) {
            posX = 4 +(int)self.photoViewArray.count *(36 +12);
        } else {
            posX = 4 +(int)self.photoImgArray.count *(36 +12);
        }
        _addBtn.frame = CGRectMake(posX, 12, 32, 32);
    } else {
        int posX = 0;
        if (_isUseUrl) {
            posX = 4 +(int)self.photoViewArray.count *(65 +12);
        } else {
            posX = 4 +(int)self.photoImgArray.count *(65 +12);
        }

        _addBtn.frame = CGRectMake(posX, 12, 72, 72);
    }
}

- (void)showAddPhotoBtn
{
    [self addPhotoBtn];
}

- (void)addAPhotoView:(UIImage *)aImage
               andUrl:(NSString *)aUrl
{
    UIImageView *aImgView = [[UIImageView alloc]init];
    if ([ADHelper isIphone4]) {
        int posX = 12 +(int)self.photoImgArray.count *(32 +12);
        aImgView.frame = CGRectMake(posX, 12, 32, 32);
    } else {
        int posX = 6 +(int)self.photoImgArray.count *(64 +12);
        aImgView.frame = CGRectMake(posX +6, 12 +6, 60, 60);
    }
    aImgView.image = aImage;
    
    [self addSubview:aImgView];

    CGPoint addBtnCenter = _addBtn.center;
    if ([ADHelper isIphone4]) {
        addBtnCenter.x += 13 +35;
    } else {
        addBtnCenter.x += 13 +64;
    }
    //move addBtn
    _addBtn.center = addBtnCenter;
    
    [self.photoImgUrlArray addObject:aUrl];
    [self.photoViewArray addObject:aImgView];
    [self.photoImgArray addObject:aImage];
    
    aImgView.userInteractionEnabled = YES;
    aImgView.tag = 10 +[self.photoViewArray indexOfObject:aImgView];
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
    [aImgView addGestureRecognizer:photoTap];

    if (self.photoImgUrlArray.count == 4) {
        [_addBtn removeFromSuperview];
    }
}

//- (void)addAPhotoViewWithUrl:(NSString *)aUrl
//{
//    UIImageView *aImgView = [[UIImageView alloc]init];
//    if ([ADHelper isIphone4]) {
//        int posX = 12 +(int)self.photoImgUrlArray.count *(32 +12);
//        aImgView.frame = CGRectMake(posX, 12, 32, 32);
//    } else {
//        int posX = 6 +(int)self.photoImgUrlArray.count *(64 +12);
//        aImgView.frame = CGRectMake(posX +6, 12 +6, 60, 60);
//    }
//    [aImgView sd_setImageWithURL:[NSURL URLWithString:aUrl]
//                       completed:
//     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//     }];
//    
//    [self addSubview:aImgView];
//    
//    CGPoint addBtnCenter = _addBtn.center;
//    if ([ADHelper isIphone4]) {
//        addBtnCenter.x += 13 +35;
//    } else {
//        addBtnCenter.x += 13 +64;
//    }
//    //move addBtn
//    _addBtn.center = addBtnCenter;
//    
//    [self.photoImgUrlArray addObject:aUrl];
//    [self.photoViewArray addObject:aImgView];
//    
//    aImgView.userInteractionEnabled = YES;
//    aImgView.tag = 10 +[self.photoViewArray indexOfObject:aImgView];
//    UITapGestureRecognizer *photoTap =
//    [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
//    [aImgView addGestureRecognizer:photoTap];
//    
//    if (self.photoImgUrlArray.count == 4) {
//        [_addBtn removeFromSuperview];
//    }
//}

@end
