//
//  PointidToMode.m
//  KancolleTool
//
//  Created by Jonouchi Kouyo on 2015/07/15.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "PointidToMode.h"

@implementation PointidToMode

@synthesize pointid;
@synthesize modeid;
@synthesize backmode;

- (id)initWithPointid:(NSString *)aPointid Modeid:(NSString *)aModeid BackMode:(BOOL)aBackMode {
    self = [super init];
    if (self) {
        pointid = aPointid;
        modeid = aModeid;
        backmode = aBackMode;
    }
    return self;
}

@end
