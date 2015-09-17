//
//  WebAccess.m
//  KancolleTool
//
//  Created by Jonouchi Kouyo on 2015/07/14.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import "WebAccess.h"
#import "Chrome.h"

@interface WebAccess() {
     NSArray *arrWidgetURL;
     NSArray *arrWindowTitle;
     CGFloat sizeSmallWidth;
     CGFloat sizeSmallHeight;
     CGFloat sizeMiddleWidth;
     CGFloat sizeMiddleHeight;
     CGFloat sizeLargeWidth;
     CGFloat sizeLargeHeight;
}

@end

@implementation WebAccess

@synthesize windowSizeType;
@synthesize kancolleWindowRect;

// ---------------------------
// 定数定義
// ---------------------------
NSString * const chromeIdentifier = @"com.google.Chrome";

// ---------------------------
// シングルトンクラス
// ---------------------------
+ (id)shareManager {
    
    static WebAccess *shareData = nil;
    
    @synchronized(self) {
        if (shareData == nil) {
            shareData = [[WebAccess alloc] init];
        }
    }
    return shareData;
}

// ---------------------------
// 初期化
// ---------------------------
- (id)init {
    self = [super init];
    if (self) {
        // デフォルトウインドウサイズ
        windowSizeType = MiddleSize;
        
        [self readPlist];
    }
    return self;
}

// ---------------------------
// Plist読み込み
// ---------------------------
- (void)readPlist {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Widget" ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    arrWidgetURL = [rootDic objectForKey:@"WidgetURL"];
    arrWindowTitle = [rootDic objectForKey:@"WindowTitle"];
    
    NSDictionary *element = [rootDic objectForKey:@"WindowSize"];
    NSDictionary *childElement = [element objectForKey:@"Small"];
    sizeSmallWidth = [[childElement objectForKey:@"width"] floatValue];
    sizeSmallHeight = [[childElement objectForKey:@"height"] floatValue];
    
    childElement = [element objectForKey:@"Middle"];
    sizeMiddleWidth = [[childElement objectForKey:@"width"] floatValue];
    sizeMiddleHeight = [[childElement objectForKey:@"height"] floatValue];
    
    childElement = [element objectForKey:@"Large"];
    sizeLargeWidth = [[childElement objectForKey:@"width"] floatValue];
    sizeLargeHeight = [[childElement objectForKey:@"height"] floatValue];
}

// ---------------------------
// ウィジェットの確認
// ---------------------------
- (BOOL)isKancolleWindow {
    
    BOOL isWindow = NO;
    
    ChromeApplication *chromeApp = [SBApplication applicationWithBundleIdentifier:chromeIdentifier];
    
    for (ChromeWindow *chromeWindow in chromeApp.windows) {
        
        for (NSString *widgetUrl in arrWidgetURL) {
            
            if ([chromeWindow.activeTab.URL hasPrefix:widgetUrl]) {
                
                // Get Window Position and Size
                kancolleWindowRect = chromeWindow.bounds;
                CGFloat py = kancolleWindowRect.origin.y + kancolleWindowRect.size.height;
                
                if (kancolleWindowRect.size.width == sizeSmallWidth) {
                    windowSizeType = SmallSize;
                    kancolleWindowRect.origin.y = py - sizeSmallHeight;
                }
                else if (kancolleWindowRect.size.width == sizeMiddleWidth) {
                    windowSizeType = MiddleSize;
                    kancolleWindowRect.origin.y = py - sizeMiddleHeight;
                }
                else if (kancolleWindowRect.size.width == sizeLargeWidth) {
                    windowSizeType = LargeSize;
                    kancolleWindowRect.origin.y = py - sizeLargeHeight;
                }
                else {
                    windowSizeType = UnknownSize;
                }
                
                isWindow = YES;
                break;
            }
        }
        
        if (isWindow)
            break;
    }

    return isWindow;
}

