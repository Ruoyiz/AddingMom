//
//  ADIcon.m
//  PregnantAssistant
//
//  Created by D on 14-9-16.
//  Copyright (c) 2014年 Adding. All rights reserved.
//

#import "ADIcon.h"

static NSString *kTitle = @"kTitle";
static NSString *kUImg = @"kUimg";
static NSString *kSImg = @"kSimg";
static NSString *kMyVc = @"kMyVc";
static NSString *kIsWeb = @"kIsWeb";

@implementation ADIcon

-(id)initWithTitle:(NSString *)aTitle
           andUImg:(NSString *)uImg
           andSImg:(NSString *)sImg
          andIsWeb:(BOOL)aWeb
             andVC:(NSString *)aVc
{
    if (self = [super init]) {
        self.title = aTitle;
        
        NSString *big = [NSString stringWithFormat:@"%@大", aTitle];
        
        self.uImg = [UIImage imageNamed:big];
        self.sImg = [UIImage imageNamed:sImg];
        
        NSString *smallTitle = [NSString stringWithFormat:@"%@小", aTitle];
        self.smallImg = [UIImage imageNamed:smallTitle];
        self.isWeb = aWeb;
        self.myVc = aVc;
    }
    return self;
}

-(id)initWithTitle:(NSString *)aTitle
           andUImg:(NSString *)uImg
           andSImg:(NSString *)sImg
             andVC:(NSString *)aVc
{
    if (self = [super init]) {
        self.title = aTitle;
        NSString *big = [NSString stringWithFormat:@"%@大", aTitle];
        self.uImg = [UIImage imageNamed:big];

        self.sImg = [UIImage imageNamed:sImg];
        self.myVc = aVc;
        NSString *smallTitle = [NSString stringWithFormat:@"%@小", aTitle];
        self.smallImg = [UIImage imageNamed:smallTitle];
    }
    return self;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title   forKey:kTitle];
    
    [aCoder encodeObject:UIImagePNGRepresentation(self.uImg) forKey:kUImg];
    [aCoder encodeObject:UIImagePNGRepresentation(self.sImg) forKey:kSImg];
    [aCoder encodeObject:self.myVc       forKey:kMyVc];
    [aCoder encodeBool:self.isWeb forKey:kIsWeb];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
    {
        self.title = [aDecoder decodeObjectForKey:kTitle];
        
        NSData *pngData = [aDecoder decodeObjectForKey:kUImg];
        self.uImg = [[UIImage alloc] initWithData:pngData];
        
        NSData *pngData2 = [aDecoder decodeObjectForKey:kSImg];
        self.sImg = [[UIImage alloc] initWithData:pngData2];

        self.myVc  = [aDecoder decodeObjectForKey:kMyVc];
        
        self.isWeb = [aDecoder decodeBoolForKey:kIsWeb];
    }
    return self;
}

@end
