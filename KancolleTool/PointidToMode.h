//
//  PointidToMode.h
//  KancolleTool
//
//  Created by Jonouchi Kouyo on 2015/07/15.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointidToMode : NSObject

@property (nonatomic, copy) NSString *pointid;
@property (nonatomic, copy) NSString *modeid;
@property (nonatomic) BOOL backmode;

- (id)initWithPointid:(NSString *)aPointid Modeid:(NSString *) aModeid BackMode:(BOOL) aBackMode;

@end
