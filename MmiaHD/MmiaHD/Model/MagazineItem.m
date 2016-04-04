//
//  MagazineItem.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MagazineItem.h"

@implementation MagazineItem

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        self.aId = [decoder decodeIntegerForKey:@"aId"];
        self.userId = [decoder decodeIntegerForKey:@"userId"];
        self.magazineId = [decoder decodeIntegerForKey:@"magazineId"];
        self.titleText = [decoder decodeObjectForKey:@"titleText"];
        self.pictureImageUrl = [decoder decodeObjectForKey:@"pictureImageUrl"];
        self.imageWidth = [decoder decodeFloatForKey:@"imageWidth"];
        self.imageHeight = [decoder decodeFloatForKey:@"imageHeight"];
        self.likeNum = [decoder decodeIntegerForKey:@"likeNum"];
        self.subMagezineArray = [decoder decodeObjectForKey:@"subMagezineArray"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.aId forKey:@"aId"];
    [encoder encodeInteger:self.userId forKey:@"userId"];
    [encoder encodeInteger:self.magazineId forKey:@"magazineId"];
    [encoder encodeObject:self.titleText forKey:@"titleText"];
    [encoder encodeObject:self.pictureImageUrl forKey:@"pictureImageUrl"];
    [encoder encodeFloat:self.imageWidth forKey:@"imageWidth"];
    [encoder encodeFloat:self.imageHeight forKey:@"imageHeight"];
    [encoder encodeInteger:self.likeNum forKey:@"likeNum"];
    [encoder encodeObject:self.subMagezineArray forKey:@"subMagezineArray"];
}

@end
