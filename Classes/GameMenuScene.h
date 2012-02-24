//
//  GameMenuScene.h
//  Skeleton Key HD
//
//  Created by micah on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Sound.h"
#import "GameData.h"

@interface GameMenuScene : CCLayer {
	Sound* sound;
	GameData* gameData;
}

+ (id) scene;

// buttons
- (void) onResume:(id)sender;
- (void) onRestart:(id)sender;
- (void) onChoose:(id)sender;
- (void) onOptions:(id)sender;
- (void) onMainMenu:(id)sender;

@end
