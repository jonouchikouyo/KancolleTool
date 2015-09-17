//
//  KeybindTable.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "KeybindTable.h"

@implementation KeybindTable

@synthesize no;
@synthesize keybind;
@synthesize keybindName;

- (id) initWithNo:(NSInteger)aNo Keybind:(NSString *)aKeybind KeybindName:(NSString *)aKeybindName {
    self = [super self];
    if (self) {
        no = aNo;
        keybind = aKeybind;
        keybindName = aKeybindName;
    }
    return self;
}

@end
