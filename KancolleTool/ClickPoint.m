//
//  ClickPoint.m
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "ClickPoint.h"
#import "KancolleData.h"
#import "WebAccess.h"

typedef struct {
    NSInteger mainIndex;
    NSInteger subIndex;
}ModeIndex;

@interface ClickPoint() {
    NSString *clickPath;
    NSString *subUpKey;
    NSString *subDownKey;
    BOOL isMainUpdownKeyFirstOn;
    BOOL isSubUpdownKeyFirstOn;
    NSInteger mainUpdownKeyIndex;
    NSInteger subUpdownKeyIndex;
    NSMutableArray *marrKeybindChildIndex;
    NSMutableArray *marrModeIndex;
}
@end

@implementation ClickPoint

// ---------------------------
// 定数定義
// ---------------------------
NSString * const blankString = @"";

@synthesize currentInputModeType;
@synthesize clickDownPoint;
@synthesize pointId;
@synthesize clickDownPointName;
@synthesize marrMultiPointKeybind;

// ---------------------------
// シングルトンクラス
// ---------------------------
+ (id) shareManager {
    
    static ClickPoint *shareData = nil;
    
    @synchronized(self) {
        if (shareData == nil) {
            shareData = [[ClickPoint alloc] init];
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
        currentInputModeType = NormalMode;
        mainUpdownKeyIndex = 0;
        subUpdownKeyIndex = 0;
        isMainUpdownKeyFirstOn = NO;
        isSubUpdownKeyFirstOn = NO;
        
        KancolleData *kdata = [KancolleData shareManager];
        Mode *modeObj = [kdata.marrMode objectAtIndex:currentInputModeType];
        
        for (Keybind *keybindObj in kdata.marrKeybind) {
            
            if ([keybindObj.modeid isEqualTo:modeObj.modeid]) {
                
                marrKeybindChildIndex = [NSMutableArray array];
                marrMultiPointKeybind = [NSMutableArray array];
                
                for (KeybindChild *keybindChildObj in keybindObj.arrKeybindChild) {

                    NSString *kb = keybindChildObj.keybind;
                    NSInteger count = [keybindChildObj.pointidArray count];
                    KeybindChildIndex *keybindChildIndexObj = [[KeybindChildIndex alloc] initWithKeybind:kb KeybindCount:count];
                    [marrKeybindChildIndex addObject:keybindChildIndexObj];
                    
                    if (1 < count) {
                        [marrMultiPointKeybind addObject:kb];
                    }
                }
                break;
            }
        }
        
        [self readPlist];
    }
    return self;
}

#pragma mark Internal Function
// ---------------------------
// Plist 読み込み
// ---------------------------
- (void)readPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Widget" ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    clickPath = [rootDic objectForKey:@"cliclick Path"];
    subUpKey = [rootDic objectForKey:@"Sub Up key"];
    subDownKey = [rootDic objectForKey:@"Sub Down key"];
}

// ---------------------------
// 名称  絶対座標取得
// 用途  画面上の絶対座標を検出する (basePoint: ウィジットの画面左上座標)
// ---------------------------
- (NSPoint) getAbsolutePointWithPositionX:(CGFloat)px PositionY:(CGFloat)py {
    
    WebAccess *web = [WebAccess shareManager];
    NSPoint point;
    
    switch (web.windowSizeType) {
        case SmallSize:
            point.x = web.kancolleWindowRect.origin.x + (px * 3 / 4);
            point.y = web.kancolleWindowRect.origin.y + (py * 3 / 4);
            break;
            
        case MiddleSize:
            point.x = web.kancolleWindowRect.origin.x + px;
            point.y = web.kancolleWindowRect.origin.y + py;
            break;
            
        case LargeSize:
            point.x = web.kancolleWindowRect.origin.x + (px * 3 / 2);
            point.y = web.kancolleWindowRect.origin.y + (py * 3 / 2);
            
        default:
            point.x = px;
            point.y = py;
            break;
    }

    return point;
}

