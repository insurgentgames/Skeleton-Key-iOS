//
//  Levels.m
//  Skeleton Key
//
//  Created by micah on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Levels.h"


@implementation Levels

@synthesize levels;

- (id) init {
	if((self=[super init])) {
		NSLog(@"Levels init");
		[self load];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"Levels dealloc");
	for(int i=0; i<LEVEL_COUNT; i++) {
		[[levels objectAtIndex:i] dealloc];
	}
	[levels dealloc];
	[super dealloc];
}

- (NSString*)getFilePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"Levels.plist"];
}

- (void) load {
	bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self getFilePath]];
	if(fileExists) {
		NSLog(@"Levels load");
		NSArray* levelsStrings = [NSArray arrayWithContentsOfFile:[self getFilePath]];
		levels = [[NSMutableArray alloc] initWithCapacity:LEVEL_COUNT];
		for(int i=0; i<LEVEL_COUNT; i++) {
			[levels addObject:[Level levelFromString:[levelsStrings objectAtIndex:i]]];
		}
	} else {
		NSLog(@"Levels create new file");
		[self reset];
	}
}

- (void) save {
	NSLog(@"Levels save");
	NSMutableArray* levelsStrings = [NSMutableArray arrayWithCapacity:LEVEL_COUNT];
	for(int i=0; i<LEVEL_COUNT; i++) {
		Level* l = (Level*)[levels objectAtIndex:i];
		NSString* str = [l toString];
		//NSLog(@"%i %@", i, str);
		[levelsStrings addObject:str];
	}
	bool written = [levelsStrings writeToFile:[self getFilePath] atomically:YES];
	if(written) NSLog(@"Levels wrote file");
	else NSLog(@"Levels file not written");
}

- (void) reset {
	NSLog(@"Levels reset level data");
	NSString* path = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"txt"];
	NSString* levelsStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSMutableArray* levelsStrArr = [Helpers explodeDelimiter:@"\n" string:levelsStr];
	levels = [[NSMutableArray alloc] initWithCapacity:LEVEL_COUNT];
	for(NSUInteger i=0; i<LEVEL_COUNT; i++) {
		[levels addObject:[Level levelFromString:[levelsStrArr objectAtIndex:i]]];
	}
	[self save];
}

- (void) markAsPerfect:(int)level {
	Level* l = (Level*)[levels objectAtIndex:level-1];
	l.perfect = TRUE;
	[self save];
}

- (int) perfectLevels {
	int perfectCount = 0;
	for(NSUInteger i=0; i<LEVEL_COUNT; i++) {
		Level* l = (Level*)[levels objectAtIndex:i];
		if(l.perfect) perfectCount++;
	}
	return perfectCount;
}

- (BOOL) isComplete:(int)level {
    return ((Level*)[levels objectAtIndex:level-1]).complete;
}

@end
