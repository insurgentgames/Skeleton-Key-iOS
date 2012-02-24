//
//  GameTile.h
//  Skeleton Key
//
//  Created by micah on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface GameTile : CCSprite {
	int x;
	int y;
	int tileType;
}

@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) int tileType;

+ (id) tileWithType:(int)tileType andX:(int)x andY:(int)y;
- (void) changeType:(int)_tileType;
- (void) changePositionX:(int)_x andY:(int)_y;

@end
