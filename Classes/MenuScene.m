//
//  MenuScene.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MapScene.h"
#import "InstructionsScene.h"
#import "OptionsScene.h"
#import "AchievementsScene.h"
#import "SkeletonKeyAppDelegate.h"

@implementation MenuScene

+ (id) scene {
	MenuScene* scene = [MenuScene node];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"MenuScene init");
		
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"background_forest_light.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// header
		CCSprite* header = [CCSprite spriteWithFile:@"menu_header.png"];
		header.position = ccp(160, 381);
		[self addChild:header];
		
		// menu
		CCMenuItemImage* play = [CCMenuItemImage itemFromNormalImage:@"menu_play.png" 
													   selectedImage:@"menu_play2.png" 
															  target:self
															selector:@selector(onPlay:)];
		CCMenuItemImage* instructions = [CCMenuItemImage itemFromNormalImage:@"menu_instructions.png" 
															   selectedImage:@"menu_instructions2.png" 
																	  target:self
																	selector:@selector(onInstructions:)];
		CCMenuItemImage* options = [CCMenuItemImage itemFromNormalImage:@"menu_options.png" 
														  selectedImage:@"menu_options2.png" 
																 target:self
															   selector:@selector(onOptions:)];
		CCMenuItemImage* achievements = [CCMenuItemImage itemFromNormalImage:@"menu_achievements.png" 
															   selectedImage:@"menu_achievements2.png" 
																	  target:self
																	selector:@selector(onAchievements:)];
		CCMenu* menu = [CCMenu menuWithItems:play, instructions, options, achievements, nil];
		[menu alignItemsVerticallyWithPadding:0];
		menu.position = ccp(160, 142.5);
		[self addChild: menu z:2];
	}
	return self;
}

- (void) onPlay:(id)sender {
	NSLog(@"MenuScene onPlay");
	[sound playClick];
    gameData.returnToGame = FALSE;
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[MapScene scene]]];
}

- (void) onInstructions:(id)sender {
	NSLog(@"MenuScene onInstructions");
	[sound playClick];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[InstructionsScene scene]]];
}

- (void) onOptions:(id)sender {
	NSLog(@"MenuScene onOptions");
	[sound playClick];
	gameData.returnToGame = FALSE;
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[OptionsScene scene]]];
}

- (void) onAchievements:(id)sender {
	NSLog(@"MenuScene onAchievements");
	[sound playClick];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[AchievementsScene scene]]];
}

- (void) dealloc {
	NSLog(@"MenuScene dealloc");
	[super dealloc];
}

@end
