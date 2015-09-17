//
//  Macro.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Macro : NSObject

@property (nonatomic, copy) NSString *macroid;
@property (nonatomic, copy) NSString *macroKeybind;
@property (nonatomic, copy) NSString *macroName;
@property (nonatomic, copy) NSString *macroCategory;
@property (nonatomic, copy) NSArray *arrMacroChild;
@property (nonatomic) BOOL macroDispState;
@property (nonatomic, copy) NSString *modeid;

-(id) initWithMacroid:(NSString *)aMacroid Keybind:(NSString *)aMacroKeybind MacroName:(NSString *)aMacroName MacroCategory:(NSString *) aMacroCategory MacroChilde:(NSMutableArray *)aMacroChild MacroDispState:(BOOL) aDispState Modeid:(NSString *)aModeid;
@end


@interface MacroChild : NSObject

@property (nonatomic, copy) NSString *pointid;
@property (nonatomic, getter=isClick) BOOL click;
@property (nonatomic) float waitsec;
@property (nonatomic) int repeat;

- (id)initWithPointid:(NSString *)aPointid isClick:(BOOL)aClick Waitsec:(float)aWaitsec Repeat:(int)aRepeat;

@end