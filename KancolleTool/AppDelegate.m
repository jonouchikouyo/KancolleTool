//
//  AppDelegate.m
//  KancolleTool
//
//  Created by Jonouchi Kouyo on 2015/07/14.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "AppDelegate.h"
#import "KancolleData.h"
#import "WebAccess.h"
#import "ClickPoint.h"
#import "KeybindTable.h"

@interface AppDelegate () {
    NSMutableArray *marrKeybindTable;
    NSString *popupDefaultTitle;
    NSString *popupDefaultShtgkArea;
    NSString *preModeid;
    NSString *bokouPointid;
    float longClickSec;
}
// IBOutlet
@property (weak) IBOutlet NSArrayController *arrayController;
@property (weak) IBOutlet NSSearchField *searchKeybind;
@property (weak) IBOutlet NSButton *buttonClick;
@property (weak) IBOutlet NSButton *buttonLongClick;
@property (weak) IBOutlet NSButton *buttonMacroBokou;
@property (weak) IBOutlet NSButton *buttonEnseiBokou;
@property (weak) IBOutlet NSButton *buttonShtgkBokou;
@property (weak) IBOutlet NSPopUpButton *popupMacroBokou;
@property (weak) IBOutlet NSPopUpButton *popupMacroEnsei;
@property (weak) IBOutlet NSPopUpButton *popupShtgkArea;
@property (weak) IBOutlet NSTextField *labelInputMode;
@property (weak) IBOutlet NSTextField *labelPointidName;
@property (weak) IBOutlet NSTextField *labelWaitsec;
@property (weak) IBOutlet NSTextField *labelClickTime;
@property (weak) IBOutlet NSStepper *stepperClickTime;
@property (weak) IBOutlet NSTableView *tableKeybind;
@property (weak) IBOutlet NSTextField *labelKeyCheck;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize arrayController;
@synthesize searchKeybind;
@synthesize buttonClick;
@synthesize buttonLongClick;
@synthesize buttonMacroBokou;
@synthesize buttonEnseiBokou;
@synthesize buttonShtgkBokou;
@synthesize popupMacroBokou;
@synthesize popupMacroEnsei;
@synthesize popupShtgkArea;
@synthesize labelInputMode;
@synthesize labelPointidName;
@synthesize labelWaitsec;
@synthesize labelClickTime;
@synthesize stepperClickTime;
@synthesize tableKeybind;
@synthesize labelKeyCheck;
@synthesize window;

// ---------------------------
// 定数定義
// ---------------------------
static NSString *blankString = @"";
static NSString *spaceString = @" ";
static NSString *errMsgWindow = @"ウインドウが存在しません";
static NSString *errMsgActive = @"アクティブ化失敗";
static NSString *errMsgPointid = @"座標がみつかりません";
static NSString *openString = @"open";
static NSString *quitString = @"quit";

