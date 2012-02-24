//
//  Sound.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "SimpleAudioEngine.h"
#import "Options.h"

@interface Sound : NSObject {
	bool gameplayPlaying;
	int gameplayMusicNum;
	int gameplayStart;
	Options* options;
}

- (void) play:(NSString*)sound;
- (void) playKeyMove;
- (void) playOpenChest;
- (void) playRestartLevel;
- (void) playDoor;
- (void) playClick;
- (void) playMapLocked;
- (void) playUnlockAchievement;

- (void) startMusicMenu;
- (void) startMusicGameplay;
- (void) stopMusic;

@end
