//
//  Options.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Options.h"


@implementation Options

@synthesize options;
@synthesize sound;
@synthesize music;
@synthesize shake;
@synthesize difficulty;
@synthesize loadCount;

- (id) init {
	if((self = [super init])) {
		NSLog(@"Options init");
		[self load];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"Options dealloc");
	[super dealloc];
}

- (NSString*)getFilePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"Options.plist"];
}

- (void) load {
	if([[NSFileManager defaultManager] fileExistsAtPath:[self getFilePath]]) {
		NSLog(@"Options load");
		options = [NSArray arrayWithContentsOfFile:[self getFilePath]];
		sound		= [[options objectAtIndex:0] intValue];
		music		= [[options objectAtIndex:1] intValue];
		shake		= [[options objectAtIndex:2] intValue];
		difficulty	= [[options objectAtIndex:3] intValue];
		loadCount	= [[options objectAtIndex:4] intValue];
	} else {
		NSLog(@"Options create new options file");
		sound		= 1;
		music		= 1;
		shake		= 1;
		difficulty	= 1;
		loadCount	= 0;
		[self save];
	}
	loadCount++;
	[self save];
}

- (void) save {
	NSLog(@"Options save");
	options = [NSArray arrayWithObjects:
			 [NSNumber numberWithInt:sound], 
			 [NSNumber numberWithInt:music],
			 [NSNumber numberWithInt:shake],
			 [NSNumber numberWithInt:difficulty],
			 [NSNumber numberWithInt:loadCount],
			 nil];
	[options writeToFile:[self getFilePath] atomically:YES];
}

@end
