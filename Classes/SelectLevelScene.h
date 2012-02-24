//
//  SelectLevelScene.h
//  Skeleton Key
//
//  Created by micah on 1/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Sound.h"
#import "Levels.h"
#import "GameData.h"
#import "Options.h"

typedef enum {
	SelectLevelTagNums = 50
} SelectLevelTags;

@interface SelectLevelScene : CCLayer {
	Sound* sound;
	Levels* levels;
	GameData* gameData;
	Options* options;
	
	CGPoint touchStart;
	int stage;
	int startingLevel;
	int levelToLoad;
	BOOL levelLoading;
	
	CCSprite* easy;
	CCSprite* medium;
	CCSprite* hard;
}

@property (readwrite) int stage;

+ (id) scene;

- (void) onBack:(id)sender;
- (void) updateDifficulty;
- (void) loadLevel:(id)sender;

@end
