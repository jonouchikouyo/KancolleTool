//
//  KancolleData.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mode.h"
#import "Pointid.h"
#import "Keybind.h"
#import "Macro.h"
#import "PointidToMode.h"

@interface KancolleData : NSObject

@property (nonatomic, copy) NSMutableArray *marrMode;
@property (nonatomic, copy) NSMutableArray *marrPointid;
@property (nonatomic, copy) NSMutableArray *marrKeybind;
@property (nonatomic, copy) NSMutableArray *marrMacro;
@property (nonatomic, copy) NSMutableArray *marrPointidToMode;

// シングルトンクラス
+ (id) shareManager;

- (void)readPlist;

@end
