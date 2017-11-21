//
//  ADEmptyView.m
//  PregnantAssistant
//
//  Created by chengfeng on 15/6/30.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADEmptyView.h"
#import "ADGetTextSize.h"

typedef void (^MyBlock) (void);

@implementation ADEmptyView{
    UITextView *_contentTextView;
    UIImageView *_imageView;
    MyBlock _block;
    UIButton *_contentButton;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViewWithFrame:frame];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame attributeString:(NSAttributedString *)attributeString imageName:(UIImage *)imageName textClicked:(void (^) (void))textClickedBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _attributeString = attributeString;
        _image = imageName;
        _block = textClickedBlock;
    }
    
    [self loadSubViewWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _image = image;
        
        [self loadSubViewWithFrame:frame];
    }
    
    return self;
}

- (void)loadSubViewWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    _imageView.contentMode = UIViewContentModeCenter;

    if (_image) {
        //[_imageView setImage:_image forState:UIControlStateNormal];
        _imageView.image = _image;
    }
    [self addSubview:_imageView];
    
    if (_attributeString || _title) {
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, frame.size.width - 30, 100)];
        if (_title) {
            _contentTextView.text = _title;
            _contentTextView.textColor = [UIColor emptyViewTextColor];
        }else if (_attributeString){
            _contentTextView.attributedText = _attributeString;
        }
        _contentTextView.userInteractionEnabled = NO;
        _contentTextView.font = [UIFont ADTraditionalFontWithSize:15];
        
        [self addSubview:_contentTextView];
        _contentButton = [[UIButton alloc] initWithFrame:_contentTextView.frame];
        [_contentButton addTarget:self action:@selector(textClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_contentButton];
    }
    
    [self setContentCenter];
}

- (void)textClicked
{
    if (_block && self.superview != nil) {
        _block();
    }
}

- (void)setContentCenter
{
    CGRect frame = self.frame;
    
    _contentTextView.backgroundColor = [UIColor clearColor];
    _contentTextView.textAlignment = NSTextAlignmentCenter;

    CGSize constraintSize = CGSizeMake(_contentTextView.frame.size.width, 100);
    CGSize size = [_contentTextView sizeThatFits:constraintSize];
    
    
    CGFloat labelHeight = size.height;
    _imageView.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0 - (20 + labelHeight) / 2.0);
    _contentTextView.frame = CGRectMake(15, 0, frame.size.width - 30, labelHeight);
    _contentTextView.center = CGPointMake(_imageView.center.x, _imageView.center.y + 30 + (labelHeight)/2.0);
    
    _contentButton.frame = _contentTextView.frame;
}

- (void)setAttributeString:(NSAttributedString *)attributeString
{
    _attributeString = attributeString;
    _title = nil;
    _contentTextView.attributedText = _attributeString;
    
    [self setContentCenter];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _attributeString = nil;
    _contentTextView.attributedText = nil;
    _contentTextView.text = _title;
    _contentTextView.textColor = [UIColor emptyViewTextColor];
    [self setContentCenter];
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
    [self setContentCenter];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