// ---------------------------
// 初期化
// ---------------------------
#pragma mark Default application process
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // 前回の起動位置の保存
    [self.window setFrameAutosaveName:@"KancolleKey"];
    
    // keybindTable(TableView)の初期化
    [self inputModeInitialize];
    
    popupDefaultTitle = @"マクロ選択";
    popupDefaultShtgkArea = @"エリア選択";
    
    KancolleData *kdata = [KancolleData shareManager];
    
    // popup Button の設定
    NSMenu *menuMacroBokou = [[NSMenu alloc] init];
    NSMenu *menuMacroEnsei = [[NSMenu alloc] init];
    NSMenu *menuMacroShtgkArea = [[NSMenu alloc] init];
    
    NSMenuItem *menuItem;
    
    menuItem= [[NSMenuItem alloc] initWithTitle:popupDefaultTitle action:nil keyEquivalent:blankString];
    [menuMacroBokou addItem:menuItem];

    menuItem = [NSMenuItem separatorItem];
    [menuMacroBokou addItem:menuItem];
    
    menuItem= [[NSMenuItem alloc] initWithTitle:popupDefaultTitle action:nil keyEquivalent:blankString];
    [menuMacroEnsei addItem:menuItem];
    
    menuItem = [NSMenuItem separatorItem];
    [menuMacroEnsei addItem:menuItem];
    
    menuItem= [[NSMenuItem alloc] initWithTitle:popupDefaultShtgkArea action:nil keyEquivalent:blankString];
    [menuMacroShtgkArea addItem:menuItem];
    
    menuItem = [NSMenuItem separatorItem];
    [menuMacroShtgkArea addItem:menuItem];

    NSString *bokouMacroCategory = blankString;
    NSString *enseiMacroCategory = blankString;
    NSString *shtgkArea1stChar = blankString;

    for (Macro *macroObj in kdata.marrMacro) {
        if ([macroObj.macroCategory isEqualTo:@"Bokou"] && macroObj.macroDispState) {

            // macroidの先頭5文字目が1つ前と異なる場合(エリアが異なる場合)はセパレータを入れる
            NSString *macroNameString = [macroObj.macroid substringToIndex:5];
            if (![macroNameString isEqualToString:bokouMacroCategory] && ![bokouMacroCategory isEqualToString:blankString]) {
                menuItem = [NSMenuItem separatorItem];
                [menuMacroBokou addItem:menuItem];
            }
            bokouMacroCategory = macroNameString;
            
            menuItem = [[NSMenuItem alloc] initWithTitle:macroObj.macroName action:nil keyEquivalent:@""];
            [menuMacroBokou addItem:menuItem];
        }
        else if ([macroObj.macroCategory isEqualTo:@"Khatu"] && macroObj.macroDispState) {
           
            // macroidの先頭5文字目が1つ前と異なる場合(エリアが異なる場合)はセパレータを入れる
            NSString *macroNameString = [macroObj.macroid substringToIndex:5];
            if (![macroNameString isEqualToString:bokouMacroCategory] && ![bokouMacroCategory isEqualToString:blankString]) {
                menuItem = [NSMenuItem separatorItem];
                [menuMacroBokou addItem:menuItem];
            }
            bokouMacroCategory = macroNameString;
            
            menuItem = [[NSMenuItem alloc] initWithTitle:macroObj.macroName action:nil keyEquivalent:@""];
            [menuMacroBokou addItem:menuItem];
        }
        else if ([macroObj.macroCategory isEqualTo:@"Ensei"] && macroObj.macroDispState) {
            
            // macroidの先頭6文字目が1つ前と異なる場合(エリアが異なる場合)はセパレータを入れる
            NSString *macroNameString = [macroObj.macroid substringWithRange:NSMakeRange(5, 1)];
            if (![macroNameString isEqualToString:enseiMacroCategory] && ![enseiMacroCategory isEqualToString:blankString]) {
                menuItem = [NSMenuItem separatorItem];
                [menuMacroEnsei addItem:menuItem];
            }
            enseiMacroCategory = macroNameString;
            
            menuItem = [[NSMenuItem alloc] initWithTitle:macroObj.macroName action:nil keyEquivalent:@""];
            [menuMacroEnsei addItem:menuItem];
        }
        else if ([macroObj.macroCategory isEqualTo:@"ShtgkArea"] && macroObj.macroDispState) {
            
            // macroidの先頭から5文字目が1つ前と異なる場合(エリアが異なる場合)はセパレータを入れる
            NSString *macroNameString = [macroObj.macroid substringWithRange:NSMakeRange(5, 1)];
            if (![macroNameString isEqualToString:shtgkArea1stChar] && ![shtgkArea1stChar isEqualToString:blankString]) {
                menuItem = [NSMenuItem separatorItem];
                [menuMacroShtgkArea addItem:menuItem];
            }
            shtgkArea1stChar = macroNameString;
            
            menuItem = [[NSMenuItem alloc] initWithTitle:macroObj.macroName action:nil keyEquivalent:@""];
            [menuMacroShtgkArea addItem:menuItem];
        }

    }
    // ポップアップにマクロを設定
    [popupMacroBokou setMenu:menuMacroBokou];
    [popupMacroEnsei setMenu:menuMacroEnsei];
    [popupShtgkArea setMenu:menuMacroShtgkArea];
    
    // Plist読み込み
    [self readPlist];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

#pragma mark Original Function
// --------------------------
// Plist 読み込み
// --------------------------
- (void)readPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Widget" ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    // LongClickSec 時間の読み取り
    longClickSec = [[rootDic objectForKey:@"Long click sec"] floatValue];
    
    // Click Timeのラベルに時間を設定
    labelClickTime.stringValue = [NSString stringWithFormat:@"%.0f", longClickSec];
    stepperClickTime.floatValue = longClickSec;

    // bokouPointid 読み取り
    bokouPointid = [rootDic objectForKey:@"Initial pointid"];
}

// --------------------------
// 名称 画面を最前面に移動する
// --------------------------
- (void)frontMostWindow {
    //ウインドウを最前面に移動する
    [[NSRunningApplication currentApplication] activateWithOptions:(NSApplicationActivateAllWindows | NSApplicationActivateIgnoringOtherApps)];
}

- (void) frontMostWindowSearchText:(NSString *)searchString LabelPointName:(NSString *)pointNameString {
    searchKeybind.stringValue = searchString;
    if (pointNameString == nil) {
        labelPointidName.stringValue = blankString;
    }
    else {
        labelPointidName.stringValue = pointNameString;
    }
    labelWaitsec.stringValue = blankString;
    
    [self frontMostWindow];
}

