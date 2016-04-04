//
//  OtherPeopleInfoItem.m
//  MmiaHD
//
//  Created by twksky on 15/4/14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "OtherPeopleInfoItem.h"

@implementation OtherPeopleInfoItem

static OtherPeopleInfoItem *otherPeopleInfoItem;

+(OtherPeopleInfoItem *)sharedOtherPeopleInfoItem{
    if (!otherPeopleInfoItem) {
        otherPeopleInfoItem = [[OtherPeopleInfoItem alloc]init];
    }
    return otherPeopleInfoItem;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    if (otherPeopleInfoItem == nil) {
        otherPeopleInfoItem = [super allocWithZone:zone];
    }
    return otherPeopleInfoItem;
}

@end
