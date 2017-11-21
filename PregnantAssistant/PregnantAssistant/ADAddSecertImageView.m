//
//  ADAddSecertImageView.m
//  PregnantAssistant
//
//  Created by D on 14/12/23.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADAddSecertImageView.h"
#import "ADMomSecertImage.h"
#import "ADMomSecertDAO.h"

@implementation ADAddSecertImageView

- (id)initWithFrame:(CGRect)frame
          andPhotos:(NSMutableArray *)aPhotoArray
        andParentVC:(UIViewController *)aParentVC
{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVC = aParentVC;
        self.photoImgArray = [[NSMutableArray alloc]initWithArray:aPhotoArray];
        _squareSize = (SCREEN_WIDTH -12) / 4 -13;

        [self setupView];

    }
    return self;
}

- (void)setupView
{
    [self addPhotos];
    if (self.photoImgArray.count < MAXPICNUM) {
        [self addPhotoBtn];
    }
}

- (void)addPhotos
{
    self.photoViewArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    //add photo view
    for (int i = 0; i < self.photoImgArray.count; i++) {
        int row = i / 4;
        int col = i % 4;

        ADMomSecertImage *aPhoto = self.photoImgArray[i];
        
        if (![aPhoto isKindOfClass:[ADMomSecertImage class]]) {
            continue;
        }
        
        UIImageView *aPhotoView = [[UIImageView alloc]init];
        aPhotoView.image = [UIImage imageWithData:aPhoto.shotImg];
        
        if ([ADHelper isIphone4]) {
            int posX = 6 +i *(46 +6);
            aPhotoView.frame = CGRectMake(posX, 10, 46, 46);
        } else {
            int posX = 12 +col *(_squareSize +12);
            int posY = 12 + row *(_squareSize +20);
            aPhotoView.frame = CGRectMake(posX, posY, _squareSize, _squareSize);
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
    NSInteger delIndex = tag - 10;
    
    UIView *delView = [self.photoViewArray objectAtIndex:delIndex];
    [self.photoViewArray removeObjectAtIndex:delIndex];
    [self.photoImgArray removeObjectAtIndex:delIndex];
    
    //self.photoImgArray = [ADMomSecertDAO readImage];
    

    __block CGPoint center = delView.center;
    __block CGPoint nextCenter ;
    [delView removeFromSuperview];
    
    for (NSInteger index = delIndex+1; index < 6; index ++) {
        
        UIView *nextView = [self viewWithTag:index + 10];
        nextView.tag = nextView.tag - 1;
        
        //NSLog(@"%d",nextView.tag);
        if (nextView) {
            
            [UIView animateWithDuration:0.2 animations:^{
                nextCenter = nextView.center;
                nextView.center = center;
                center = nextCenter;
            }];
            
        }else{
            break;
        }
    }
    
    if (self.photoViewArray.count == 5) {
        [self addPhotoBtn];
    }
    
    [self setAddBtnFrame];
}

- (void)addPhotoBtn
{
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setAddBtnFrame];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"孕妈日记加号"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_addBtn];
}

- (void)setAddBtnFrame
{
    int addBtnRow = (int)self.photoImgArray.count / 4;
    int addBtnCol = (int)self.photoImgArray.count % 4;

    if ([ADHelper isIphone4]) {
        int posX = 6 +(int)self.photoImgArray.count *(46 +6);
        _addBtn.frame = CGRectMake(posX, 10, 46, 46);
    } else {
        int posX = 12 + addBtnCol *(_squareSize +12);
        int posY = 12 + addBtnRow *(_squareSize +20);
        //NSLog(@"posY: %d", posY);
        
        [UIView animateWithDuration:0.2 animations:^{
            _addBtn.frame = CGRectMake(posX, posY, _squareSize, _squareSize);
        }];
        
    }
}

- (void)showAddPhotoBtn
{
    [self addPhotoBtn];
}

- (void)addAPhotoView:(UIImage *)aImage
{
    UIImageView *aImgView = [[UIImageView alloc]init];
    int row = (int)self.photoImgArray.count / 4;
    int col = (int)self.photoImgArray.count % 4;

    if ([ADHelper isIphone4]) {
        int posX = 6 +(int)self.photoImgArray.count *(46 +6);
        aImgView.frame = CGRectMake(posX, 10, 46, 46);
    } else {
        int posX = 12 + col *(_squareSize +12);
        int posY = 12 + row *(_squareSize +20);

        aImgView.frame = CGRectMake(posX, posY, _squareSize, _squareSize);
    }
    aImgView.image = aImage;
    [self addSubview:aImgView];
    
    [self.photoImgArray addObject:aImage];
    [self.photoViewArray addObject:aImgView];
    
    [self setAddBtnFrame];
    aImgView.userInteractionEnabled = YES;
    aImgView.tag = 10 +[self.photoViewArray indexOfObject:aImgView];
    
    UITapGestureRecognizer *photoTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self.parentVC action:@selector(tapPhotoView:)];
    [aImgView addGestureRecognizer:photoTap];
    
    if (self.photoImgArray.count == MAXPICNUM) {
        [_addBtn removeFromSuperview];
    }
}

- (void)addBtnClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(addNewImage)]) {
        [self.delegate addNewImage];
    }
}

@end