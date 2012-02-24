//
//  GameScene.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SkeletonKeyAppDelegate.h"
#import "GameMenuScene.h"
#import "MapScene.h"
#import "SelectLevelScene.h"
#import "MenuScene.h"

@implementation GameScene

+ (id) scene {
	CCScene* scene = [CCScene node];
	GameScene* layer = [GameScene node];
	[scene addChild:layer];
	return scene;
}

- (id) init {
	if((self=[super init])) {
		NSLog(@"GameScene init");
		
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
		sound = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).sound;
		options = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).options;
		gameData = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).gameData;
		achievements = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).achievements;
		levels = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).levels;
		self.isTouchEnabled = YES;
        
		// set the game as active
		gameData.activeGame = TRUE;
		
		// start the level
		[self restartLevel];
	}
	return self;
}

- (void) setCurrentGame {
    // let the applicatin know who's in charge
    SkeletonKeyAppDelegate* delegate = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate));
    delegate.currentGame = self;
}
- (void) unsetCurrentGame {
    // stop letting the applicatin know who's in charge
    SkeletonKeyAppDelegate* delegate = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate));
    delegate.currentGame = nil;
}

- (void) dealloc {
	NSLog(@"GameScene dealloc");
    
	gameData.activeGame = FALSE;
	[gameData saveGame];
	[super dealloc];
}

- (void) restartLevel {
	// in case we've already been playing
	[self removeAllChildrenWithCleanup:YES];
    [self setCurrentGame];
	
	// background
	CCSprite* background;
	NSString* backgroundFilename;
	switch(gameData.stage) {
		case GameStageForest: backgroundFilename = @"game_background_forest.png"; break;
		case GameStageCaves:  backgroundFilename = @"game_background_caves.png";  break;
		case GameStageBeach:  backgroundFilename = @"game_background_beach.png";  break;
		case GameStageShip:	  backgroundFilename = @"game_background_ship.png";   break;
	}
	background = [CCSprite spriteWithFile:backgroundFilename];
	background.position = ccp(160, 240);
	[self addChild:background z:0];
	
	// the frame
	CCSprite* frame = [CCSprite spriteWithFile:@"game_frame.png"];
	frame.position = ccp(160, 240);
	[self addChild:frame z:3];
	
	// menu button
	CCMenuItemImage* menuItem = [CCMenuItemImage itemFromNormalImage:@"game_menu.png" 
													   selectedImage:@"game_menu2.png" 
															  target:self selector:@selector(onMenu:)];
	CCMenu* menu = [CCMenu menuWithItems:menuItem, nil];
	[menu alignItemsVerticallyWithPadding:0];
	menu.position = ccp(54.5, 450.5);
	[self addChild:menu z:4];
	
	// heads up display
	CCLabelTTF* level = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [gameData level]] fontName:@"deutsch.ttf" fontSize:20];
	level.position = ccp(160, 458);
	[self addChild:level z:4];
	CCLabelTTF* moves = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [gameData movesLeft]] fontName:@"deutsch.ttf" fontSize:20];
	moves.position = ccp(262, 458);
	[self addChild:moves z:4 tag:GameTagMoves];
	
	// draw the tiles
	int x,y;
	GameTile* tile;
	for(x=0; x<GAME_BOARD_WIDTH; x++) {
		for(y=0; y<GAME_BOARD_HEIGHT; y++) {
			int tileType = [gameData getTileTypeX:x andY:y];
			if(tileType != GameTileSpace) {
				tile = [GameTile tileWithType:tileType andX:x andY:y];
				[self addChild:tile z:2 tag:GameTagTiles+(GAME_BOARD_WIDTH*y+x)];
			}
		}
	}
	
	// draw the keys
	for(int i=0; i < [gameData.keys count]; i++) {
		GameDataKey* key = [gameData.keys objectAtIndex:i];
		if(!key.used) {
			tile = [GameTile tileWithType:GameTileKey andX:key.x andY:key.y];
			[self addChild:tile z:2 tag:GameTagKeys+i];
		}
	}
	
	// check for winning
	won = FALSE;
	
	// message
	if(gameData.level == 1) {
		[self messageDisplay:GameMessageSwipeScreen];
	}
	
	// only save the game if a move has been made
	firstMove = FALSE;
	
	// achievements
	isAchievementActive = FALSE;
}

