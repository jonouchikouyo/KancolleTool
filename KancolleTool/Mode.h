//
//  Mode.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mode : NSObject

@property (nonatomic, copy) NSString *mode;
@property (nonatomic, copy) NSString *modeName;
@property (nonatomic, copy) NSString *modeid;

- (id)initWithMode:(NSString *)aMode ModeName:(NSString *)aModeName ModeId:(NSString *)aModeId;

@end
