//
//  GameData.m
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameData.h"
#import "SkeletonKeyAppDelegate.h"

@implementation GameData

@synthesize activeGame;
@synthesize stage;
@synthesize difficulty;
@synthesize level;
@synthesize keys;
@synthesize movesLeft;
@synthesize doorOpened;
@synthesize returnToGame;

- (id) init {
	if((self=[super init])) {
		NSLog(@"GameData init");
		
		activeGame = FALSE;
		options = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).options;
		levels = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).levels;
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		
		keys = [[NSMutableArray alloc] initWithCapacity:5];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"GameData dealloc");
	[self freeKeys];
	[super dealloc];
}

// getters, because obj-c is weird
- (int) getTileTypeX:(int)x andY:(int)y {
	return tiles[x][y];
}
- (char*) getTileString {
	return tileString;
}

// saving, loading
- (NSString*) savedGamePath {
	NSString* savedGamePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] 
							   stringByAppendingPathComponent:@"SavedGame.plist"];
	return savedGamePath;
}
- (void) loadLevel {
	Level* l = [levels.levels objectAtIndex:level-1];
	
	// tiles
	NSLog(@"level data: %@", l.data);
	strcpy(tileString, [l.data UTF8String]);
	
	// moves
	movesLeft = l.min_moves;
	
	// make sure the stage is correct
	stage = [self stageForLevel:level];
	
	// set difficulty
	difficulty = options.difficulty;
	
	// update moves left based on difficulty
	switch(difficulty) {
		case GameDifficultyEasy: movesLeft += 10; break;
		case GameDifficultyMedium: movesLeft += 6; break;
		case GameDifficultyHard: movesLeft += 2; break;
	}
	
	// set up tiles
	[self freeKeys];
	keys = [[NSMutableArray alloc] initWithCapacity:5];
	int keyId = 0;
	int x, y;
	for(x=0; x<GAME_BOARD_WIDTH; x++) {
		for(y=0; y<GAME_BOARD_HEIGHT; y++) {
			switch(tileString[GAME_BOARD_WIDTH*y+x]) {
				case '.': // space
				default:
					tiles[x][y] = GameTileSpace;
					break;
				case '*': // solid
					tiles[x][y] = GameTileSolid4Sides;
					break;
				case '!': // key
					tiles[x][y] = GameTileSpace;
					GameDataKey* k = [[GameDataKey alloc] init];
					k.x = x;
					k.y = y;
					k.used = FALSE;
					k.ident = keyId;
					keyId++;
					[keys addObject:k];
					break;
				case 'x': // chest
					tiles[x][y] = GameTileChest;
					break;
				case 'X': // open chest
					tiles[x][y] = GameTileChestOpen;
					break;
				case 'o': // door switch
					tiles[x][y] = GameTileSwitch;
					break;
				case '|': // left-right door closed
					tiles[x][y] = GameTileDoorLRClosed;
					break;
				case '#': // left-right door open
					tiles[x][y] = GameTileDoorLROpen;
					break;
				case '-': // top-bottom door closed
					tiles[x][y] = GameTileDoorTBClosed;
					break;
				case '=': // top-bottom door open
					tiles[x][y] = GameTileDoorTBOpen;
					break;
			}
		}
	}
	// figure out what all the walls should look like
	BOOL top, right, bottom, left;
	for(x=0; x<GAME_BOARD_WIDTH; x++) {
		for(y=0; y<GAME_BOARD_HEIGHT; y++) {
			if(tiles[x][y] == GameTileSolid4Sides) {
				top = FALSE; right = FALSE; bottom = FALSE; left = FALSE;
				if(y == 0 || (tiles[x][y-1] >= GameTileSolid4Sides && tiles[x][y-1] <= GameTileSolid0Sides))
					top = TRUE;
				if(x == GAME_BOARD_WIDTH-1 || (tiles[x+1][y] >= GameTileSolid4Sides && tiles[x+1][y] <= GameTileSolid0Sides))
					right = TRUE;
				if(y == GAME_BOARD_HEIGHT-1 || (tiles[x][y+1] >= GameTileSolid4Sides && tiles[x][y+1] <= GameTileSolid0Sides))
					bottom = TRUE;
				if(x == 0 || (tiles[x-1][y] >= GameTileSolid4Sides && tiles[x-1][y] <= GameTileSolid0Sides))
					left = TRUE;
				
				// set the walls tiles
				if(top && right && bottom && left)
					tiles[x][y] = GameTileSolid4Sides;
				else if(top && right && bottom && !left)
					tiles[x][y] = GameTileSolid3SidesTRB;
				else if(top && right && !bottom && left)
					tiles[x][y] = GameTileSolid3SidesTRL;
				else if(top && !right && bottom && left)
					tiles[x][y] = GameTileSolid3SidesTLB;
				else if(!top && right && bottom && left)
					tiles[x][y] = GameTileSolid3SidesRBL;
				else if(top && right && !bottom && !left)
					tiles[x][y] = GameTileSolid2SidesTR;
				else if(top && !right && bottom && !left)
					tiles[x][y] = GameTileSolid2SidesTB;
				else if(top && !right && !bottom && left)
					tiles[x][y] = GameTileSolid2SidesTL;
				else if(!top && right && bottom && !left)
					tiles[x][y] = GameTileSolid2SidesRB;
				else if(!top && right && !bottom && left)
					tiles[x][y] = GameTileSolid2SidesRL;
				else if(!top && !right && bottom && left)
					tiles[x][y] = GameTileSolid2SidesBL;
				else if(top && !right && !bottom && !left)
					tiles[x][y] = GameTileSolid1SidesT;
				else if(!top && right && !bottom && !left)
					tiles[x][y] = GameTileSolid1SidesR;
				else if(!top && !right && bottom && !left)
					tiles[x][y] = GameTileSolid1SidesB;
				else if(!top && !right && !bottom && left)
					tiles[x][y] = GameTileSolid1SidesL;
				else if(!top && !right && !bottom && !left)
					tiles[x][y] = GameTileSolid0Sides;
			}
		}
	}
}
- (BOOL) loadGame {
	if(![self isSavedGame])
		return FALSE;
	
	NSArray* savedGame = [NSArray arrayWithContentsOfFile:[self savedGamePath]];
	
	// load saved game
	stage = [[savedGame objectAtIndex:0] intValue];
	difficulty = [[savedGame objectAtIndex:1] intValue];
	options.difficulty = difficulty;
	level = [[savedGame objectAtIndex:2] intValue];
	movesLeft = [[savedGame objectAtIndex:4] intValue];
	
	// tile string
	strcpy(tileString, [[savedGame objectAtIndex:3] UTF8String]);
	
	// keys are special (key string format is "x,y,used:x,y,used:x,y,used")
    keys = [[NSMutableArray alloc] initWithCapacity:5];
	NSString* keyString = [savedGame objectAtIndex:5];
	NSMutableArray* keyPairs = [Helpers explodeDelimiter:@":" string:keyString];
	int keyId = 0;
	for(int i=0; i<[keyPairs count]; i++) {
		NSMutableArray* keyPair = [Helpers explodeDelimiter:@"," string:[keyPairs objectAtIndex:i]];
		GameDataKey* key = [[GameDataKey alloc] init];
		key.x = [[keyPair objectAtIndex:0] intValue];
		key.y = [[keyPair objectAtIndex:1] intValue];
		key.used = (BOOL)[[keyPair objectAtIndex:2] intValue];
		key.ident = keyId;
		keyId++;
		
		[keys addObject:key];
	}
	
	// set up the tiles
	int x, y;
	for(x=0; x<GAME_BOARD_WIDTH; x++)
		for(y=0; y<GAME_BOARD_HEIGHT; y++)
			tiles[x][y] = tileString[GAME_BOARD_WIDTH*y+x]-'A';
	
	return TRUE;
}
- (void) saveGame {
	// set up tile string
	int x, y;
	for(x=0; x<GAME_BOARD_WIDTH; x++)
		for(y=0; y<GAME_BOARD_HEIGHT; y++)
			tileString[GAME_BOARD_WIDTH*y+x] = tiles[x][y]+'A';
	tileString[GAME_BOARD_WIDTH*GAME_BOARD_HEIGHT] = '\0';
	
	// make the key string
	NSString* keyString = @"";
	for(int i=0; i<[keys count]; i++) {
		GameDataKey* key = [keys objectAtIndex:i];
		NSString* chunk = [NSString stringWithFormat:@"%i,%i,%i", key.x, key.y, key.used];
		keyString = [keyString stringByAppendingString:chunk];
		if(i < [keys count] - 1) {
			keyString = [keyString stringByAppendingString:@":"];
		}
	}
	
	// save the game
	NSMutableArray* savedGame = [NSMutableArray arrayWithCapacity:5];
	[savedGame addObject:[NSString stringWithFormat:@"%i", stage]];
	[savedGame addObject:[NSString stringWithFormat:@"%i", difficulty]];
	[savedGame addObject:[NSString stringWithFormat:@"%i", level]];
	[savedGame addObject:[NSString stringWithFormat:@"%s", tileString]];
	[savedGame addObject:[NSString stringWithFormat:@"%i", movesLeft]];
	[savedGame addObject:[NSString stringWithFormat:@"%@", keyString]];
	[savedGame writeToFile:[self savedGamePath] atomically:YES];
}
- (BOOL) isSavedGame {
	return [[NSFileManager defaultManager] fileExistsAtPath:[self savedGamePath]];
}

