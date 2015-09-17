//
//  Pointid.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "Pointid.h"

@implementation Pointid

@synthesize pointid;
@synthesize pointidName;
@synthesize positionX;
@synthesize positionY;

-(id) initWithPointid:(NSString *)aPointid PointidName:(NSString *)aPoiontidName PositionX:(CGFloat)aPositionX PositionY:(CGFloat)aPositionY {
    
    self = [super init];
    if (self) {
        pointid = aPointid;
        pointidName = aPoiontidName;
        positionX = aPositionX;
        positionY = aPositionY;
    }
    return self;
}

@end