- (void) moveKeys:(int)dir {
    if(won) return;
    
	firstMove = TRUE;
	
	int movesLeft = gameData.movesLeft;
	if(movesLeft == 0) {
		// out of moves, sorry
		if(options.shake) {
			[self messageDisplay:GameMessageNoMovesShake];
		} else {
			[self messageDisplay:GameMessageNoMovesMenu];
		}
		return;
	}
	
	// update moves left label?
	[gameData moveKeys:dir];
	if(gameData.doorOpened) {
		// achievement "Knock Knock"
		[self unlockAchievement:AchievementKnockKnock];
		achievements.doorsOpened++;
		[achievements save];
		
		// check for achievement "The Doorman"
		if(achievements.doorsOpened == 50) {
			[self unlockAchievement:AchievementTheDoorman];
		}
		
		// check for achievement "The Door to Nowhere"
		if(gameData.level == 85) {
			[self unlockAchievement:AchievementTheDoorToKnowhere];
		}
	}
	if(gameData.movesLeft != movesLeft) {
		CCLabelTTF* moves = (CCLabelTTF*)[self getChildByTag:GameTagMoves];
		[moves setString:[NSString stringWithFormat:@"%i", gameData.movesLeft]];
	}
	
	// update the tiles, keys
	for(int x2=0; x2<GAME_BOARD_WIDTH; x2++) {
		for(int y2=0; y2<GAME_BOARD_HEIGHT; y2++) {
			GameTile* tile = (GameTile*)[self getChildByTag:GameTagTiles+(GAME_BOARD_WIDTH*y2+x2)];
			if(tile != nil) {
				int tileType = [gameData getTileTypeX:x2 andY:y2];
				if(tileType != tile.tileType) {
					[tile changeType:tileType];
				}
			}
		}
	}
	// update the keys
	for(int i=0; i<[gameData.keys count]; i++) {
		GameTile* tile = (GameTile*)[self getChildByTag:GameTagKeys+i];
		if(tile != nil) {
			// if it's used now, remove it
			GameDataKey* key = (GameDataKey*)[gameData.keys objectAtIndex:i];
			if(key.used) {
				[self removeChildByTag:GameTagKeys+i cleanup:YES];
			} else {
				// if the key has moved, update it
				if(tile.x != key.x || tile.y != key.y)
					[tile changePositionX:key.x andY:key.y];
			}
		}
	}
	
	// check for a win
	BOOL checkForWin = TRUE;
	for(int i=0; i<[gameData.keys count]; i++) {
		GameDataKey* key = (GameDataKey*)[gameData.keys objectAtIndex:i];
		if(key.used == FALSE)
			checkForWin = FALSE;
	}
	if(checkForWin) {
        won = TRUE;
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.01], [CCCallFunc actionWithTarget:self selector:@selector(onCompletedLevel:)], nil]];
	} else {
		// check for stuck
		if([gameData cannotMove]) {
			if(options.shake) {
				[self messageDisplay:GameMessageNoMovesShake];
			} else {
				[self messageDisplay:GameMessageNoMovesMenu];
			}
		}
	}
}