- (void) deleteSavedGame {
	[[NSFileManager defaultManager] removeItemAtPath:[self savedGamePath] error:nil];
}

// gameplay mechanics
- (void) moveKeys:(int)dir {
	int x, y, newX=-1, newY=-1;
	int keysMoved = 0;
	NSMutableArray* doorsSwitched = [NSMutableArray arrayWithCapacity:5];
	unsigned int i,j;
	GameDataKey* key;
	GameDataKey* key2;
	BOOL hitChest = FALSE; // debug
	
	// loop through the keys
	for(i=0; i < [keys count]; i++) {
		key = (GameDataKey*)[keys objectAtIndex:i];
		if(key.used == FALSE) {
			// find the coordinates if the key moved
			switch(dir) {
				case GameDirLeft:
					newX = key.x-1;
					newY = key.y;
					break;
				case GameDirRight:
					newX = key.x+1;
					newY = key.y;
					break;
				case GameDirDown:
					newX = key.x;
					newY = key.y+1;
					break;
			}
			
			// if it won't move off the board
			if(newX >= 0 && newX < GAME_BOARD_WIDTH && newY >= 0 && newY < GAME_BOARD_HEIGHT) {
				// if it hits nothing (or an open door), move it
				if(tiles[newX][newY] == GameTileSpace || tiles[newX][newY] == GameTileDoorLROpen || tiles[newX][newY] == GameTileDoorTBOpen) {
					key.x = newX;
					key.y = newY;
					keysMoved++;
				}
				
				// if it hits a chest, change it
				else if(tiles[newX][newY] == GameTileChest) {
					hitChest = TRUE; //debug
					key.used = TRUE;
					tiles[newX][newY] = GameTileChestOpen;
					key.x = newX;
					key.y = newY;
					keysMoved++;
					NSLog(@"GameData a key hit a chest!");
					
					// play open chest sound
					[sound playOpenChest];
				}
				
				// if it hits a door switch, open doors
				else if(tiles[newX][newY] == GameTileSwitch) {
					// move key
					key.x = newX;
					key.y = newY;
					keysMoved++;
					// toggle doors
					[doorsSwitched addObject:[NSString stringWithFormat:@"%i,%i", newX, newY]];
					NSLog(@"GameData a key hit a switch");
				}
			}
		}
	}
	
	// now that the keys have moved, go back and undo any key stacking
	BOOL keysAreStacked = TRUE;
	while(keysAreStacked) {
		keysAreStacked = FALSE;
		// loop through keys
		for(i=0; i<[keys count]; i++) {
			key = (GameDataKey*)[keys objectAtIndex:i];
			
			// if these keys aren't used yet
			if(key.used == FALSE) {
				// loop through keys again
				for(j=0; j<[keys count]; j++) {
					key2 = (GameDataKey*)[keys objectAtIndex:j];
					
					// and if these ones aren't used
					if(key2.used == FALSE) {
						// and we're not looking at the same key
						if(key.ident != key2.ident) {
							// and if they have the same coordinates
							if(key.x == key2.x && key.y == key2.y) {
								NSLog(@"GameData keys are stacked, unstacking...");
								keysAreStacked = TRUE;
								switch(dir) {
									case GameDirLeft:
										newX = key.x+1;
										newY = key.y;
										keysMoved--;
										break;
									case GameDirRight:
										newX = key.x-1;
										newY = key.y;
										keysMoved--;
										break;
									case GameDirDown:
										newX = key.x;
										newY = key.y-1;
										keysMoved--;
										break;
								}
								// if we unstack the key that hit the door, we didn't actually hit the door
								if([doorsSwitched count] > 0) {
									NSString* doorSwitchedString = [NSString stringWithFormat:@"%i,%i", key.x, key.y];
									for(int index=0; index<[doorsSwitched count]; index++) {
										if([(NSString*)[doorsSwitched objectAtIndex:index] compare:doorSwitchedString] ==    NSOrderedSame) {
											NSLog(@"GameData nevermind, the key that hit the door switch moved back");
											[doorsSwitched removeObjectAtIndex:index];
											break;
										}
									}
								}
								key.x = newX;
								key.y = newY;
							}
						}
					}
				}
			}
		}
	}
	
	// if doors have changed, lets make sure we haven't closed any doors on keys
	if([doorsSwitched count] > 0) {
		doorOpened = TRUE;
		// play door sound
		[sound playDoor];
		
		// open/close doors
		for(x=0; x<GAME_BOARD_WIDTH; x++) {
			for(y=0; y<GAME_BOARD_HEIGHT; y++) {
				// open closed doors
				if(tiles[x][y] == GameTileDoorLRClosed) {
					tiles[x][y] = GameTileDoorLROpen;
				} else if(tiles[x][y] == GameTileDoorTBClosed) {
					tiles[x][y] = GameTileDoorTBOpen;
				}
				// close open doors?
				else if(tiles[x][y] == GameTileDoorLROpen || tiles[x][y] == GameTileDoorTBOpen) {
					BOOL closeDoor = TRUE;
					for(i=0; i<[keys count]; i++) {
						key = (GameDataKey*)[keys objectAtIndex:i];
						
						if(key.used == FALSE) {
							// is there a key blocking this door?
							if(key.x == x && key.y == y) {
								closeDoor = FALSE;
								NSLog(@"GameData can't close a door, there's a key in the way");
							}
						}
					}
					// if we're supposed to close, or we're supposed to not close a different door
					if(closeDoor) {
						// then close
						if(tiles[x][y] == GameTileDoorLROpen) {
							tiles[x][y] = GameTileDoorLRClosed;
						} else {
							tiles[x][y] = GameTileDoorTBClosed;
						}
					} else {
						NSLog(@"close door should be FALSE, right?");
					}
				}
			}
		}
	} else {
		doorOpened = FALSE;
	}
	
	// if keys have indeed moved, substract from movesLeft
	if(keysMoved > 0) {
		movesLeft--;
		// play key move sounds
		[sound playKeyMove];
	}
	
	if(hitChest) {
		hitChest = TRUE; // debug
	}
}
- (BOOL) cannotMove {
	int tile;
	GameDataKey* key;

	// loop through keys seeing if they can move
	for(unsigned int i=0; i<[keys count]; i++) {
		           key = (GameDataKey*)[keys objectAtIndex:i];
		
		if(key.used == FALSE) {
			// left
			if(key.x > 0) {
				tile = tiles[key.x-1][key.y];
				if((tile == GameTileSpace || tile == GameTileChest || tile == GameTileDoorLROpen || tile == GameTileDoorTBOpen || tile == GameTileSwitch) && ![self isKeyAtPositionX:key.x-1 andY:key.y]) {
					return FALSE;
				}
			}
			
			// right
			if(key.x < GAME_BOARD_WIDTH-1) {
				tile = tiles[key.x+1][key.y];
				if((tile == GameTileSpace || tile == GameTileChest || tile == GameTileDoorLROpen || tile == GameTileDoorTBOpen || tile == GameTileSwitch) && ![self isKeyAtPositionX:key.x+1 andY:key.y]) {
					return FALSE;
				}
			}
			
			// down
			if(key.y < GAME_BOARD_HEIGHT-1) {
				tile = tiles[key.x][key.y+1];
				if((tile == GameTileSpace || tile == GameTileChest || tile == GameTileDoorLROpen || tile == GameTileDoorTBOpen || tile == GameTileSwitch) && ![self isKeyAtPositionX:key.x andY:key.y+1]) {
					return FALSE;
				}
			}
		}
	}
	return TRUE;
}