// ---------------------------
// ウィジェットのアクティブ化
// ---------------------------
- (BOOL)activeKancolleWindow {

BOOL isActive = NO;

    // get Chrome proccess
    NSArray *apps = [NSRunningApplication runningApplicationsWithBundleIdentifier:chromeIdentifier];
    
    if (apps) {
        
        NSRunningApplication *app = [apps objectAtIndex:0];
        AXUIElementRef appElement = AXUIElementCreateApplication(app.processIdentifier);
        
        id  windows = nil;
        
        // if you use ARC, you have to set (void *) insted of (CFTypeRef *)
        if (AXUIElementCopyAttributeValue(appElement, CFSTR("AXWindows"), (void *)&windows) == kAXErrorSuccess) {
            
            if ( CFGetTypeID((__bridge CFTypeRef)(windows)) == CFArrayGetTypeID()) {
                
                // 1 process has multiple thread(window)
                NSArray *window_attrs = (NSArray *)windows;
                
                NSEnumerator *enumerator = [window_attrs objectEnumerator];
                AXUIElementRef aref;
                
                // Core Foundation objects (CFRefs) are not controlled by ARC
                // when you convert between them, you have to tell ARC about the object's ownership so it can properly clean them up
                // The simplest case is a __bridge cast, for which ARC will not do any extra work
                while ((aref = (__bridge AXUIElementRef)[enumerator nextObject])) {
                    
                    id w_title = nil;
                    
                    if (AXUIElementCopyAttributeValue(aref, CFSTR("AXTitle"), (void *)&w_title) == kAXErrorSuccess) {
                        
                        NSString *titlename = [w_title description];
                        
                        // 艦これウィジットの画面を前に出す
                        for (NSString *windowTitle in arrWindowTitle) {
                            if ([titlename hasPrefix:windowTitle]) {
                                AXUIElementPerformAction(aref, kAXRaiseAction);
                                
                                // 現在のポイント
                                CGEventRef event = CGEventCreate(NULL);
                                CGPoint location = CGEventGetLocation(event);
                                CFRelease(event);
                                
                                CGPoint windowPos = CGPointMake(kancolleWindowRect.origin.x, kancolleWindowRect.origin.y);
                                
                                CGEventRef click_down = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown,windowPos,kCGMouseButtonLeft);
                                CGEventRef click_up = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseUp, windowPos, kCGMouseButtonLeft);
                                CGEventPost(kCGHIDEventTap, click_down);
                                CGEventPost(kCGHIDEventTap, click_up);
                                
                                // Release the events
                                CFRelease(click_up);
                                CFRelease(click_down);
                                
                                // 元の場所へ戻す
                                CGEventRef mouse_move = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, location, kCGMouseButtonLeft);
                                CGEventPost(kCGHIDEventTap, mouse_move);
                                CFRelease(mouse_move);
                                
                                isActive = YES;
                            }
                        }
                        if (isActive) break;
                    }
                    
                }
            }
        }
        CFRelease(appElement);
    }
    
    return isActive;
}

// ---------------------------
// 艦これウィジェットの起動(メニューバー付き)
// ---------------------------
- (BOOL)openKancolleWidgetWindow {
    
    // Chromeへのアクセスメソッド取得
    ChromeApplication *chromeApplication = [SBApplication applicationWithBundleIdentifier:chromeIdentifier];
    
    // ノーマルモードのウインドウ
    ChromeWindow *chromeWindows = [[[chromeApplication classForScriptingClass:@"window"] alloc] initWithProperties:nil];
    
    // 新規ウインドウの追加
    [chromeApplication.windows addObject:chromeWindows];
    
    // アクティブTABのURL
    for (NSString *kancolleURL in arrWidgetURL) {
        NSRange range = [kancolleURL rangeOfString:@"widget=true" options:NSBackwardsSearch];
        if (range.location != NSNotFound) {
            chromeWindows.activeTab.URL = kancolleURL;
        }
    }
    
    // ウインドウを起動
    [chromeApplication activate];
    
    // ウインドウサイズの取得
    NSRect chromebounds = chromeWindows.bounds;
    
    // メインウインドウの幅と高さ
    CGFloat mainWidth = [[NSScreen mainScreen] frame].origin.x + [[NSScreen mainScreen] frame].size.width;
    
    CGFloat mainHeight = [[NSScreen mainScreen] frame].origin.y + [[NSScreen mainScreen] frame].size.height;
    
    // 移動先の座標
    CGFloat posx = mainWidth - sizeMiddleWidth;
    CGFloat posy = mainHeight - [[NSScreen mainScreen] frame].size.height;
    
    // ウインドウ位置の変更
    chromebounds.origin.x = posx;
    chromebounds.origin.y = posy;
    
    [chromeWindows setBounds:chromebounds];
    
    // ウインドウの起動確認結果
    return [self isKancolleWindow];
}

// ---------------------------
// 艦これウィジェットを閉じる
// ---------------------------
- (BOOL)closeKancolleWidgetWindow {
    
    BOOL isWindow = NO;
    
    ChromeApplication *chromeApp = [SBApplication applicationWithBundleIdentifier:chromeIdentifier];
    
    for (ChromeWindow *chromeWindow in chromeApp.windows) {
        
        for (NSString *widgetUrl in arrWidgetURL) {
            
            if ([chromeWindow.activeTab.URL hasPrefix:widgetUrl]) {
                
                [chromeWindow.activeTab close];
                break;
            }
        }
    }
    
    isWindow = [self isKancolleWindow];
    
    return isWindow;
}

// ---------------------------
// 艦これウィジェットを最小化する
// ---------------------------
- (BOOL)minimizeKancolleWidgetWindow {
    
    BOOL isWindow = NO;
    
    ChromeApplication *chromeApp = [SBApplication applicationWithBundleIdentifier:chromeIdentifier];
    
    for (ChromeWindow *chromeWindow in chromeApp.windows) {
        
        for (NSString *widgetUrl in arrWidgetURL) {
            
            if ([chromeWindow.activeTab.URL hasPrefix:widgetUrl]) {
                
                chromeWindow.minimized = YES;
                break;
            }
        }
    }
    
    isWindow = [self isKancolleWindow];
    
    return isWindow;
}

@end
