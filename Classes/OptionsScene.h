//
//  OptionsScene.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "CCTouchDispatcher.h"
#import "Options.h"
#import "Sound.h"
#import "GameData.h"
#import "Levels.h"
#import "Achievements.h"

@interface OptionsScene : CCLayer {
	CCSprite* soundOn;
	CCSprite* soundOff;
	CCSprite* musicOn;
	CCSprite* musicOff;
	CCSprite* shakeOn;
	CCSprite* shakeOff;
	
	CCLayerColor* resetLayer;
	BOOL resetLayerUp;
	
	Options* options;
	Sound* sound;
	GameData* gameData;
	Levels* levels;
	Achievements* achievements;
}

+ (id) scene;

- (void) onReset:(id)sender;
- (void) onBack:(id)sender;
- (void) onResetConfirmYes:(id)sender;
- (void) onResetConfirmCancel:(id)sender;

- (void) updateOptions;

@end
