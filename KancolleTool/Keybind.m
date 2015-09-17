//
//  Keybind.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "Keybind.h"

@implementation Keybind

@synthesize modeid;
@synthesize arrKeybindChild;

- (id)initWithModeid:(NSString *)aModeid KeybindChild:(NSMutableArray *)aKeybindChild {
    self = [super init];
    if (self) {
        modeid = aModeid;
        arrKeybindChild = [NSArray arrayWithArray:aKeybindChild];
    }
    return self;
}

@end


@implementation KeybindChild

@synthesize keybind;
@synthesize pointidArray;

- (id)initWithKeybind:(NSString *)aKeybind PointArray:(NSArray *)aPointarray {
    self = [super init];
    if (self) {
        keybind = aKeybind;
        pointidArray = [NSArray arrayWithArray:aPointarray];
    }
    return self;
}

@end


@implementation KeybindChildIndex

@synthesize keybind;
@synthesize keybindCount;
@synthesize index;

- (id)initWithKeybind:(NSString *)aKeybind KeybindCount:(NSInteger)aKeybindCount {
    self = [super init];
    if (self) {
        keybind = aKeybind;
        keybindCount = aKeybindCount;
        index = 0;
    }
    return self;
}

@end
