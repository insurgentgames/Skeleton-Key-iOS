//
//  AchievementsScene.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AchievementsScene.h"
#import "MenuScene.h"
#import "SkeletonKeyAppDelegate.h"

@implementation AchievementsScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	AchievementsScene* layer = [AchievementsScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"AchievementsScene init");
		
		self.isTouchEnabled = YES;
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		achievements = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).achievements;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"achievements_background.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
        
        // menu
		back = [CCMenuItemImage itemFromNormalImage:@"achievements_back.png" 
									  selectedImage:@"achievements_back2.png" 
											 target:self
										   selector:@selector(onBack:)];
		back.opacity = 64;
		next = [CCMenuItemImage itemFromNormalImage:@"achievements_next.png" 
									  selectedImage:@"achievements_next2.png" 
											 target:self
										   selector:@selector(onNext:)];
		CCMenuItemImage* backToMenu = [CCMenuItemImage itemFromNormalImage:@"achievements_menu.png" 
															 selectedImage:@"achievements_menu2.png" 
																	target:self
																  selector:@selector(onMenu:)];
		CCMenu* menu = [CCMenu menuWithItems:back, backToMenu, next, nil];
		[menu alignItemsHorizontallyWithPadding:0];
		menu.position = ccp(160, 28.5);
		[self addChild:menu z:2];
				
		// pages
		pageNumber = 1;
		numPages = (int)(achievements.numAchievements / 5);
		if(achievements.numAchievements % 5 > 0)
			numPages++;
		pageLayer = [CCLayer node];
		[self addChild:pageLayer];
		
		// display achievements
		for(NSUInteger i=0; i<achievements.numAchievements; i++) {
			NSUInteger page = (int)(i / 5);
			NSUInteger y = 4 - (i % 5);
			
			NSString* topText = [achievements getName:i];
			NSString* bottomText = [achievements getDescription:i];
			
			// shadow
			CCSprite* achievement_shadow = [CCSprite spriteWithFile:@"achievements_shadow.png"];
			achievement_shadow.position = ccp(160+320*page, 92+68*y);
			[pageLayer addChild:achievement_shadow z:2];
			
			// text
			CCLabelTTF* achievment_label_top = [CCLabelTTF labelWithString:topText fontName:@"gabriola.ttf" fontSize:29];
			achievment_label_top.position = ccp(194+320*page, 107+68*y);
			[pageLayer addChild:achievment_label_top z:3];
			CCLabelTTF* achievment_label_bottom = [CCLabelTTF labelWithString:bottomText fontName:@"gabriola.ttf" fontSize:22];
			achievment_label_bottom.position = ccp(194+320*page, 81+68*y);
			[pageLayer addChild:achievment_label_bottom z:3];
			
			if([achievements.achieved objectAtIndex:i] == [NSNumber numberWithInt:1]) {
				// achieved
				CCSprite* achievement_trophy = [CCSprite spriteWithFile:@"achievements_trophy.png"];
				achievement_trophy.position = ccp(44+320*page, 92+68*y);
				[pageLayer addChild:achievement_trophy z:3];
			} else {
				// have not yet achieved
				CCSprite* achievement_trophy_locked = [CCSprite spriteWithFile:@"achievements_trophy_locked.png"];
				achievement_trophy_locked.position = ccp(44+320*page, 92+68*y);
				[pageLayer addChild:achievement_trophy_locked z:3];
				
				// fade the text
				achievment_label_top.opacity = 192;
				achievment_label_bottom.opacity = 192;
			}
		}
	}
	return self;
}

- (void) onBack:(id)sender {
	NSLog(@"AchievementsScene onBack");
	[sound playClick];
	[self moveBack];
}

- (void) onNext:(id)sender {
	NSLog(@"AchievementsScene onNext");
	[sound playClick];
	[self moveNext];
}

- (void) onMenu:(id)sender {
	NSLog(@"AchievementsScene onMenu");
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
	if(pageNumber < numPages) {
		pageNumber++;
		if(pageNumber == numPages)
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
	NSLog(@"AchievementsScene dealloc");
	[super dealloc];
}

@end