// --------------------------
// 名称 モード切り替え
// 用途 モードが切り替えられた場合、表示内容を変更する
// --------------------------
- (void)inputModeInitialize {
    
    KancolleData *kdataObj = [KancolleData shareManager];
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // ラベル初期化
    Mode *modeObj = [kdataObj.marrMode objectAtIndex:cpointObj.currentInputModeType];
    searchKeybind.stringValue = blankString;
    labelInputMode.stringValue = modeObj.modeName;
    labelPointidName.stringValue = blankString;
    labelWaitsec.stringValue = blankString;
    labelKeyCheck.stringValue = blankString;
    
    NSInteger idx = 1;
    marrKeybindTable = [NSMutableArray array];
    
    for (Keybind *keybindObj in kdataObj.marrKeybind) {
        if ([keybindObj.modeid isEqualToString:modeObj.modeid]) {
            for (KeybindChild *keybindChildObj in keybindObj.arrKeybindChild) {
                for (NSString *pointid in keybindChildObj.pointidArray) {
                    
                    for (Pointid *pointidObj in kdataObj.marrPointid) {
                        if ([pointid isEqualToString:pointidObj.pointid]) {
                            KeybindTable *keybindTableObj = [[KeybindTable alloc] initWithNo:idx Keybind:keybindChildObj.keybind KeybindName:pointidObj.pointidName];
                            [marrKeybindTable addObject:keybindTableObj];
                            idx++;
                            break;
                        }
                    }
                }
            }
            break;
        }
    }
    // マクロの追加
    for (Macro *macroObj in kdataObj.marrMacro) {
        // 表示ステータスがYESの場合は表示させる
        if (macroObj.macroDispState) {
            KeybindTable *keybindTableObj = [[KeybindTable alloc] initWithNo:idx Keybind:macroObj.macroKeybind KeybindName:macroObj.macroName];
            [marrKeybindTable addObject:keybindTableObj];
            idx++;
        }
    }
    // モードの追加
    for (modeObj in kdataObj.marrMode) {
        KeybindTable *keybindTableObj = [[KeybindTable alloc] initWithNo:idx Keybind:modeObj.mode KeybindName:modeObj.modeName];
        [marrKeybindTable addObject:keybindTableObj];
        idx++;
    }
    
    // arrayContollerとBnind
    [arrayController setContent:marrKeybindTable];
    [tableKeybind reloadData];
    
    // 直前モードの初期化
    modeObj = [kdataObj.marrMode objectAtIndex:cpointObj.currentInputModeType];
    preModeid = modeObj.modeid;
}

// --------------------------
// 名称  入力値からモード切り替える
// 用途  編成/補給/改装/工廠/入渠/母港が選択された場合、モードを変更する
// --------------------------
- (void)modeChangeFromKeybind {
    
    KancolleData *kdataObj = [KancolleData shareManager];
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // 直前の処理でkeybindからpointidを取得しているので、次にpointidからmodeを取得する
    for (PointidToMode *pointidToModeObj in kdataObj.marrPointidToMode) {
        
        if ([pointidToModeObj.pointid isEqualToString:cpointObj.pointId]) {
            
            // backmode が true の場合、直前のモードに変更
            [cpointObj changeCurrentInputModeid:pointidToModeObj.modeid];
            
            [self inputModeInitialize];
            
            // 現在のモードを取得
            Mode *modeObj = [kdataObj.marrMode objectAtIndex:cpointObj.currentInputModeType];
            preModeid = modeObj.modeid;
            
            break;
        }
    }
}

// --------------------------
// 名称 マクロ処理
// 用途 引数で受け取ったマクロを実行する
// --------------------------
- (void)exeMacroid:(NSString *)aMacroid {
    
    // ウインドウをアクティブ
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    KancolleData *kdataObj = [KancolleData shareManager];
    ClickPoint *clickPointObj = [ClickPoint shareManager];
    
    for (Macro *macroObj in kdataObj.marrMacro) {
        if ([aMacroid isEqualToString:macroObj.macroid]) {
            
            // 残り時間計算
            float meanTime = 0.0;

            // 連続クリックの場合はPlistではなくLongClick処理を実行して処理を抜ける
            if ([aMacroid isEqualToString:@"NormalRenzk"]) {
                [self LongClick];
                return;
            }
            
            for (MacroChild *macroChildObj in macroObj.arrMacroChild) {
                if (macroChildObj.repeat) {
                    meanTime = meanTime + macroChildObj.waitsec * macroChildObj.repeat;
                }
                else {
                    meanTime = meanTime + macroChildObj.waitsec;
                }
            }
            
            // 残り時間表示
            labelWaitsec.stringValue = [NSString stringWithFormat:@"%.1f s", meanTime];;
            
            
            // 全マクロを実行
            for (MacroChild *macroChildObj in macroObj.arrMacroChild) {
                for (Pointid *pointidObj in kdataObj.marrPointid) {
                    if ([macroChildObj.pointid isEqualToString:pointidObj.pointid]) {
                        
                        labelPointidName.stringValue = pointidObj.pointidName;
                        
                        // 座標をセット
                        if ([clickPointObj setClickDownPointWithPointid:macroChildObj.pointid]) {
                            
                            int i = 0;
                            do {
                                labelWaitsec.stringValue = [NSString stringWithFormat:@"%.1f s", meanTime];
                                
                                [clickPointObj clickPointWithIsClick:macroChildObj.isClick];
                                
                                [NSThread sleepForTimeInterval:macroChildObj.waitsec];
                                meanTime = meanTime - macroChildObj.waitsec;
                                
                                i++;
                            } while (i < macroChildObj.repeat);
                        }
                        break;
                    }
                }
            }
            
            // モード切り替え
            [clickPointObj changeCurrentInputModeid:macroObj.modeid];
            break;
        }
    }
    
    [self inputModeInitialize];
    [self frontMostWindowSearchText:blankString LabelPointName:clickPointObj.clickDownPointName];
    [self moveMouseCursor];
}

// --------------------------
// 名称 カーソル移動処理
// 用途 マクロ実行後、当ウインドウにあるClickボタンの上にマウスカーソルを移動する
// --------------------------
- (void)moveMouseCursor {
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:buttonClick.frame];
}

