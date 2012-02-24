//
//  InstructionsScene.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InstructionsScene.h"
#import "MenuScene.h"
#import "SkeletonKeyAppDelegate.h"

@implementation InstructionsScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	InstructionsScene* layer = [InstructionsScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"InstructionsScene init");
		
		self.isTouchEnabled = YES;
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"background_forest_dark.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// header
		CCSprite* header = [CCSprite spriteWithFile:@"instructions_header.png"];
		header.position = ccp(160, 439.5);
		[self addChild:header];
		
		// menu
		back = [CCMenuItemImage itemFromNormalImage:@"instructions_back.png" 
									  selectedImage:@"instructions_back2.png" 
											 target:self
										   selector:@selector(onBack:)];
		back.opacity = 64;
		next = [CCMenuItemImage itemFromNormalImage:@"instructions_next.png" 
									  selectedImage:@"instructions_next2.png" 
											 target:self
										   selector:@selector(onNext:)];
		CCMenuItemImage* backToMenu = [CCMenuItemImage itemFromNormalImage:@"instructions_menu.png" 
															 selectedImage:@"instructions_menu2.png" 
																	target:self
																  selector:@selector(onMenu:)];
		CCMenu* menu = [CCMenu menuWithItems:back, backToMenu, next, nil];
		[menu alignItemsHorizontallyWithPadding:0];
		menu.position = ccp(160, 28.5);
		[self addChild:menu z:2];
		
		// the page
		pageNumber = 1;
		pageLayer = [CCLayer node];
		[self addChild:pageLayer];
		CCSprite* page1 = [CCSprite spriteWithFile:@"instructions_page1.png"];
		CCSprite* page2 = [CCSprite spriteWithFile:@"instructions_page2.png"];
		CCSprite* page3 = [CCSprite spriteWithFile:@"instructions_page3.png"];
		CCSprite* page4 = [CCSprite spriteWithFile:@"instructions_page4.png"];
		page1.position = ccp(160, 228);
		page2.position = ccp(480, 228);
		page3.position = ccp(800, 228);
		page4.position = ccp(1120, 228);
		[pageLayer addChild:page1];
		[pageLayer addChild:page2];
		[pageLayer addChild:page3];
		[pageLayer addChild:page4];
	}
	return self;
}

- (void) onBack:(id)sender {
	NSLog(@"InstructionsScene onBack");
	[sound playClick];
	[self moveBack];
}

- (void) onNext:(id)sender {
	NSLog(@"InstructionsScene onNext");
	[sound playClick];
	[self moveNext];
}

- (void) onMenu:(id)sender {
	NSLog(@"InstructionsScene onMenu");
	[sound playClick];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[MenuScene scene] backwards:YES]];
}

- (void) moveBack {
	if(pageNumber > 1) {
		pageNumber--;
		if(pageNumber == 1)
			back.opacity = 64;
		next.opacity = 255;
		[self scroll];
	}
}

- (void) moveNext {
	if(pageNumber < 4) {
		pageNumber++;
		if(pageNumber == 4)
			next.opacity = 64;
		back.opacity = 255;
		[self scroll];
	}
}

- (void) scroll {
	CGFloat x = (pageNumber-1)*-320;
	[pageLayer runAction:[CCMoveTo actionWithDuration:0.2 position:ccp(x, 0)]];
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	touchStart = [self convertTouchToNodeSpace:touch];
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchEnd = [self convertTouchToNodeSpace:touch];
	
	switch([Helpers swipeDirectionStart:touchStart end:touchEnd]) {
		case GameDirLeft:
			[sound playKeyMove];
			[self moveNext];
			break;
		case GameDirRight:
			[sound playKeyMove];
			[self moveBack];
			break;
	}
}

- (void) dealloc {
	NSLog(@"InstructionsScene dealloc");
	[super dealloc];
}

@end
