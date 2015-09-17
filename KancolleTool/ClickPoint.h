//
//  ClickPoint.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

// 入力モード
typedef NS_ENUM(NSUInteger, CurrentInputMode) {
    NormalMode = 0,
    ShutugekiMode,
    EnshuMode,
    EnseiMode,
    NinmuMode,
    HenseiMode,
    HokyuMode,
    KaisoMode,
    KaisoSoubiMode,
    KaisoKindaikaMode,
    NyukyoMode,
    KenzoMode,
    KaitaiMode,
    KaihatsuMode,
    HaikiMode
};

@interface ClickPoint : NSObject

@property (nonatomic, readonly) CurrentInputMode currentInputModeType;
@property (nonatomic, readonly) NSPoint clickDownPoint;
@property (nonatomic ,readonly) NSString *pointId;
@property (nonatomic ,copy) NSString *clickDownPointName;
@property (nonatomic, readonly) NSMutableArray *marrMultiPointKeybind;

// シングルトンクラス
+ (id) shareManager;

- (void) readPlist;
- (void) changeCurrentInputModeid:(NSString *)aModeid;
- (BOOL) setClickDownPointWithKeybind:(NSString *)keybind;
- (BOOL) setClickDownPointWithPointid:(NSString *)pointid;
- (void) clickPointWithIsClick:(BOOL)isClickDown;
- (void) moveCursorToItemWithPosition:(NSRect)toolFrame itemPosition:(NSRect)itemFrame;

@end
