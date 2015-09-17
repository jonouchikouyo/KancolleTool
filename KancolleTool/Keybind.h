//
//  Keybind.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keybind : NSObject

@property (nonatomic, copy) NSString *modeid;
@property (nonatomic, copy) NSArray *arrKeybindChild;

- (id)initWithModeid:(NSString *)aModeid KeybindChild:(NSMutableArray *)aKeybindChild;

@end


@interface KeybindChild : NSObject

@property (nonatomic, copy) NSString *keybind;
@property (nonatomic, copy) NSArray *pointidArray;

- (id)initWithKeybind:(NSString *)aKeybind PointArray:(NSArray *)aPointarray;

@end


@interface KeybindChildIndex : NSObject

@property (nonatomic, copy) NSString *keybind;
@property (nonatomic) NSInteger keybindCount;
@property (nonatomic) NSInteger index;

- (id)initWithKeybind:(NSString *)aKeybind KeybindCount:(NSInteger) aKeybindCount;

@end
