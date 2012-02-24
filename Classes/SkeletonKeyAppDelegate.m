//
//  SkeletonKeyAppDelegate.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "cocos2d.h"

#import "SkeletonKeyAppDelegate.h"
#import "GameConfig.h"
#import "NagScene.h"
#import "MenuScene.h"
#import "RootViewController.h"

@implementation SkeletonKeyAppDelegate

@synthesize window;
@synthesize sound;
@synthesize options;
@synthesize achievements;
@synthesize levels;
@synthesize gameData;
@synthesize currentGame;

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	window = [[SkeletonKeyWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	if(![CCDirector setDirectorType:kCCDirectorTypeDisplayLink])
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	CCDirector *director = [CCDirector sharedDirector];

	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds] pixelFormat:kEAGLColorFormatRGB565 depthFormat:0];
	[director setOpenGLView:glView];
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
	
	[viewController setView:glView];
	[window addSubview: viewController.view];
	[window makeKeyAndVisible];
	
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// set up singletons
	options = [[Options alloc] init];
	achievements = [[Achievements alloc] init];
	sound = [[Sound alloc] init];
	[sound startMusicMenu];
	levels = [[Levels alloc] init];
	gameData = [[GameData alloc] init];
    currentGame = nil;
	
	// start the game
	if(options.loadCount == 7) {
		[[CCDirector sharedDirector] runWithScene:[NagScene scene]];
	} else {
		[[CCDirector sharedDirector] runWithScene:[MenuScene scene]];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	[[director openGLView] removeFromSuperview];
	[viewController release];
	[window release];
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[sound dealloc];
	[options dealloc];
	[achievements dealloc];
	[levels dealloc];
	[gameData dealloc];
	[super dealloc];
}

@end
