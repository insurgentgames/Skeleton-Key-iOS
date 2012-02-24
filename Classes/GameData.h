//
//  GameData.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "Helpers.h"
#import "Levels.h"
#import "Level.h"
#import "Options.h"
#import "Levels.h"
#import "Sound.h"
#import "GameDataKey.h"

// game board dimensions
#define GAME_BOARD_WIDTH 6
#define GAME_BOARD_HEIGHT 8

// levels
#define TOTAL_LEVELS 120

// stage names
typedef enum {
	GameStageForest = 0,
	GameStageCaves = 1,
	GameStageBeach = 2,
	GameStageShip = 3,
    GameStageNone = 4
} GameStageNames;

// difficulties
typedef enum {
	GameDifficultyEasy = 0,
	GameDifficultyMedium = 1,
	GameDifficultyHard = 2
} GameDifficulties;

// tile types
typedef enum {
	GameTileSpace = 0,
	GameTileSolid4Sides = 1,
	GameTileSolid3SidesTRB = 2,
	GameTileSolid3SidesTRL = 3,
	GameTileSolid3SidesTLB = 4,
	GameTileSolid3SidesRBL = 5,
	GameTileSolid2SidesTR = 6,
	GameTileSolid2SidesTB = 7,
	GameTileSolid2SidesTL = 8,
	GameTileSolid2SidesRB = 9,
	GameTileSolid2SidesRL = 10,
	GameTileSolid2SidesBL = 11,
	GameTileSolid1SidesT = 12,
	GameTileSolid1SidesR = 13,
	GameTileSolid1SidesB = 14,
	GameTileSolid1SidesL = 15,
	GameTileSolid0Sides = 16,
	GameTileKey = 17,
	GameTileChest = 18,
	GameTileChestOpen = 19,
	GameTileSwitch = 20,
	GameTileDoorLRClosed = 21,
	GameTileDoorLROpen = 22,
	GameTileDoorTBClosed = 23,
	GameTileDoorTBOpen = 24
} GameTiles;

@interface GameData : NSObject {
	Options* options;
	Levels* levels;
	Sound* sound;
	
	// is the game active?
	BOOL activeGame;
	
	// shared data
	int stage;
	int difficulty;
	int level;
	char tileString[49];
	char tiles[6][8];
	NSMutableArray* keys;
	int movesLeft;
	BOOL doorOpened;
	BOOL returnToGame;
}

@property (readwrite) BOOL activeGame;
@property (readwrite) int stage;
@property (readwrite) int difficulty;
@property (readwrite) int level;
@property (nonatomic,retain) NSMutableArray* keys;
@property (readwrite) int movesLeft;
@property (readwrite) BOOL doorOpened;
@property (readwrite) BOOL returnToGame;

// getters, because obj-c is weird
- (int) getTileTypeX:(int)x andY:(int)y;
- (char*) getTileString;

// saving, loading
- (NSString*) savedGamePath;
- (void) loadLevel;
- (BOOL) loadGame;
- (void) saveGame;
- (BOOL) isSavedGame;
- (void) deleteSavedGame;

// gameplay mechanics
- (void) moveKeys:(int)dir;
- (BOOL) cannotMove;
- (BOOL) isKeyAtPositionX:(int)x andY:(int)y;
- (void) beatLevel;

// misc
- (BOOL) stageLocked:(int)stageToCheck;
- (int) stageForLevel:(int)levelToCheck;
- (NSString*) stageName;

// memory
- (void) freeKeys;

@end
