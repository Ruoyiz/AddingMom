//
//  ADShareHelper.m
//  PregnantAssistant
//
//  Created by D on 14/12/2.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADShareHelper.h"

#define maxTryCnt 100
@implementation ADShareHelper

+ (ADShareHelper *)shareInstance {
    
    static ADShareHelper *sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[ADShareHelper alloc] init];
    });
    
    return sharedClient;
}

- (void)reduceImageWithImage:(UIImage *)aImage
{
    NSData *imgData = UIImageJPEGRepresentation(aImage, 1);
//    NSLog(@"压缩前的尺寸 %f,%f",aImage.size.width,aImage.size.height);
//    NSLog(@"压缩前%f",imgData.length / 1024.0);
    
    while (imgData.length / 1024.0 >= 28) {
        aImage = [self imageWithImageSimple:aImage scaledToSize:CGSizeMake(aImage.size.width/1.2, aImage.size.height/1.2)];
        imgData = UIImageJPEGRepresentation(aImage, 1);
    }
    
    _thumbImg = aImage;
//    imgData = UIImageJPEGRepresentation(_thumbImg, 1);
//    NSLog(@"压缩后%f",imgData.length / 1024.0);
//    NSLog(@"压缩前的尺寸 %f,%f",_thumbImg.size.width,_thumbImg.size.height);
}

- (void)sendLinkToWeixinWithShare_Link:(NSString *)share_link
                                 title:(NSString *)title
                           description:(NSString *)description
                             shareType:(ShareType)type
                                 image:(UIImage *)image
                                 isImg:(BOOL)isImg
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    //[self reduceIsBigger32KBWithImg:image];
//    NSLog(@"lengt:%ld", imgData.length);
    
//    if ((imgData.length/1024) >= 32) {
//        _thumbImg = [UIImage imageNamed:@"AppIcon60x60"];
//        imgData = UIImageJPEGRepresentation(_thumbImg, 0.02);
//    }
    [self reduceImageWithImage:image];

    if (isImg) {
        NSData *imgData = UIImagePNGRepresentation(image);//UIImageJPEGRepresentation(image, 1);
        [message setThumbImage:_thumbImg];

        WXImageObject *ext = [WXImageObject object];
        ext.imageData = imgData;
        message.mediaObject = ext;
        
    } else {
        //NSData *imgData = UIImageJPEGRepresentation(_thumbImg, 1);

        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = share_link;
        
        message.mediaObject = ext;
        
        [message setThumbImage:_thumbImg];
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    switch (type) {
        case weixin_share_tpye: {
            req.scene = WXSceneSession;                                                                    
        } break;
        case friend_share_type: {
            req.scene = WXSceneTimeline;
        } break;
            
        default:
            break;
    }

    [WXApi sendReq:req];
}

- (void)sendWeiboShareWithDes:(NSString *)aDes andImg:(UIImage *)aImg
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kSinaWeiboRedirectURI;
    authRequest.scope = @"all";
    [self reduceImageWithImage:aImg];
    //[self reduceIsBigger32KBWithImg:aImg];
    WBMessageObject *message = [WBMessageObject message];
    message.text = aDes;
    
    if (aImg) {
        WBImageObject *image = [WBImageObject object];
        image.imageData = UIImageJPEGRepresentation(_thumbImg, 1.0);
        message.imageObject = image;
    }
    ADAppDelegate *myDelegate = (ADAppDelegate*)[[UIApplication sharedApplication] delegate];
    WBSendMessageToWeiboRequest *request =
    [WBSendMessageToWeiboRequest requestWithMessage:message
                                           authInfo:authRequest
                                       access_token:myDelegate.wbtoken];
    [WeiboSDK sendRequest:request];
}

- (void)senWeiBoShareWithTitle:(NSString *)title urlString:(NSString *)urlString image:(UIImage *)aImg
{
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kSinaWeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@",title];;
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = [NSString stringWithFormat:@"1"];
    webpage.title = [NSString stringWithFormat:@"%@",title];
    webpage.description = @"";
    [self reduceImageWithImage:aImg];
    webpage.thumbnailData = UIImageJPEGRepresentation(_thumbImg,1);

    webpage.webpageUrl = urlString;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:@""];
    
    [WeiboSDK sendRequest:request];
    
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