// --------------------------
// 名称 キーバインド検索
// 用途 引数のPointidよりキーバインドを取得する
// --------------------------
- (NSString *)searchKeybindWithPointId:(NSString *)pid {
    
    NSString *rkb = blankString;
    
    KancolleData *kdataObj = [KancolleData shareManager];

    for (Keybind *keybindObj in kdataObj.marrKeybind) {
        for (KeybindChild *keybindChildObj in keybindObj.arrKeybindChild) {
            for (NSString *pointid in keybindChildObj.pointidArray) {
            
                if ([pid isEqualToString:pointid]) {
                    rkb = keybindChildObj.keybind;
                    return rkb;
                }
            }
        }
    }
    return rkb;
}

// --------------------------
// 名称 マクロキーバインド検索
// 用途 引数のMacroidよりマクロのキーバインドを取得する
// --------------------------
- (NSString *)searchMacroKeybindWithMacroId:(NSString *)mid {
    
    NSString *rmkb = blankString;
    
    KancolleData *kdataObj = [KancolleData shareManager];
    
    for (Macro *macroObj in kdataObj.marrMacro) {
        if ([mid isEqualToString:macroObj.macroid]) {
            rmkb = macroObj.macroKeybind;
            return rmkb;
        }
    }
    
    return rmkb;
}

// --------------------------
// 名称 ポップアップマクロ実行
// 用途 ポップアップで選択されたマクロを実行する
// --------------------------
- (void)popupMacroExe:(NSString *)popupItem {
    
    KancolleData *kdata = [KancolleData shareManager];
    
    for (Macro *macroObj in kdata.marrMacro) {
        if ([popupItem isEqualToString:macroObj.macroName]) {
            [self exeMacroid:macroObj.macroid];
            break;
        }
    }
}

