//
//  Mode.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "Mode.h"

@implementation Mode

@synthesize mode;
@synthesize modeName;
@synthesize modeid;

- (id)initWithMode:(NSString *)aMode ModeName:(NSString *)aModeName ModeId:(NSString *)aModeId{
    self = [super init];
    if (self) {
        mode = aMode;
        modeName = aModeName;
        modeid = aModeId;
    }
    return self;
}

@end