- (void) onCompletedLevel:(id)sender {
    NSLog(@"GameScene level complete!");
    [self messageDisplay:GameMessageNoMessage];
    
    // display the level complete nodes
    CCLayerColor* levelCompleteLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 0, 0)];
    [levelCompleteLayer runAction:[CCFadeTo actionWithDuration:1.0 opacity:196]];
    [self addChild:levelCompleteLayer z:5];
    CCSprite* levelCompleteMessage = [CCSprite spriteWithFile:@"game_level_complete.png"];
    [levelCompleteMessage runAction:[CCFadeIn actionWithDuration:0.5]];
    levelCompleteMessage.position = ccp(160, 217);
    [levelCompleteLayer addChild:levelCompleteMessage];
    
    
    // figure out the level complete text
    CCLabelTTF* levelCompleteLabel;
    CCLabelTTF* levelCompleteLabel2;
    CCLabelTTF* levelCompleteLabel3;
    NSString* completeText;
    int moves = gameData.movesLeft;
    switch(gameData.difficulty) {
        case GameDifficultyEasy: moves -= 10; break;
        case GameDifficultyMedium: moves -= 6; break;
        case GameDifficultyHard: moves -= 2; break;
    }
    moves *= -1;
    if(moves <= 0) {
        levelCompleteLabel = [CCLabelTTF labelWithString: @"Perfect!" fontName:@"gabriola.ttf" fontSize:35];
        [levelCompleteLabel runAction:[CCFadeIn actionWithDuration:0.5]];
        levelCompleteLabel.position = ccp(160, 160);
        [levelCompleteLayer addChild:levelCompleteLabel];
    
        CCSprite* levelCompletePerfect = [CCSprite spriteWithFile:@"game_level_complete_perfect.png"];
        levelCompletePerfect.position = ccp(160, 204);
        [levelCompletePerfect runAction:[CCFadeIn actionWithDuration:0.5]];
        [levelCompleteLayer addChild:levelCompletePerfect];
        
        // update level to be perfect
        [levels markAsPerfect:gameData.level];
        
        // check for perfectionist achievement
        int perfectLevels = [levels perfectLevels];
        if(perfectLevels >= 10) {
            [self unlockAchievement:AchievementPerfectionist];
        }
        // check for professional perfectionist achievement
        if(perfectLevels >= 30) {
            [self unlockAchievement:AchievementProfessionalPerfectionist];
        }
        // check for mastermind
        if(perfectLevels >= TOTAL_LEVELS) {
            [self unlockAchievement:AchievementMastermind];
        }
    } else {
        levelCompleteLabel = [CCLabelTTF labelWithString: @"Good Job!" fontName:@"gabriola.ttf" fontSize:30];
        [levelCompleteLabel runAction:[CCFadeIn actionWithDuration:0.5]];
        levelCompleteLabel.position = ccp(160, 210);
        [levelCompleteLayer addChild:levelCompleteLabel];
        
        if(moves == 1)
            completeText = @"1 Move Away";
        else
            completeText = [NSString stringWithFormat:@"%i Moves Away", moves];
        levelCompleteLabel2 = [CCLabelTTF labelWithString: completeText fontName:@"gabriola.ttf" fontSize:30];
        [levelCompleteLabel2 runAction:[CCFadeIn actionWithDuration:0.5]];
        levelCompleteLabel2.position = ccp(160, 177);
        [levelCompleteLayer addChild:levelCompleteLabel2];
        
        levelCompleteLabel3 = [CCLabelTTF labelWithString: @"From Perfect" fontName:@"gabriola.ttf" fontSize:30];
        [levelCompleteLabel3 runAction:[CCFadeIn actionWithDuration:0.5]];
        levelCompleteLabel3.position = ccp(160, 144);
        [levelCompleteLayer addChild:levelCompleteLabel3];
    }
    
    [gameData beatLevel];
    
    // delete the saved game - if they continue, then load the next one
    [gameData deleteSavedGame];
    
    // check for "Begin the Hunt" achievement
    BOOL beginTheHunt = TRUE;
    for(int i=0; i<10; i++) {
        Level* l = (Level*)[levels.levels objectAtIndex:i];
        if(l.complete == FALSE) {
            beginTheHunt = FALSE;
            break;
        }
    }
    if(beginTheHunt) [self unlockAchievement:AchievementBeginTheHunt];
    
    // check for "Enter the Darkness" achievement
    BOOL enterTheDarkness = TRUE;
    for(int i=0; i<30; i++) {
        Level* l = (Level*)[levels.levels objectAtIndex:i];
        if(l.complete == FALSE) {
            enterTheDarkness = FALSE;
            break;
        }
    }
    if(enterTheDarkness) [self unlockAchievement:AchievementEnterTheDarkness];
    
    // check for "Enjoy the Sun" achievement
    BOOL enjoyTheSun = TRUE;
    for(int i=30; i<60; i++) {
        Level* l = (Level*)[levels.levels objectAtIndex:i];
        if(l.complete == FALSE) {
            enjoyTheSun = FALSE;
            break;
        }
    }
    if(enjoyTheSun) [self unlockAchievement:AchievementEnjoyTheSun];
    
    // check for "Arrrgh!" achievement
    BOOL arrrgh = TRUE;
    for(int i=60; i<90; i++) {
        Level* l = (Level*)[levels.levels objectAtIndex:i];
        if(l.complete == FALSE) {
            arrrgh = FALSE;
            break;
        }
    }
    if(arrrgh) [self unlockAchievement:AchievementArrrgh];
    
    // check for difficulty achievements
    BOOL treasureHunter = TRUE;
    BOOL anAdventurerIsYou = TRUE;
    BOOL intrepidExplorer = TRUE;
    // check for "Treasure Hunter" achievement
    for(int i=0; i<120; i++) {
        Level* l = (Level*)[levels.levels objectAtIndex:i];
        if(l.complete_easy == FALSE) treasureHunter = FALSE;
        if(l.complete_medium == FALSE) anAdventurerIsYou = FALSE;
        if(l.complete_hard == FALSE) intrepidExplorer = FALSE;
        if(!treasureHunter && !anAdventurerIsYou && !intrepidExplorer) break;
    }
    if(treasureHunter)    [self unlockAchievement:AchievementTreasureHunter];
    if(anAdventurerIsYou) [self unlockAchievement:AchievementAnAdventurerIsYou];
    if(intrepidExplorer)  [self unlockAchievement:AchievementIntrepidExplorer];
}

