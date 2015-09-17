//
//  WebAccess.h
//  KancolleTool
//
//  Created by Jonouchi Kouyo on 2015/07/14.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, KancolleWindowSize) {
    SmallSize = 0,
    MiddleSize,
    LargeSize,
    UnknownSize
};

@interface WebAccess : NSObject

@property (nonatomic) KancolleWindowSize windowSizeType;
@property (nonatomic) NSRect kancolleWindowRect;

+ (id)shareManager;
- (void)readPlist;
- (BOOL)isKancolleWindow;
- (BOOL)activeKancolleWindow;
- (BOOL)openKancolleWidgetWindow;
- (BOOL)closeKancolleWidgetWindow;
- (BOOL)minimizeKancolleWidgetWindow;

@end
