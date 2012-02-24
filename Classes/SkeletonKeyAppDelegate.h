//
//  SkeletonKeyAppDelegate.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkeletonKeyWindow.h"
#import "Sound.h"
#import "Options.h"
#import "Achievements.h"
#import "Levels.h"
#import "GameData.h"
#import "GameScene.h"
#import "Helpers.h"

@class RootViewController;

@interface SkeletonKeyAppDelegate : NSObject <UIApplicationDelegate> {
	SkeletonKeyWindow* window;
	RootViewController* viewController;
	
	Sound* sound;
	Options* options;
	Achievements* achievements;
	Levels* levels;
	GameData* gameData;
    GameScene* currentGame;
}

@property (nonatomic, retain) SkeletonKeyWindow* window;
@property (nonatomic, retain) Options* options;
@property (nonatomic, retain) Sound* sound;
@property (nonatomic, retain) Achievements* achievements;
@property (nonatomic, retain) Levels* levels;
@property (nonatomic, retain) GameData* gameData;
@property (nonatomic, retain) GameScene* currentGame;

@end
