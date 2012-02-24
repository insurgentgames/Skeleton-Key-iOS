//
//  GameScene.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import "Sound.h"
#import "Options.h"
#import "GameData.h"
#import "Achievements.h"
#import "Levels.h"
#import "GameTile.h"
#import "Helpers.h"

// tags
typedef enum {
	GameTagMoves = 1,
	GameTagLevelCompleteBackground = 2,
	GameTagLevelComplete = 3,
	GameTagLevelCompleteLabel = 4,
	GameTagLevelCompletePerfect = 5,
	GameTagAchievementLayer = 6,
	GameTagMessage = 7,
	GameTagTiles = 100,
	GameTagKeys = 200
} GameTags;

// messages
typedef enum {
	GameMessageNoMessage = 0,
	GameMessageSwipeScreen = 1,
	GameMessageNoMovesMenu = 2,
	GameMessageNoMovesShake = 3
} GameMessages;

@interface GameScene : CCLayer {
	Sound* sound;
	Options* options;
	GameData* gameData;
	Achievements* achievements;
	Levels* levels;
	
	int message;
	BOOL won;
	BOOL firstMove;
	BOOL isAchievementActive;
	
	CGPoint touchStart;
}

+ (id) scene;

- (void) setCurrentGame;
- (void) unsetCurrentGame;

- (void) restartLevel;
- (void) moveKeys:(int)dir;
- (void) onCompletedLevel:(id)sender;
- (void) messageDisplay:(int)messageToDisplay;
- (void) onRemoveMessage:(id)sender;
- (void) unlockAchievement:(int)achievementId;
- (void) onRemoveAchievement:(id)sender;
- (void) onMenu:(id)sender;
- (void) shake;

@end