#pragma mark Control Action
// --------------------------
// 名称 テキスト変更通知
// 用途 テキストの値が変更されたらキーバインドと一致するか調べる
// --------------------------
- (void)controlTextDidChange:(NSNotification *)obj {
    
    NSString *inputKeybind = searchKeybind.stringValue;
    
    // 値がなければ何もしない
    if (inputKeybind == nil || [inputKeybind length] == 0) {
        return;
    }
    
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];

    // ウインドウが起動していない場合
    if (![webObj isKancolleWindow]) {
        // "open"と入力された場合のみウィジェットを起動する。それ以外はエラーとして弾く
        NSRange range = [openString rangeOfString:inputKeybind];
        if (range.location != NSNotFound) {
            if ([inputKeybind isEqualToString:openString]) {
                [self openWidget];
                return;
            }
            else
                return;
        }
        else {
            [self frontMostWindowSearchText:blankString LabelPointName:@"ウインドウが存在しません"];
            return;
        }
    }
    
    // 空白でない場合、keybindTable 内の文字列と一致するか確認する
    if (![inputKeybind isEqualToString:spaceString]) {
        // 空白の削除
        NSString *trimString = [inputKeybind stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // keybindTableView に該当するキーがなければテキストフィールド内の文字列を削除
        BOOL isKeybind = NO;
        for (KeybindTable *keybindTableObj in marrKeybindTable) {
            if ([keybindTableObj.keybind hasPrefix:trimString]) {
                isKeybind = YES;
                labelKeyCheck.stringValue = blankString;
                break;
            }
        }
        
        if (!isKeybind) {
            
            // ウインドウが起動している場合、quitと入力されたらウィジェットを閉じる
            NSRange range = [quitString rangeOfString:inputKeybind];
            if (range.location != NSNotFound) {
                if ([inputKeybind isEqualToString:quitString]) {
                    [self quitWidget];
                    labelKeyCheck.stringValue = blankString;
                    searchKeybind.stringValue = blankString;
                    [self changeSearchPredicate:blankString];

                    return;
                }
                else
                    return;
            }
            
            labelKeyCheck.stringValue = @"キーが存在しません";
            searchKeybind.stringValue = blankString;
            [self changeSearchPredicate:blankString];
            return;
        }
    }
    
    KancolleData *kdataObj = [KancolleData shareManager];
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // マクロ判定
    if ([inputKeybind hasPrefix:@"@"]) {
        // @ だけならなにもしない
        if ([inputKeybind length] == 1)
            return;
        
        // マクロだったら座標名にマクロ名称を表示
        for (Macro *macroObj in kdataObj.marrMacro) {
            if ([inputKeybind isEqualToString:macroObj.macroKeybind])
                labelPointidName.stringValue = macroObj.macroName;
            else
                labelPointidName.stringValue = blankString;
        }
    }
    
    // モード設定判定
    if ([inputKeybind hasPrefix:@":"]) {
        // : だけならなにもしない
        if ([inputKeybind length] == 1)
            return;
        
        // モードだったら座標名にモード名称を表示
        for (Mode *modeObj in kdataObj.marrMode) {
            if ([inputKeybind isEqualToString:modeObj.mode]) {
                labelPointidName.stringValue = modeObj.modeName;
            }
            else {
                labelPointidName.stringValue = blankString;
            }
        }
    }
    
    // スペースキー"のみ"が押された場合、設定されている座標をクリック
    if ([inputKeybind isEqualToString:spaceString]) {
        // ウインドウをアクティブ
        if (![webObj activeKancolleWindow]) {
            [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
            return;
        }
        // マウスクリック
        [cpointObj clickPointWithIsClick:YES];
        // モード変更
        [self modeChangeFromKeybind];
        // 座標名称の変更
        [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
        // keybindTableの初期化
        [self changeSearchPredicate:blankString];
        return;
    }
    
    // マウスカーソルの移動
    if ([cpointObj setClickDownPointWithKeybind:inputKeybind]) {
        // マウスを移動
        [cpointObj clickPointWithIsClick:NO];
        // ラベルの更新
        labelPointidName.stringValue = cpointObj.clickDownPointName;

        // 1キーで複数の座標を持つキーが押された場合、検索フィールドをクリアする
        // クリアしない場合入力するたびに文字を消さないといけなくなるため
        for (NSString *ch in cpointObj.marrMultiPointKeybind) {
            if ([ch isEqualToString:inputKeybind]) {
                [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
                [self changeSearchPredicate:ch];
                break;
            }
        }
    }
    else {
        labelPointidName.stringValue = blankString;
    }
    
    // カーソルクリック(入力文字の後ろにスペースキーが押された場合)
    NSRange spaceRange = [inputKeybind rangeOfString:spaceString];
    
    if (spaceRange.location != NSNotFound) {
        // 最初の区切り文字を抽出
        NSArray *arrnoSpaceInputKeybind = [inputKeybind componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *noSpaceInputKeybind = arrnoSpaceInputKeybind[0];
        
        // モード判定
        for (Mode *modeObj in kdataObj.marrMode) {
            if ([noSpaceInputKeybind isEqualToString:modeObj.mode]) {
                // 一致したモードが存在すればモード変更して終了
                [cpointObj changeCurrentInputModeid:modeObj.modeid];
                [self inputModeInitialize];
                [self frontMostWindowSearchText:blankString LabelPointName:blankString];
                [self changeSearchPredicate:blankString];
                return;
            }
        }
        
        // マクロ判定
        for (Macro *macroObj in kdataObj.marrMacro) {
            if ([noSpaceInputKeybind isEqualToString:macroObj.macroKeybind]) {
                [self exeMacroid:macroObj.macroid];
                return;
            }
        }
        
        // 有効な座標ならばクリック
        if ([cpointObj setClickDownPointWithKeybind:noSpaceInputKeybind]) {
            // ウインドウをアクティブ
            if (![webObj activeKancolleWindow]) {
                [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
                return;
            }
            [cpointObj clickPointWithIsClick:YES];
            [self modeChangeFromKeybind];
            [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
            [self changeSearchPredicate:blankString];
            return;
        }
        
        // 検索文字列をクリア
        searchKeybind.stringValue = blankString;
        [self changeSearchPredicate:searchKeybind.stringValue];
    }
}

// --------------------------
// 名称  テキストフィールド内のイベントをハンドルする処理
// 用途  テキストフィールドでESCイベントを捕まえる処理
// --------------------------
- (BOOL)control:(NSControl *)control textView:(NSTextView *)fieldEditor doCommandBySelector:(SEL)commandSelector
{
    // NSLog(@"Selector method is (%@)", NSStringFromSelector( commandSelector ) );
    
    BOOL retval = NO;
    
    // ESCが押された場合
    if (commandSelector == @selector(cancelOperation:)) {
        
        retval = YES;
        // LongClickを実行
        [self LongClick];
    }
    // BackSpaceが押された場合
    else if (commandSelector == @selector(deleteBackward:)) {
        
        retval = YES;
        
        // テキストを削除
        [self frontMostWindowSearchText:blankString LabelPointName:blankString];
        [self changeSearchPredicate:blankString];
    }
    
    return retval;
}

// --------------------------
// 名称  コマンド実行処理
// 用途  検索フィールドでEnterまたはTabが押された場合にコマンドを実行する
// --------------------------
- (void)controlTextDidEndEditing:(NSNotification *)obj {
    
    // Enter / Tab のどちらが押されたのかチェック
    NSDictionary *dict  = [obj userInfo];
    NSNumber  *reason = [dict objectForKey: @"NSTextMovement"];
    int code = [reason intValue];
    
    // Tabキーが押された場合は何もしない(TableViewへフォーカスを移動させるため)
    if (code == NSTabTextMovement) {
        return;
    }
    
    NSString *keybind = searchKeybind.stringValue;
    
    // 何も入力されてなければ何もしない
    if ( keybind == nil || [keybind length] == 0) {
        [self frontMostWindowSearchText:blankString LabelPointName:blankString];
        return;
    }
    
    KancolleData *kdata = [KancolleData shareManager];
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // モード切り替え
    for (Mode *modeObj in kdata.marrMode) {
        if ([keybind isEqualToString:modeObj.mode]) {
            [cpointObj changeCurrentInputModeid:modeObj.modeid];
            [self inputModeInitialize];
            [self frontMostWindowSearchText:blankString LabelPointName:blankString];
            return;
        }
    }
    
    // マクロの記号から始まっている場合、マクロを実行して処理を抜ける
    if ([keybind hasPrefix:@"@"]) {
        for (Macro *macroObj in kdata.marrMacro) {
            if ([keybind isEqualToString:macroObj.macroKeybind]) {
                [self exeMacroid:macroObj.macroid];
                return;
            }
        }
    }
    
    // ウインドウをアクティブ
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    // 座標クリック
    if ([cpointObj setClickDownPointWithKeybind:keybind]) {
        [cpointObj clickPointWithIsClick:YES];
        [self modeChangeFromKeybind];
    }
    
    [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
}

#pragma mark IBAction Search Field
// --------------------------
// 名称 検索フィールド
// 用途 検索実行
// --------------------------
- (IBAction)changePredicate:(id)sender {
    // 検索文字列の取得
    NSString *searchString = [sender stringValue];
    [self changeSearchPredicate:searchString];
}

- (void)changeSearchPredicate:(NSString *)inputKeybind {
    // 検索文字列の取得
    NSString *searchString = inputKeybind;
    NSMutableArray *subpredicates = [NSMutableArray array];
    // 空欄でなければ検索開始
    if (![searchString isEqualToString:blankString]) {
        // 検索文字列をスペースで区切る
        NSArray *terms = [searchString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // 区切られた文字を含む文字列を検索
        for(NSString *term in terms) {
            if([term length] == 0) { continue; }
            // キーバインドは先頭の文字が一致した場合に表示、キーバインド名称は文字列を含むのもを表示
            NSPredicate *p = [NSPredicate predicateWithFormat:@"(keybind BEGINSWITH[c] %@) or (keybindName contains[cd] %@)", term, term];
            [subpredicates addObject:p];
        }
    }
    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    [arrayController setFilterPredicate:filter];
}

#pragma mark IBAction Stepper
// --------------------------
// 名称 Stepper
// 用途 Click Time のStepper
// --------------------------
- (IBAction)stepperClickTime:(id)sender {
    longClickSec = stepperClickTime.floatValue;
    labelClickTime.stringValue = [NSString stringWithFormat:@"%.0f", longClickSec];
}

#pragma mark IBAction Click Button
// --------------------------
// 名称 STARTボタン
// 用途 ウインドウが立ち上がった後のSTARTボタンを押す
// --------------------------
- (IBAction)buttonStart:(id)sender {
    [self ClickWithPointid:@"PWdgetGameStart"];
}

// --------------------------
// 名称 Widget 起動ボタン
// 用途 Widgetを起動する
// --------------------------
- (IBAction)buttonOpenWidget:(id)sender {
    [self openWidget];
}

- (void)openWidget {
    
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];
    
    if (![webObj isKancolleWindow]) {
        
        if([webObj openKancolleWidgetWindow]) {
            
            KancolleData *kdataObj = [KancolleData shareManager];
            Mode *modeObj = [kdataObj.marrMode objectAtIndex:ModeNormal];
            
            ClickPoint *cpointObj = [ClickPoint shareManager];
            [cpointObj changeCurrentInputModeid:modeObj.modeid];
            [self inputModeInitialize];
            [self changeSearchPredicate:blankString];
            [self frontMostWindowSearchText:blankString LabelPointName:blankString];
        }
        else {
            [self frontMostWindowSearchText:blankString LabelPointName:@"ウインドウ起動失敗"];
        }
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"艦これウインドウは既に起動しています。"];
        [alert runModal];
    }
    
    // ゲームスタートのキーバインドをセット
    searchKeybind.stringValue = [self searchKeybindWithPointId:@"PWdgetGameStart"];
}

// --------------------------
// 名称 Widget 終了ボタン
// 用途 Widgetウインドウを閉じる
// --------------------------
- (IBAction)buttonQuitWidget:(id)sender {
    [self quitWidget];
}

- (void)quitWidget {
    
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];
    
    if ([webObj isKancolleWindow]) {
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert addButtonWithTitle:@"Cancel"];
        [alert setMessageText:@"艦これウィジェットを閉じますか？"];
        [alert setInformativeText:@"終了確認"];
        [alert setAlertStyle:NSWarningAlertStyle];
        
        if ([alert runModal] == NSAlertFirstButtonReturn) {
            
            // ノーマルモードにして終了する
            KancolleData *kdataObj = [KancolleData shareManager];
            Mode *modeObj = [kdataObj.marrMode objectAtIndex:ModeNormal];
            
            ClickPoint *cpointObj = [ClickPoint shareManager];
            [cpointObj changeCurrentInputModeid:modeObj.modeid];
            
            // ラベルの初期化
            [self inputModeInitialize];
            [self changeSearchPredicate:blankString];
            [self frontMostWindowSearchText:blankString LabelPointName:blankString];
            
            // OK clicked
            if(![webObj closeKancolleWidgetWindow]) {
                
                [self frontMostWindowSearchText:blankString LabelPointName:@"ウインドウClose失敗"];
            }
        }
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"艦これウインドウが起動していません。"];
        [alert runModal];
    }
}

// --------------------------
// 名称 Click Button
// 用途 カーソル位置のクリック
// --------------------------
- (IBAction)buttonClick:(id)sender {
    
    [self ClickWithPointid:blankString];
}

- (void)ClickWithPointid:(NSString *)pid {

    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    
    // ウインドウをアクティブ
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    // pointidがセットされている場合
    if (![pid isEqualToString:blankString]) {
        [cpointObj setClickDownPointWithPointid:pid];
    }
    
    // マウスクリック
    [cpointObj clickPointWithIsClick:YES];
    
    // モード変更
    [self modeChangeFromKeybind];
    // 座標名称の変更
    [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
    // keybindTableの初期化
    [self changeSearchPredicate:blankString];
    
    // カーソルをクリックボタン上に移動
    [self moveMouseCursor];
}

// --------------------------
// 名称 Click Button
// 用途 カーソル位置のロングクリック
// --------------------------
- (IBAction)buttonLongClick:(id)sender {
    
    [self LongClick];
}

- (void)LongClick {
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    
    // ウインドウをアクティブ
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    // 残り時間計算
    float meanTime = longClickSec;
    float interval = 1.0;
    
    labelPointidName.stringValue = cpointObj.clickDownPointName;
    
    do {
        labelWaitsec.stringValue = [NSString stringWithFormat:@"%.1f s", meanTime];
        
        [cpointObj clickPointWithIsClick:YES];
        
        [NSThread sleepForTimeInterval:interval];
        meanTime = meanTime - interval;
        
    } while (0 < meanTime);
    
    // 座標名称の変更
    [self frontMostWindowSearchText:blankString LabelPointName:cpointObj.clickDownPointName];
    // keybindTableの初期化
    [self changeSearchPredicate:blankString];
    [self moveMouseCursor];
}

#pragma mark IBAction Popup
// --------------------------
// 名称 母港ポップアップ
// 用途 母港ポップアップを選択したとき、カーソルをポップアップの位置に戻す
// --------------------------
- (IBAction)popupBokouMacro:(id)sender {
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // 実行ボタンにマウスカーソルを移動
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:popupMacroBokou.frame];
}

// --------------------------
// 名称 遠征ポップアップ
// 用途 遠征ポップアップを選択したとき、カーソルをポップアップの位置に戻す
// --------------------------
- (IBAction)popupEnseiMacro:(id)sender {
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // 実行ボタンにマウスカーソルを移動
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:popupMacroEnsei.frame];
}

// --------------------------
// 名称 出撃ポップアップ
// 用途 出撃ポップアップを選択したとき、カーソルをポップアップの位置に戻す
// --------------------------
- (IBAction)popupShtgkMacro:(id)sender {
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    
    // 実行ボタンにマウスカーソルを移動
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:popupShtgkArea.frame];
}


#pragma mark IBAction Macro Button
// --------------------------
// 名称 母港マクロ実行ボタン
// 用途 母港 popupで指定されたマクロを実行する
// --------------------------
- (IBAction)buttonDownBokouMacroExe:(id)sender {
    
    NSString *popupItem = [popupMacroBokou titleOfSelectedItem];
    
    // デフォルトの値の場合は何もしない
    if ([popupItem isEqualToString:popupDefaultTitle]) {
        return;
    }
    
    [self popupMacroExe:popupItem];
}

// --------------------------
// 名称 遠征母港マクロボタン
// 用途 母港を表示してカーソルをボタン上に戻す
// --------------------------
- (IBAction)buttonDownEnseiBokou:(id)sender {
    
    // ウインドウをアクティブ
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    // 母港アイコンクリック
    if([cpointObj setClickDownPointWithPointid:bokouPointid]) {
        [cpointObj clickPointWithIsClick:YES];
    }
    
    // 母港ボタンにマウスカーソルを移動
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:buttonEnseiBokou.frame];
}

