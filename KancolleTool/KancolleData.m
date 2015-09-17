//
//  KancolleData.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "KancolleData.h"

@implementation KancolleData

@synthesize marrMode;
@synthesize marrPointid;
@synthesize marrKeybind;
@synthesize marrMacro;
@synthesize marrPointidToMode;

// ---------------------------
// シングルトンクラス
// ---------------------------
+ (id)shareManager {
    
    static KancolleData *shareData = nil;
    
    @synchronized(self) {
        if (shareData == nil) {
            shareData = [[KancolleData alloc] init];
        }
    }
    return shareData;
}

// ---------------------------
// 初期化
// ---------------------------
- (id) init {
    
    self = [super init];
    if (self) {
        [self readPlist];
    }
    return self;
}

// ---------------------------
// read plist
// ---------------------------
- (void)readPlist {
    
    [self readModePlist];
    [self readPointidPlist];
    [self readKeybindPlist];
    [self readMacroPlist];
    [self readPointidToModePlist];
}

// ---------------------------
// read Mode plist
// ---------------------------
- (void) readModePlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:@"Mode" ofType:@"plist"];
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:path];
    
    marrMode = [NSMutableArray array];
    
    for (NSDictionary *element in arrPlist) {
        NSString *mode = [element objectForKey:@"mode"];
        NSString *modeName = [element objectForKey:@"modeName"];
        NSString *modeid = [element objectForKey:@"modeid"];
        
        Mode *modeObj = [[Mode alloc] initWithMode:mode ModeName:modeName ModeId:modeid];
        [marrMode addObject:modeObj];
    }
}

// ---------------------------
// read Pointid plist
// ---------------------------
- (void) readPointidPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Pointid" ofType:@"plist"];
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:path];
    
    marrPointid = [NSMutableArray array];
    
    for (NSDictionary *element in arrPlist) {
        NSString *pointid = [element objectForKey:@"pointid"];
        NSString *pointidName = [element objectForKey:@"pointidName"];
        CGFloat positionX = [[element objectForKey:@"positionX"] floatValue];
        CGFloat positionY = [[element objectForKey:@"positionY"] floatValue];
        
        Pointid *pointidObj = [[Pointid alloc] initWithPointid:pointid PointidName:pointidName PositionX:positionX PositionY:positionY];
        [marrPointid addObject:pointidObj];
    }
}

// ---------------------------
// read Keybind plist
// ---------------------------
- (void) readKeybindPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Keybind" ofType:@"plist"];
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:path];
    
    marrKeybind = [NSMutableArray array];
    
    for (NSDictionary *element in arrPlist) {
        NSString *modeid = [element objectForKey:@"modeid"];
        NSArray *arrKeybindPointid = [element objectForKey:@"keybindPointid"];
        
        NSMutableArray *marrKeybindChild = [NSMutableArray array];
        
        for (NSDictionary *childelement in arrKeybindPointid) {
            NSString *keybind = [childelement objectForKey:@"keybind"];
            NSArray *marrpid = [childelement objectForKey:@"pointid"];
            
            KeybindChild *keybindChildObj = [[KeybindChild alloc] initWithKeybind:keybind PointArray:marrpid];
            [marrKeybindChild addObject:keybindChildObj];
        }
        
        Keybind *keybindObj = [[Keybind alloc] initWithModeid:modeid KeybindChild:marrKeybindChild];
        [marrKeybind addObject:keybindObj];
    }
}

// ---------------------------
// read Macro plist
// ---------------------------
- (void) readMacroPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Macro" ofType:@"plist"];
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:path];
    
    marrMacro = [NSMutableArray array];
    
    for (NSDictionary *element in arrPlist) {
        NSString *macroid = [element objectForKey:@"macroid"];
        NSString *macroKeybind = [element objectForKey:@"macroKeybind"];
        NSString *macroName = [element objectForKey:@"macroName"];
        NSString *macroCategory = [element objectForKey:@"macroCategory"];
        BOOL macroDispState = [[element objectForKey:@"macroDispState"] boolValue];
        NSString *modeid = [element objectForKey:@"modeid"];
        NSArray *arrMacro = [element objectForKey:@"macroOperation"];
        
        NSMutableArray *marrMacroChild = [NSMutableArray array];
        
        for (NSDictionary *childelement in arrMacro) {
            NSString *pointid = [childelement objectForKey:@"pointid"];
            BOOL isClick = [[childelement objectForKey:@"isClick"] boolValue];
            float waitsec = [[childelement objectForKey:@"waitsec"] floatValue];
            int repeat = [[childelement objectForKey:@"repeat"] intValue];
            
            MacroChild *macroChildObj = [[MacroChild alloc] initWithPointid:pointid isClick:isClick Waitsec:waitsec Repeat:repeat];
            [marrMacroChild addObject: macroChildObj];
        }
        
        Macro *macroObj = [[Macro alloc] initWithMacroid:macroid Keybind:macroKeybind MacroName:macroName MacroCategory:macroCategory MacroChilde:marrMacroChild MacroDispState:macroDispState Modeid:modeid];
        
        [marrMacro addObject:macroObj];
    }
}

// ---------------------------
// read PointidToMode plist
// ---------------------------
- (void) readPointidToModePlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *path = [bundle pathForResource:@"PointidToMode" ofType:@"plist"];
    NSArray *arrPlist = [NSArray arrayWithContentsOfFile:path];
    
    marrPointidToMode = [NSMutableArray array];
    
    for (NSDictionary *element in arrPlist) {
        NSString *pointid = [element objectForKey:@"pointid"];
        NSString *modeid = [element objectForKey:@"modeid"];
        BOOL backmode = [[element objectForKey:@"backmode"] boolValue];
        
        PointidToMode *pointidToModeObj = [[PointidToMode alloc] initWithPointid:pointid Modeid:modeid BackMode:backmode];
        [marrPointidToMode addObject:pointidToModeObj];
    }
}

@end
