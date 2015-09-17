//
//  KeybindTable.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/18.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeybindTable : NSObject

@property (nonatomic) NSInteger no;
@property (nonatomic, copy) NSString *keybind;
@property (nonatomic, copy) NSString *keybindName;

- (id) initWithNo:(NSInteger)aNo Keybind:(NSString *)aKeybind KeybindName:(NSString *)aKeybindName;

@end
