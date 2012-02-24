//
//  NagScene.m
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NagScene.h"
#import "MenuScene.h"

@implementation NagScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	NagScene* layer = [NagScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"NagScene init");
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"background_forest_dark.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// header
		CCSprite* header = [CCSprite spriteWithFile:@"nag_header.png"];
		header.position = ccp(160, 353);
		[self addChild:header];
		
		// menu
		CCMenuItemImage* yes = [CCMenuItemImage itemFromNormalImage:@"nag_yes.png" 
													  selectedImage:@"nag_yes2.png" 
															 target:self selector:@selector(onYes:)];
		CCMenuItemImage* no = [CCMenuItemImage itemFromNormalImage:@"nag_no.png" 
													 selectedImage:@"nag_no2.png" 
															target:self selector:@selector(onNo:)];
		CCMenu* menu = [CCMenu menuWithItems:yes, no, nil];
		menu.position = ccp(160, 113);
		[menu alignItemsVerticallyWithPadding:0];
		[self addChild:menu];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"NagScene dealloc");
	[super dealloc];
}

- (void) onYes:(id)sender {
	NSLog(@"NagScene onYes");
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/skeleton-key/id327122772?mt=8"]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene scene]]];
}

- (void) onNo:(id)sender {
	NSLog(@"NagScene onNo");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[MenuScene scene]]];
}

@end