// --------------------------
// 名称 遠征マクロ実行ボタン
// 用途 遠征 popupで指定されたマクロを実行する
// --------------------------
- (IBAction)buttonDownEnseiMacroExe:(id)sender {
    
    NSString *popupItem = [popupMacroEnsei titleOfSelectedItem];
    
    // デフォルトの値の場合は何もしない
    if ([popupItem isEqualToString:popupDefaultTitle]) {
        return;
    }
    
    [self popupMacroExe:popupItem];
}

// --------------------------
// 名称 出撃母港表示ボタン
// 用途 母港を表示してカーソルをボタン上に戻す
// --------------------------
- (IBAction)buttonDownShtgkBokou:(id)sender {
    
    // ウインドウをアクティブ
    WebAccess *webObj = [WebAccess shareManager];
    if (![webObj isKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgWindow];
        return;
    }
    if (![webObj activeKancolleWindow]) {
        [self frontMostWindowSearchText:blankString LabelPointName:errMsgActive];
        return;
    }
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    // 母港アイコンクリック
    if([cpointObj setClickDownPointWithPointid:bokouPointid]) {
        [cpointObj clickPointWithIsClick:YES];
    }
    
    // 母港ボタンにマウスカーソルを移動
    [cpointObj moveCursorToItemWithPosition:self.window.frame itemPosition:buttonShtgkBokou.frame];
}

