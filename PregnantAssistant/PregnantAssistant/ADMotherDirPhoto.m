//
//  ADMotherDirPhoto.m
//  PregnantAssistant
//
//  Created by ruoyi_zhang on 15/8/19.
//  Copyright (c) 2015年 Adding. All rights reserved.
//

#import "ADMotherDirPhoto.h"

@implementation ADMotherDirPhoto

- (instancetype)initWithImageName:(NSString *)imageName ImageDate:(UIImage *)image isUpload:(BOOL)isupload{
    
    if (self = [super init]) {
        self.imageData = UIImageJPEGRepresentation(image, 0.75);
        self.imageName = imageName;
        self.isUpload = isupload;
        self.uid = [NSUserDefaults standardUserDefaults].addingUid;
    }
    return self;
}

@end
