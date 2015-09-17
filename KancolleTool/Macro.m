//
//  Macro.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "Macro.h"

@implementation Macro

@synthesize macroid;
@synthesize macroKeybind;
@synthesize macroName;
@synthesize macroCategory;
@synthesize arrMacroChild;
@synthesize macroDispState;
@synthesize modeid;

- (id)initWithMacroid:(NSString *)aMacroid Keybind:(NSString *)aMacroKeybind MacroName:(NSString *)aMacroName MacroCategory:(NSString *)aMacroCategory MacroChilde:(NSMutableArray *)aMacroChild MacroDispState:(BOOL)aDispState Modeid:(NSString *)aModeid {
    self = [super init];
    if (self) {
        macroid = aMacroid;
        macroKeybind = aMacroKeybind;
        macroName = aMacroName;
        macroCategory = aMacroCategory;
        arrMacroChild = [NSArray arrayWithArray:aMacroChild];
        macroDispState = aDispState;
        modeid = aModeid;
    }
    return self;
}

@end


@implementation MacroChild

@synthesize pointid;
@synthesize click;
@synthesize waitsec;
@synthesize repeat;

- (id)initWithPointid:(NSString *)aPointid isClick:(BOOL)aClick Waitsec:(float)aWaitsec Repeat:(int)aRepeat {
    self = [super self];
    if (self) {
        pointid = aPointid;
        click = aClick;
        waitsec = aWaitsec;
        repeat = aRepeat;
    }
    return self;
}

@end