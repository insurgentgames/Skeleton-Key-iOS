//
//  MapScene.m
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapScene.h"
#import "SkeletonKeyAppDelegate.h"
#import "SelectLevelScene.h"

@implementation MapScene

+ (id) scene {
    return [MapScene sceneWithStage:GameStageNone];
}

+ (id) sceneWithStage:(int)stage {
	CCScene* scene = [CCScene node];
	MapScene* layer = [MapScene node];
    [layer highlight:stage];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"MapScene init");
		
		self.isTouchEnabled = YES;
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		
		// background
		CCSprite* background = [CCSprite spriteWithFile:@"map_background.png"];
		background.position = ccp(160, 240);
		[self addChild:background];
		
		// the key and locks
		stageLockedForest = false;
		stageLockedCaves = [gameData stageLocked:GameStageCaves];
		stageLockedBeach = [gameData stageLocked:GameStageBeach];
		stageLockedShip = [gameData stageLocked:GameStageShip];
		forestPoint = ccp(153, 413);
		cavesPoint = ccp(268, 310);
		beachPoint = ccp(112, 210);
		shipPoint = ccp(284, 81);
		
		// make the animation
		NSString* filename;
		
		// forest
		forest = [CCSprite spriteWithFile:@"map_key.png"];
		forest.position = forestPoint;
		forest.rotation = -10;
		[forest runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
															 [CCRotateBy actionWithDuration:0.5 angle:20], 
															 [CCRotateBy actionWithDuration:0.5 angle:-20], 
															 nil]]];
		[self addChild:forest z:3];
		
		// caves
		if(stageLockedCaves)
			filename = @"map_lock.png";
		else
			filename = @"map_key.png";
		caves = [CCSprite spriteWithFile:filename];
		caves.position = cavesPoint;
		caves.rotation = -10;
		[caves runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
															[CCRotateBy actionWithDuration:0.5 angle:20], 
															[CCRotateBy actionWithDuration:0.5 angle:-20], 
															nil]]];
		[self addChild:caves z:3];
		
		// beach
		if(stageLockedBeach)
			filename = @"map_lock.png";
		else
			filename = @"map_key.png";
		beach = [CCSprite spriteWithFile:filename];
		beach.position = beachPoint;
		beach.rotation = -10;
		[beach runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
															[CCRotateBy actionWithDuration:0.5 angle:20], 
															[CCRotateBy actionWithDuration:0.5 angle:-20], 
															nil]]];
		[self addChild:beach z:3];
		
		// pirate ship
		if(stageLockedShip)
			filename = @"map_lock.png";
		else
			filename = @"map_key.png";
		ship = [CCSprite spriteWithFile:filename];
		ship.position = shipPoint;
		ship.rotation = -10;
		[ship runAction:[CCRepeatForever actionWithAction:[CCSequence actions:
														   [CCRotateBy actionWithDuration:0.5 angle:20], 
														   [CCRotateBy actionWithDuration:0.5 angle:-20], 
														   nil]]];
		[self addChild:ship z:3];
	}
	return self;
}

- (void) highlight:(int)stage {
    // highlight?
    CGPoint *point;
    switch(stage) {
        default: point = nil; break;
        case GameStageForest: point = &forestPoint; break;
        case GameStageCaves: point = &cavesPoint; break;
        case GameStageBeach: point = &beachPoint; break;
        case GameStageShip: point = &shipPoint; break;
    }
    if(point != nil) {
        CCParticleFlower *emitter = [CCParticleFlower node];
        emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"map_sparkle.png"];
        emitter.position = *point;
        emitter.emissionRate = 10;
        emitter.totalParticles = 30;
        emitter.speed = 50;
        emitter.speedVar = 50;
        emitter.startColor = (ccColor4F){1, 1, 1, 0.3};
        emitter.startColorVar = (ccColor4F){0.2, 0.2, 0.2, 0.5};
        [self addChild:emitter z:2];
    }
}

- (void) registerWithTouchDispatcher {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchEnd = [self convertTouchToNodeSpace:touch];
	
	// calculate distances
	float forestDistance = (float)sqrt(pow(touchEnd.x-forestPoint.x,2)+pow(touchEnd.y-forestPoint.y,2));
	float cavesDistance = (float)sqrt(pow(touchEnd.x-cavesPoint.x,2)+pow(touchEnd.y-cavesPoint.y,2));
	float beachDistance = (float)sqrt(pow(touchEnd.x-beachPoint.x,2)+pow(touchEnd.y-beachPoint.y,2));
	float shipDistance = (float)sqrt(pow(touchEnd.x-shipPoint.x,2)+pow(touchEnd.y-shipPoint.y,2));
	
	// set the stage
	if(forestDistance < cavesDistance && forestDistance < beachDistance && forestDistance < shipDistance)
		gameData.stage = GameStageForest;
	else if(cavesDistance < forestDistance && cavesDistance < beachDistance && cavesDistance < shipDistance)
		gameData.stage = GameStageCaves;
	else if(beachDistance < forestDistance && beachDistance < cavesDistance && beachDistance < shipDistance)
		gameData.stage = GameStageBeach;
	else
		gameData.stage = GameStageShip;
	
	// if the selected stage is unlocked
	if((gameData.stage == GameStageForest && !stageLockedForest) || 
	   (gameData.stage == GameStageCaves && !stageLockedCaves) || 
	   (gameData.stage == GameStageBeach && !stageLockedBeach) || 
	   (gameData.stage == GameStageShip && !stageLockedShip)) {
		
		// redirect to select level scene
		[sound playClick];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SelectLevelScene scene]]];
	} else {
		// map locked sound
		[sound playMapLocked];
	}
}

- (void) dealloc {
	NSLog(@"MapScene dealloc");
	[super dealloc];
}


@end