#pragma mark external Function
// ---------------------------
// 名称  モード設定
// 用途  モード切り替え時にIndexの値を初期化
// ---------------------------
- (void) changeCurrentInputModeid:(NSString *)aModeid {
    
    mainUpdownKeyIndex = 0;
    subUpdownKeyIndex = 0;
    isMainUpdownKeyFirstOn = NO;
    isSubUpdownKeyFirstOn = NO;
    
    KancolleData *kdata = [KancolleData shareManager];
    
    NSUInteger idx = 0;
    for (Mode *modeObj in kdata.marrMode) {
        if ([aModeid isEqualToString:modeObj.modeid]) {
            // 現在のモードと同じ場合は何もしない
            if (idx == currentInputModeType) {
                return;
            }
            
            for (Keybind *keybindObj in kdata.marrKeybind) {
                if ([aModeid isEqualToString:keybindObj.modeid]) {
                    
                    marrKeybindChildIndex = [NSMutableArray array];
                    marrMultiPointKeybind = [NSMutableArray array];
                    
                    for (KeybindChild *keybindChildObj in keybindObj.arrKeybindChild) {
                        
                        NSString *keybind = keybindChildObj.keybind;
                        NSInteger count = [keybindChildObj.pointidArray count];
                        KeybindChildIndex *keybindChildIndexObj = [[KeybindChildIndex alloc] initWithKeybind:keybind KeybindCount:count];
                        [marrKeybindChildIndex addObject:keybindChildIndexObj];
                        
                        if (1 < count) {
                            [marrMultiPointKeybind addObject:keybind];
                        }
                    }
                    break;
                }
            }
            
            currentInputModeType = idx;
            break;
        }
        else {
            idx++;
        }
    }
}

// ---------------------------
// 名称  キーバインド座標検索
// 用途  絶対座標を加えたクリック座標を求める
// ---------------------------
- (BOOL) setClickDownPointWithKeybind:(NSString *)keybind {
 
    BOOL result = NO;
    
    if (keybind == nil || [keybind length] == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"searchPointWithKeybind"];
        [alert setMessageText:@"引数なし"];
        [alert runModal];
        return result;
    }
    
    KancolleData *kdata = [KancolleData shareManager];
    Mode *modeObj = [kdata.marrMode objectAtIndex:currentInputModeType];
    
    pointId = blankString;
    
    // keybind から pointid の取得
    for (Keybind *keybindObj in kdata.marrKeybind) {
        // 入力モード検索
        if ([modeObj.modeid isEqualToString:keybindObj.modeid]) {
            
            for (NSInteger i = 0; i < [keybindObj.arrKeybindChild count]; i++) {
                
                KeybindChild *keybindChildObj = [keybindObj.arrKeybindChild objectAtIndex:i];
                KeybindChildIndex *keybindChildIndexObj = [marrKeybindChildIndex objectAtIndex:i];

                // キーバインド検索
                if ([keybind isEqualToString:keybindChildObj.keybind]) {
                    // pointidを複数持つ場合、index(何番目を指しているか)を検索
                    if (keybindChildIndexObj.keybindCount == 1) {
                        pointId = [keybindChildObj.pointidArray objectAtIndex:keybindChildIndexObj.index];
                    }
                    else {
                        if ([keybind isEqualToString:@"j"]) {
                            // 最初の1回目は座標を動かさない
                            if (!isMainUpdownKeyFirstOn) {
                                isMainUpdownKeyFirstOn = YES;
                            }
                            else {
                                mainUpdownKeyIndex++;
                                if (mainUpdownKeyIndex == keybindChildIndexObj.keybindCount) {
                                    mainUpdownKeyIndex = 0;
                                }
                            }
                            pointId = [keybindChildObj.pointidArray objectAtIndex:mainUpdownKeyIndex];
                        }
                        else if ([keybind isEqualToString:subDownKey]) {
                            // 最初の1回目は座標を動かさない
                            if (!isSubUpdownKeyFirstOn) {
                                isSubUpdownKeyFirstOn = YES;
                            }
                            else {
                                subUpdownKeyIndex++;
                                if (subUpdownKeyIndex == keybindChildIndexObj.keybindCount) {
                                    subUpdownKeyIndex = 0;
                                }
                            }
                            pointId = [keybindChildObj.pointidArray objectAtIndex:subUpdownKeyIndex];
                        }
                        else if ([keybind isEqualToString:@"k"]) {
                            --mainUpdownKeyIndex;
                            if (mainUpdownKeyIndex == -1) {
                                mainUpdownKeyIndex = keybindChildIndexObj.keybindCount - 1;
                            }
                            pointId = [keybindChildObj.pointidArray objectAtIndex:mainUpdownKeyIndex];
                        }
                        else if ([keybind isEqualToString:subUpKey]) {
                            --subUpdownKeyIndex;
                            if (subUpdownKeyIndex == -1) {
                                subUpdownKeyIndex = keybindChildIndexObj.keybindCount - 1;
                            }
                            pointId = [keybindChildObj.pointidArray objectAtIndex:subUpdownKeyIndex];
                        }
                        else {
                            pointId = [keybindChildObj.pointidArray objectAtIndex:keybindChildIndexObj.index];
                            keybindChildIndexObj.index = keybindChildIndexObj.index + 1;
                            if (keybindChildIndexObj.index == keybindChildIndexObj.keybindCount) {
                                keybindChildIndexObj.index = 0;
                            }
                        }
                    }
                    result = YES;
                    break;
                }
            }
            break;
        }
    }
    
    // 座標の取得
    if (![pointId isEqualToString:blankString]) {
        for (Pointid *pointidObj in kdata.marrPointid) {
            if ([pointId isEqualToString:pointidObj.pointid]) {
                clickDownPoint = [self getAbsolutePointWithPositionX:pointidObj.positionX PositionY:pointidObj.positionY];
                clickDownPointName = pointidObj.pointidName;
                break;
            }
            else {
                clickDownPointName = blankString;
            }
        }
    }
    
    return result;
}

