//
//  GameTile.m
//  Skeleton Key
//
//  Created by micah on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameTile.h"
#import "GameData.h"
#import "SkeletonKeyAppDelegate.h"

@implementation GameTile

@synthesize x;
@synthesize y;
@synthesize tileType;

+ (id) tileWithType:(int)tileType andX:(int)x andY:(int)y {
	NSString* textureName;
	if(tileType >= GameTileSolid4Sides && tileType <= GameTileSolid0Sides) {
		GameData* gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		switch(gameData.stage) {
			case GameStageForest: textureName = @"game_tiles_forest.png"; break;
			case GameStageCaves: textureName = @"game_tiles_caves.png"; break;
			case GameStageBeach: textureName = @"game_tiles_beach.png"; break;
			case GameStageShip: textureName = @"game_tiles_ship.png"; break;
		}
	} else {
		textureName = @"game_tiles_objects.png";
	}
	GameTile* tile = [GameTile spriteWithFile:textureName];
	[tile changeType:tileType];
	[tile changePositionX:x andY:y];
    tile.scale = 1.02;
	return tile;
}

- (void) changeType:(int)_tileType {
	tileType = _tileType;
	CGRect rect;
	switch(tileType) {
		case GameTileSolid4Sides:		rect = CGRectMake(  0,  0, 51, 51);	break;
		case GameTileSolid3SidesTRB:	rect = CGRectMake( 51,  0, 51, 51);	break;
		case GameTileSolid3SidesTRL:	rect = CGRectMake(102,  0, 51, 51);	break;
		case GameTileSolid3SidesTLB:	rect = CGRectMake(153,  0, 51, 51);	break;
		case GameTileSolid3SidesRBL:	rect = CGRectMake(204,  0, 51, 51);	break;
		case GameTileSolid2SidesTR:		rect = CGRectMake(255,  0, 51, 51);	break;
		case GameTileSolid2SidesTB:		rect = CGRectMake(306,  0, 51, 51);	break;
		case GameTileSolid2SidesTL:		rect = CGRectMake(357,  0, 51, 51);	break;
		case GameTileSolid2SidesRB:		rect = CGRectMake(  0, 52, 51, 51);	break;
		case GameTileSolid2SidesRL:		rect = CGRectMake( 51, 52, 51, 51);	break;
		case GameTileSolid2SidesBL:		rect = CGRectMake(102, 52, 51, 51);	break;
		case GameTileSolid1SidesT:		rect = CGRectMake(153, 52, 51, 51);	break;
		case GameTileSolid1SidesR:		rect = CGRectMake(204, 52, 51, 51);	break;
		case GameTileSolid1SidesB:		rect = CGRectMake(255, 52, 51, 51);	break;
		case GameTileSolid1SidesL:		rect = CGRectMake(306, 52, 51, 51);	break;
		case GameTileSolid0Sides:		rect = CGRectMake(357, 52, 51, 51);	break;
		case GameTileKey:				rect = CGRectMake(  0,  0, 51, 51);	break;
		case GameTileChest:				rect = CGRectMake( 51,  0, 51, 51);	break;
		case GameTileChestOpen:			rect = CGRectMake(102,  0, 51, 51);	break;
		case GameTileSwitch:			rect = CGRectMake(153,  0, 51, 51);	break;
		case GameTileDoorLRClosed:		rect = CGRectMake(204,  0, 51, 51);	break;
		case GameTileDoorLROpen:		rect = CGRectMake(255,  0, 51, 51);	break;
		case GameTileDoorTBClosed:		rect = CGRectMake(306,  0, 51, 51);	break;
		case GameTileDoorTBOpen:		rect = CGRectMake(357,  0, 51, 51);	break;
	}
	[self setTextureRect:rect];
}

- (void) changePositionX:(int)_x andY:(int)_y {
	x = _x;
	y = _y;
	self.position = ccp(32+(51*x), 38.5+(51*(7-y)));
}

@end
