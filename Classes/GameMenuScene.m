//
//  GameMenu.m
//  Skeleton Key HD
//
//  Created by micah on 1/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameMenuScene.h"
#import "SkeletonKeyAppDelegate.h"
#import "MenuScene.h"
#import "OptionsScene.h"
#import "GameScene.h"
#import "MapScene.h"

@implementation GameMenuScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	GameMenuScene* layer = [GameMenuScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"GameMenuScene init");
		
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"background_forest_light.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// header
		CCSprite* header = [CCSprite spriteWithFile:@"game_menu_header.png"];
		header.position = ccp(160, 420);
		[self addChild:header z:1];
		
		// status
		CCSprite* statusBackground = [CCSprite spriteWithFile:@"game_menu_status_background.png"];
		statusBackground.position = ccp(160, 335);
		[self addChild:statusBackground z:1];
        CCLabelTTF* statusLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@ * LEVEL %i", [gameData stageName], gameData.level] fontName:@"gabriola.ttf" fontSize:25];
        statusLabel.color = ccc3(147,213,18);
        statusLabel.position = ccp(160, 330);
        [self addChild:statusLabel z:2];
		
		// top menu
		CCMenuItemImage* resume = [CCMenuItemImage itemFromNormalImage:@"game_menu_resume.png" 
														 selectedImage:@"game_menu_resume2.png" 
																target:self
															  selector:@selector(onResume:)];
		CCMenuItemImage* restart = [CCMenuItemImage itemFromNormalImage:@"game_menu_restart.png" 
														  selectedImage:@"game_menu_restart2.png" 
																 target:self
															   selector:@selector(onRestart:)];
		CCMenuItemImage* choose = [CCMenuItemImage itemFromNormalImage:@"game_menu_choose.png" 
															 selectedImage:@"game_menu_choose2.png" 
																	target:self
																  selector:@selector(onChoose:)];
		CCMenu* top_menu = [CCMenu menuWithItems:resume, restart, choose, nil];
		[top_menu alignItemsVerticallyWithPadding:0];
		top_menu.position = ccp(160, 234.5);
		[self addChild: top_menu z:2];
		
		// bottom menu
		CCMenuItemImage* options = [CCMenuItemImage itemFromNormalImage:@"game_menu_options.png" 
														  selectedImage:@"game_menu_options2.png" 
																 target:self
															   selector:@selector(onOptions:)];
		CCMenuItemImage* main_menu = [CCMenuItemImage itemFromNormalImage:@"game_menu_main.png" 
														  selectedImage:@"game_menu_main2.png" 
																 target:self
															   selector:@selector(onMainMenu:)];
		CCMenu* bottom_menu = [CCMenu menuWithItems:options, main_menu, nil];
		[bottom_menu alignItemsVerticallyWithPadding:0];
		bottom_menu.position = ccp(160, 80);
		[self addChild: bottom_menu z:2];
	}
	return self;
}

- (void) onResume:(id)sender {
	NSLog(@"GameMenuScene onResume");
	[sound playClick];
	[gameData loadGame];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[GameScene scene] backwards:YES]];
}

- (void) onRestart:(id)sender {
	NSLog(@"GameMenuScene onRestart");
	[sound playRestartLevel];
	[gameData loadLevel];
	[gameData saveGame];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[GameScene scene] backwards:YES]];
}

- (void) onChoose:(id)sender {
	NSLog(@"GameMenuScene onChoose");
	[sound playClick];
    gameData.returnToGame = TRUE;
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[MapScene scene] backwards:YES]];
}

- (void) onOptions:(id)sender {
	NSLog(@"GameMenuScene onOptions");
	[sound playClick];
	gameData.returnToGame = TRUE;
	[gameData loadGame];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[OptionsScene scene]]];
}

- (void) onMainMenu:(id)sender {
	NSLog(@"GameMenuScene onMainMenu");
	[sound playClick];
	
	// delete saved game
	[gameData deleteSavedGame];
	
	// change music
	[sound startMusicMenu];
	
	// go to menu
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[MenuScene scene]]];
}

- (void) dealloc {
	NSLog(@"GameMenuScene dealloc");
	[super dealloc];
}

@end
