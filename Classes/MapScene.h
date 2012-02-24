//
//  MapScene.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Sound.h"
#import "GameData.h"

@interface MapScene : CCLayer {
	bool stageLockedForest;
	bool stageLockedCaves;
	bool stageLockedBeach;
	bool stageLockedShip;
	
	CGPoint forestPoint;
	CGPoint cavesPoint;
	CGPoint beachPoint;
	CGPoint shipPoint;
	
	Sound* sound;
	GameData* gameData;
    
    CCSprite* forest;
    CCSprite* caves;
    CCSprite* beach;
    CCSprite* ship;
}

+ (id) scene;
+ (id) sceneWithStage:(int)stage;
- (void) highlight:(int)stage;

@end
