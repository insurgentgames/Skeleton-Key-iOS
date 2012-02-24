//
//  OptionsScene.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "SkeletonKeyAppDelegate.h"


@implementation OptionsScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	OptionsScene* layer = [OptionsScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"OptionsScene init");
		
		self.isTouchEnabled = YES;
		options = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).options;
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		levels = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).levels;
		achievements = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).achievements;
		resetLayerUp = NO;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"options_background.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// options
		soundOn = [CCSprite spriteWithFile:@"options_sound_on.png"];
		soundOn.position = ccp(160, 332);
		soundOff = [CCSprite spriteWithFile:@"options_sound_off.png"];
		soundOff.position = ccp(160, 332);
		musicOn = [CCSprite spriteWithFile:@"options_music_on.png"];
		musicOn.position = ccp(160, 276);
		musicOff = [CCSprite spriteWithFile:@"options_music_off.png"];
		musicOff.position = ccp(160, 276);
		shakeOn = [CCSprite spriteWithFile:@"options_shake_on.png"];
		shakeOn.position = ccp(160, 220);
		shakeOff = [CCSprite spriteWithFile:@"options_shake_off.png"];
		shakeOff.position = ccp(160, 220);
		[self updateOptions];
		[self addChild:soundOn z:2];
		[self addChild:soundOff z:2];
		[self addChild:musicOn z:2];
		[self addChild:musicOff z:2];
		[self addChild:shakeOn z:2];
		[self addChild:shakeOff z:2];
		
		// reset data
		if(!gameData.returnToGame) {
			CCMenuItemImage* reset = [CCMenuItemImage itemFromNormalImage:@"options_reset.png" 
															selectedImage:@"options_reset2.png" 
																   target:self selector:@selector(onReset:)];
			CCMenu* resetMenu = [CCMenu menuWithItems:reset, nil];
			resetMenu.position = ccp(160, 104);
			[self addChild:resetMenu z:2];
		}
		
		// back to menu or game
		CCMenuItemImage* back;
		if(gameData.returnToGame) {
			back = [CCMenuItemImage itemFromNormalImage:@"options_back_game.png" 
										  selectedImage:@"options_back_game2.png"
												 target:self selector:@selector(onBack:)];
		} else {
			back = [CCMenuItemImage itemFromNormalImage:@"options_back_menu.png" 
										  selectedImage:@"options_back_menu2.png"
												 target:self selector:@selector(onBack:)];
		}
		CCMenu* backMenu = [CCMenu menuWithItems:back, nil];
		backMenu.position = ccp(160, 28);
		[self addChild:backMenu z:2];
	}
	return self;
}

- (void) onReset:(id)sender {
	if(resetLayerUp) return;
	
	NSLog(@"OptionsScene onReset");
	[sound playClick];
	resetLayerUp = YES;
	
	// set up the reset layer
	resetLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 192)];
	
	// the background
	CCSprite* background = [CCSprite spriteWithFile:@"options_reset_confirm_background.png"];
	background.position = ccp(160, 277);
	[resetLayer addChild:background];
	
	// the menu
	CCMenuItemImage* yes = [CCMenuItemImage itemFromNormalImage:@"options_reset_confirm_yes.png" 
												  selectedImage:@"options_reset_confirm_yes2.png" 
														 target:self selector:@selector(onResetConfirmYes:)];
	CCMenuItemImage* cancel = [CCMenuItemImage itemFromNormalImage:@"options_reset_confirm_cancel.png" 
													 selectedImage:@"options_reset_confirm_cancel2.png" 
															target:self selector:@selector(onResetConfirmCancel:)];
	CCMenu* menu = [CCMenu menuWithItems:yes, cancel, nil];
	menu.position = ccp(160, 221);
	[menu alignItemsHorizontallyWithPadding:0];
	[resetLayer addChild:menu z:2];
	
	// add the reset layer
	[self addChild:resetLayer z:3];
}

- (void) onBack:(id)sender {
	NSLog(@"OptionsScene onBack");
	[sound playClick];
	if(gameData.returnToGame) {
        [options load];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[GameScene scene] backwards:YES]];
	} else {
		[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[MenuScene scene] backwards:YES]];
	}
}

- (void) onResetConfirmYes:(id)sender {
	NSLog(@"OptionsScene onResetConfirmYes");
	[sound playClick];
	
	// delete saved game
	[gameData deleteSavedGame];
	
	// reset all levels
	[levels reset];
	
	// reset all achievements
	[achievements reset];
	
	[self removeChild:resetLayer cleanup:YES];
	resetLayerUp = NO;
}

- (void) onResetConfirmCancel:(id)sender {
	NSLog(@"OptionsScene onResetConfirmCancel");
	[sound playClick];
	[self removeChild:resetLayer cleanup:YES];
	resetLayerUp = NO;
}

- (void) updateOptions {
	if(options.sound) {
		soundOn.opacity = 255;
		soundOff.opacity = 0;
	} else {
		soundOn.opacity = 0;
		soundOff.opacity = 255;
	}
	if(options.music) {
		musicOn.opacity = 255;
		musicOff.opacity = 0;
	} else {
		musicOn.opacity = 0;
		musicOff.opacity = 255;
	}
	if(options.shake) {
		shakeOn.opacity = 255;
		shakeOff.opacity = 0;
	} else {
		shakeOn.opacity = 0;
		shakeOff.opacity = 255;
	}
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	if(resetLayerUp) return;
	CGPoint location = [self convertTouchToNodeSpace:touch];
	
	CGRect soundRect = CGRectMake(10, 340, 301, 56);
	CGRect musicRect = CGRectMake(10, 248, 301, 56);
	CGRect shakeRect = CGRectMake(10, 193, 301, 56);
	
	BOOL toggled = FALSE;
	
	// sound?
	if(CGRectContainsPoint(soundRect, location)) {
		[sound playClick];
		if(options.sound) {
			NSLog(@"OptionsScene sound turned off");
			options.sound = 0;
		} else {
			NSLog(@"OptionsScene sound turned on");
			options.sound = 1;
		}
		toggled = TRUE;
	}
	
	// music?
	if(CGRectContainsPoint(musicRect, location)) {
		[sound playClick];
		if(options.music) {
			NSLog(@"OptionsScene music turned off");
			[sound stopMusic];
			options.music = 0;
		} else {
			NSLog(@"OptionsScene music turned on");
			options.music = 1;
			[sound startMusicMenu];
		}
		toggled = TRUE;
	}
	
	// shake?
	if(CGRectContainsPoint(shakeRect, location)) {
		[sound playClick];
		if(options.shake) {
			NSLog(@"OptionsScene shake turned off");
			options.shake = 0;
		} else {
			NSLog(@"OptionsScene shake turned on");
			options.shake = 1;
		}
		toggled = TRUE;
	}
	
	if(toggled) {
		[self updateOptions];
		[options save];
	}
}

- (void) dealloc {
	NSLog(@"OptionsScene dealloc");
	[super dealloc];
}

@end
