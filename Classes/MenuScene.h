//
//  MenuScene.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Sound.h"
#import "GameData.h"

@interface MenuScene : CCScene {
	Sound* sound;
	GameData* gameData;
}

+ (id) scene;

- (void) onPlay:(id)sender;
- (void) onInstructions:(id)sender;
- (void) onOptions:(id)sender;
- (void) onAchievements:(id)sender;

@end
