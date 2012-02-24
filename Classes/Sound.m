//
//  Sound.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Sound.h"
#import "SkeletonKeyAppDelegate.h"

@implementation Sound

- (id) init {
	if((self = [super init])) {
		NSLog(@"Sound init");
		options = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).options;
		gameplayPlaying = NO;
	}
	return self;
}

- (void) dealloc {
	NSLog(@"Sound dealloc");
	[super dealloc];
}

- (void) play:(NSString*)sound {
	if(!options.sound) return;
	[[SimpleAudioEngine sharedEngine] playEffect:sound];
}

- (void) playKeyMove {
	[self play:@"key_move.wav"];
}

- (void) playOpenChest {
	[self play:@"open_chest.wav"];
}

- (void) playRestartLevel {
	[self play:@"restart_level.wav"];
}

- (void) playDoor {
	[self play:@"door.wav"];
}

- (void) playClick {
	[self play:@"click.wav"];
}

- (void) playMapLocked {
	[self play:@"map_locked.wav"];
}

- (void) playUnlockAchievement {
	[self play:@"unlock_achievement.wav"];
}

- (void) startMusicMenu {
	if(!options.music) return;
	gameplayPlaying = NO;
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"menu.mp3"];
}

- (void) startMusicGameplay {
	if(!options.music) return;
	
	if(gameplayPlaying) {
		if(time(0) - gameplayStart <= 60000) return;
	}
	
	gameplayStart = time(0);
	[self stopMusic];
    gameplayPlaying = YES;
	
	int randomSong = gameplayMusicNum;
	while(randomSong == gameplayMusicNum)
		randomSong = random()%3;
	
	NSString* song;
	switch(randomSong) {
		default:
		case 0: song = @"gameplay1.mp3"; break;
		case 1: song = @"gameplay2.mp3"; break;
		case 2: song = @"gameplay3.mp3"; break;
	}
	
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic:song];
}

- (void) stopMusic {
	gameplayPlaying = NO;
	[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