- (void) messageDisplay:(int)messageToDisplay {
	message = messageToDisplay;
	CCSprite* spriteMessage = (CCSprite*)[self getChildByTag:GameTagMessage];
	if(spriteMessage != nil) {
		[self removeChildByTag:GameTagMessage cleanup:YES];
		spriteMessage = nil;
	}
	
	// which message?
	switch(messageToDisplay) {
		case GameMessageNoMessage:
			NSLog(@"GameScene getting rid of message");
			break;
		case GameMessageSwipeScreen:
			NSLog(@"GameScene display message intro");
			spriteMessage = [CCSprite spriteWithFile:@"game_message_intro.png"];
			spriteMessage.position = ccp(160, 242);
			break;
		case GameMessageNoMovesMenu:
			NSLog(@"GameScene display message no moves menu");
			spriteMessage = [CCSprite spriteWithFile:@"game_message_no_moves_menu.png"];
			spriteMessage.position = ccp(160, 293.5);
			break;
		case GameMessageNoMovesShake:
			NSLog(@"GameScene display message no moves shake");
			spriteMessage = [CCSprite spriteWithFile:@"game_message_no_moves_shake.png"];
			spriteMessage.position = ccp(160, 293.5);
			break;
	}
	if(spriteMessage != nil) {
		spriteMessage.opacity = 0;
		[spriteMessage runAction:[CCSequence actions:
								  [CCFadeIn actionWithDuration:1.0],
								  [CCDelayTime actionWithDuration:3.0],
								  [CCFadeOut actionWithDuration:1.0],
								  [CCCallFunc actionWithTarget:self selector:@selector(onRemoveMessage:)],
								  nil]];
		[self addChild:spriteMessage z:5 tag:GameTagMessage];
	}
}

- (void) onRemoveMessage:(id)sender {
	[self removeChildByTag:GameTagMessage cleanup:YES];
}