- (BOOL) isKeyAtPositionX:(int)x andY:(int)y {
    GameDataKey* key;
    for(unsigned int i=0; i<[keys count]; i++) {
        key = (GameDataKey*)[keys objectAtIndex:i];
        if(key.x == x && key.y == y) return TRUE;
    }
    return FALSE;
}

- (void) beatLevel {
	Level* l = (Level*)[levels.levels objectAtIndex:level-1];
	l.complete = TRUE;
	switch(difficulty) {
		case GameDifficultyEasy:   l.complete_easy = TRUE;   break;
		case GameDifficultyMedium: l.complete_medium = TRUE; break;
		case GameDifficultyHard:   l.complete_hard = TRUE;   break;
	}
	[levels save];
	NSLog(@"GameData marked level as complete");
}

// misc
- (BOOL) stageLocked:(int)stageToCheck {
	// levels per stage
	int min, max;
	switch(stageToCheck) {
		default:
		case GameStageCaves: // caves
			min = 1; max = 30;
			break;
		case GameStageBeach: // beach
			min = 31; max = 60;
			break;
		case GameStageShip: // pirate ship
			min = 61; max = 90;
			break;
	}
	
	// search the levels
	BOOL locked = FALSE;
	for(int i=min; i<=max; i++) {
        if(![levels isComplete:i]) {
			locked = TRUE;
			break;
		}
	}
	return locked;
}
- (int) stageForLevel:(int)levelToCheck {
	if(levelToCheck <= 30)
		return GameStageForest;
	else if(levelToCheck >= 31 && levelToCheck <= 60)
		return GameStageCaves;
	else if(levelToCheck >= 61 && levelToCheck <= 90)
		return GameStageBeach;
	else
		return GameStageShip;	
}

- (NSString*) stageName {
    if(stage == GameStageForest) return @"FOREST";
    else if(stage == GameStageCaves) return @"CAVES";
    else if(stage == GameStageBeach) return @"BEACH";
    else return @"SHIP";
}

// memory
- (void) freeKeys {
	/*for(NSUInteger i=0; i<[keys count]; i++) {
		[[keys objectAtIndex:i] dealloc];
	}*/
	[keys dealloc];
}



@end