// --------------------------
// 名称 出撃ボタン
// 用途 エリア別にマウスカーソルを移動する(マクロ実行)
// --------------------------
- (IBAction)buttonDownMacroShtgk:(id)sender {
    
    // デフォルトの値の場合は何もしない
    NSString *popupItem = [popupShtgkArea titleOfSelectedItem];
    if ([popupItem isEqualToString:popupDefaultShtgkArea]) {
        return;
    }
    
    [self popupMacroExe:popupItem];
}

// --------------------------
// 名称 単従陣ボタン
// 用途 単従陣を選択する
// --------------------------
- (IBAction)buttonDownMacroTanju:(id)sender {
    [self exeMacroid:@"ShtgkTanju"];
}

// --------------------------
// 名称 複縦陣ボタン
// 用途 複縦陣を選択する
// --------------------------
- (IBAction)buttonDownMacroHukju:(id)sender {
    [self exeMacroid:@"ShtgkHukju"];
}

// --------------------------
// 名称 輪形陣ボタン
// 用途 輪形陣を選択する
// --------------------------
- (IBAction)buttonDownMacroRnkei:(id)sender {
    [self exeMacroid:@"ShtgkRnkei"];
}

// --------------------------
// 名称 梯形陣ボタン
// 用途 梯形陣を選択する
// --------------------------
- (IBAction)buttonDownMacroTekei:(id)sender {
    [self exeMacroid:@"ShtgkTekei"];
}