- (void) unlockAchievement:(int)achievementId {
	// unlock it
	if([achievements unlock:achievementId]) {
        [sound playUnlockAchievement];
        
        // create achievement layer
        CCLayer* achievementLayer = [CCLayer node];
        [self addChild:achievementLayer z:5 tag:GameTagAchievementLayer];
        
        // add background and labels to it
        CCSprite* achievementBackground = [CCSprite spriteWithFile:@"game_achievement_background.png"];
        achievementBackground.position = ccp(160, 108);
        [achievementLayer addChild:achievementBackground z:0];
        CCLabelTTF* achievementTitle = [CCLabelTTF labelWithString:[achievements getName:achievementId] fontName:@"gabriola.ttf" fontSize:26];
        achievementTitle.color = ccc3(255, 255, 255);
        achievementTitle.position = ccp(211, 61);
        [achievementLayer addChild:achievementTitle z:1];
        CCLabelTTF* achievementDesc = [CCLabelTTF labelWithString:[achievements getDescription:achievementId] fontName:@"gabriola.ttf" fontSize:20];
        achievementDesc.color = ccc3(196, 207, 226);
        achievementDesc.position = ccp(211, 37);
        [achievementLayer addChild:achievementDesc z:1];
        
        // animate it
        achievementLayer.position = ccp(0, -220);
        [achievementLayer runAction:[CCSequence actions:
                                     [CCMoveTo actionWithDuration:1.0 position:ccp(0, 0)],
                                     [CCDelayTime actionWithDuration:2.0],
                                     [CCMoveTo actionWithDuration:1.0 position:ccp(0, -220)],
                                     [CCCallFunc actionWithTarget:self selector:@selector(onRemoveAchievement:)],
                                     nil]];
    }
}

- (void) onRemoveAchievement:(id)sender {
	[self removeChildByTag:GameTagAchievementLayer cleanup:YES];
}

- (void) onMenu:(id)sender {
    if(won) return;
	NSLog(@"GameScene onMenu");
	[sound playClick];
    [self unsetCurrentGame];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3 scene:[GameMenuScene scene]]];
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
    
    // remove swipe message, if it's there
    if(message == GameMessageSwipeScreen) [self messageDisplay:GameMessageNoMessage];
	
	// if the game has been won, ignore other touches and load next level
	if(won) {
		// if this is the last level, return to main menu
		if(gameData.level == TOTAL_LEVELS) {
			[sound playClick];
			[sound startMusicMenu];
            [self unsetCurrentGame];
			[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[MenuScene scene]]];
		} else {
			// play click, change music
			[sound playClick];
			[sound startMusicGameplay];
			
			// load the next level
			int stage = [gameData stageForLevel:gameData.level];
			int nextLevelStage = [gameData stageForLevel:gameData.level+1];
			if(stage != nextLevelStage) {
				// if the next stage is locked, go to select level scene instead
				if([gameData stageLocked:nextLevelStage]) {
                    [self unsetCurrentGame];
					[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[SelectLevelScene scene]]];
					return;
				} else {
                    // otherwise go to the map scene
                    [self unsetCurrentGame];
                    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.3 scene:[MapScene sceneWithStage:nextLevelStage]]];
                }
			} else {
                gameData.level++;
                [gameData loadLevel];
                [self restartLevel];
            }
		}
		return;
	}
	
	// handle other touches
	int direction = [Helpers swipeDirectionStart:touchStart end:touchEnd];
	switch(direction) {
		case GameDirUp: NSLog(@"GameScene swiped up"); break;
		case GameDirDown: NSLog(@"GameScene swiped down"); break;
		case GameDirLeft: NSLog(@"GameScene swiped left"); break;
		case GameDirRight: NSLog(@"GameScene swiped right"); break;
	}
	if(direction == GameDirLeft || direction == GameDirRight || direction == GameDirDown) {
		[self moveKeys:direction];
	}
}

- (void) shake {
    if(options.shake && firstMove) {
        NSLog(@"GameScene shake detected, restarting level");
        [sound playRestartLevel];
        [gameData loadLevel];
        [self restartLevel];
    }
}


@end