// ---------------------------
// 名称  座標検索
// 用途  絶対座標を加えたクリック座標を求める
// ---------------------------
- (BOOL) setClickDownPointWithPointid:(NSString *)pointid {

    BOOL result = NO;
    
    KancolleData *kdata = [KancolleData shareManager];

    for (Pointid *pointidObj in kdata.marrPointid) {
        if ([pointidObj.pointid isEqualTo:pointid]) {
            clickDownPoint = [self getAbsolutePointWithPositionX:pointidObj.positionX PositionY:pointidObj.positionY];
            clickDownPointName = pointidObj.pointidName;
            result = YES;
            break;
        }
        else {
            clickDownPointName = blankString;
        }
    }
    return result;
}

// ---------------------------
// 名称  ToolWindowへのマウス移動
// 用途  マクロを実行し終わった後、ToolWindowの座標に設定する
// ---------------------------
- (void) moveCursorToItemWithPosition:(NSRect)toolFrame itemPosition:(NSRect)itemFrame {
   
    CGFloat posx = toolFrame.origin.x + itemFrame.origin.x + itemFrame.size.width / 2;
    
    // フルスクリーンの高さ
    CGFloat mainHeight = [[NSScreen mainScreen] frame].origin.y + [[NSScreen mainScreen] frame].size.height;
    // 当アプリのウインドウの位置
    CGFloat toolWindowPosY = mainHeight - (toolFrame.origin.y + toolFrame.size.height);
    // itemの位置
    CGFloat itemPosY = toolFrame.size.height - (itemFrame.origin.y + itemFrame.size.height / 2);
    // 上下逆にした場合の位置 (23はフレイムバーの高さ)
    CGFloat posy = toolWindowPosY + itemPosY;
    
    NSString *param = [NSString stringWithFormat:@"m:%.0f,%.0f", posx, posy];
    NSArray *args = [NSArray arrayWithObjects:param, nil];
    
    NSTask *task = [NSTask launchedTaskWithLaunchPath:clickPath arguments:args];
    [task waitUntilExit];
}


// ---------------------------
// 名称  座標クリック
// 用途  KPointクラスにセットされた座標をクリックする
// 引数  第1:BOOL YES:クリックする NO;クリックしない(マウスの移動だけ)
//      第2:float 待機時間
//      第3:int クリック回数
// ---------------------------
- (void) clickPointWithIsClick:(BOOL)isClickDown {
    
    NSString *param;
    
    NSPoint p = NSMakePoint(0, 0);
    if (clickDownPoint.x == p.y && clickDownPoint.y == p.y) {

        // 初期ポジションを設定
        KancolleData *kdata = [KancolleData shareManager];
        for (Pointid *pointidObj in kdata.marrPointid) {
            if ([pointidObj.pointid isEqualToString:@"PWdgetGameStart"]) {
                clickDownPoint = [self getAbsolutePointWithPositionX:pointidObj.positionX PositionY:pointidObj.positionY];
                clickDownPointName = pointidObj.pointidName;
                break;
            }
            else {
                clickDownPointName = blankString;
            }
        }
        
        // return;
    }
    
    // シェル実行用の引数(座標)を作成する
    if (isClickDown) {
        // 座標をクリック
        param = [NSString stringWithFormat:@"c:%.0f,%.0f", clickDownPoint.x, clickDownPoint.y];
    }
    else {
        // 座標に移動
        param = [NSString stringWithFormat:@"m:%.0f,%.0f", clickDownPoint.x, clickDownPoint.y];
    }
    
    NSArray *args = [NSArray arrayWithObjects:param, nil];
    
    NSTask *task = [NSTask launchedTaskWithLaunchPath:clickPath arguments:args];
    // 実行終了まで待つ
    [task waitUntilExit];
}
@end