// --------------------------
// 名称 単横陣ボタン
// 用途 単横陣を選択する
// --------------------------
- (IBAction)buttonDownMacroTanou:(id)sender {
    [self exeMacroid:@"ShtgkTanou"];
}

// --------------------------
// 名称 追撃せずボタン
// 用途 追撃せずボタンを暫くの間クリックする
// --------------------------
- (IBAction)buttonDownMacroTusez:(id)sender {
    [self exeMacroid:@"ShtgkTusez"];
}

// --------------------------
// 名称 夜戦ボタン
// 用途 夜戦ボタンを暫くの間クリックする
// --------------------------
- (IBAction)buttonDownMacroYasen:(id)sender {
    [self exeMacroid:@"ShtgkYasen"];
}

// --------------------------
// 名称 進撃ボタン
// 用途 進撃ボタンを暫くの間クリックする
// --------------------------
- (IBAction)buttonDownMacroSngki:(id)sender {
    [self exeMacroid:@"ShtgkSngki"];
}
// --------------------------
// 名称 撤退ボタン
// 用途 撤退ボタンを暫くの間クリックする
// --------------------------
- (IBAction)buttonDownMacroTetai:(id)sender {
    [self exeMacroid:@"ShtgkTetai"];
}

#pragma mark Menu Action
// --------------------------
// 名称 艦これウィジェット起動
// 用途 艦これウィジェットを起動する
// --------------------------
- (IBAction)menuOpenWidget:(id)sender {
    [self openWidget];
}

// --------------------------
// 名称 艦これウィジェット最小化
// 用途 ショートカットから艦これウィジェットを最小化する
// --------------------------
- (IBAction)menuMinimizeWidget:(id)sender {
    // ウインドウの存在確認
    WebAccess *webObj = [WebAccess shareManager];
    
    if ([webObj isKancolleWindow]) {
        
        if(![webObj minimizeKancolleWidgetWindow]) {
            
            [self frontMostWindowSearchText:blankString LabelPointName:@"ウインドウ最小化失敗"];
        }
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"艦これウインドウが起動していません。"];
        [alert runModal];
    }
}

// --------------------------
// 名称 艦これウィジェット停止
// 用途 艦これウィジェットを閉じる
// --------------------------
- (IBAction)menuQuitWidget:(id)sender {
    [self quitWidget];
}

// --------------------------
// 名称 Long Click
// 用途 ショートカットからLong Click機能を実行する
// --------------------------
- (IBAction)menuLongClick:(id)sender {
    [self LongClick];
}

// --------------------------
// 名称 クリック時間UP
// 用途 LongClickボタンが押されたときの時間を長くする
// --------------------------
- (IBAction)menuLongClickUp:(id)sender {
    
    longClickSec = stepperClickTime.floatValue;
    
    if (longClickSec < stepperClickTime.maxValue) {
        longClickSec += 1.0;
        stepperClickTime.floatValue = longClickSec;
        labelClickTime.stringValue = [NSString stringWithFormat:@"%.0f", longClickSec];
    }
}

// --------------------------
// 名称 クリック時間DOWN
// 用途 LongClickボタンが押されたときの時間を短くする
// --------------------------
- (IBAction)menuLongClickDown:(id)sender {
    
    longClickSec = stepperClickTime.floatValue;
    
    if (stepperClickTime.minValue < longClickSec) {
        longClickSec -= 1.0;
        stepperClickTime.floatValue = longClickSec;
        labelClickTime.stringValue = [NSString stringWithFormat:@"%.0f", longClickSec];
    }
}

// --------------------------
// 名称 Plist リロードメニュー
// 用途 Plist ファイルを再度読み込む
// --------------------------
- (IBAction)menuReload:(id)sender {

    WebAccess *webObj = [WebAccess shareManager];
    [webObj readPlist];
    
    KancolleData *kdataObj = [KancolleData shareManager];
    [kdataObj readPlist];
    
    ClickPoint *cpointObj = [ClickPoint shareManager];
    [cpointObj readPlist];

    [self readPlist];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"設定ファイルの再読み込み完了"];
    [alert runModal];
}

// --------------------------
// 名称 Plist リロードメニュー
// 用途 Plist ファイルを再度読み込む
// --------------------------
- (IBAction)menuPlistFolderOpen:(id)sender {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Widget" ofType:@"plist"];
    
    NSRange spaceRange = [path rangeOfString:@"Widget"];
    if (spaceRange.location != NSNotFound) {
        
        NSString *newPath = [path substringToIndex:spaceRange.location];

        [[NSWorkspace sharedWorkspace] openFile:newPath withApplication:@"Finder"];
    }
    else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"フォルダが開けませんでした"];
        [alert runModal];

    }
}

@end
