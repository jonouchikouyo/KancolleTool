//
//  Pointid.h
//  CKancolleTest05
//
//  Created by Jonouchi Kouyo on 2015/04/17.
//  Copyright (c) 2015年 Jonouchi Kouyo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pointid : NSObject

@property (nonatomic, copy) NSString *pointid;
@property (nonatomic ,copy) NSString *pointidName;
@property (nonatomic) CGFloat positionX;
@property (nonatomic) CGFloat positionY;

- (id)initWithPointid:(NSString *)aPointid PointidName:(NSString *)aPoiontidName PositionX:(CGFloat)aPositionX PositionY:(CGFloat)aPositionY;

@end