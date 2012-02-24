//
//  Achievements.m
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Achievements.h"


@implementation Achievements

@synthesize achievements;
@synthesize doorsOpened;
@synthesize achieved;
@synthesize numAchievements;

- (id) init {
	if((self = [super init])) {
		NSLog(@"Achievements init");
		numAchievements = 13;
		achieved = [[NSMutableArray alloc] initWithCapacity:numAchievements];
		[self load];
	}
	return self;
}

- (void) dealloc {
	NSLog(@"Achievements dealloc");
	[achieved dealloc];
	[super dealloc];
}

- (NSString*)getFilePath {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"Achievements.plist"];
}

- (void) load {
	if([[NSFileManager defaultManager] fileExistsAtPath:[self getFilePath]]) {
		NSLog(@"Achievements load");
		achievements = [NSArray arrayWithContentsOfFile:[self getFilePath]];
		doorsOpened	= [[achievements objectAtIndex:0] intValue];
		for(NSUInteger i=1; i<=numAchievements; i++)
			[achieved addObject:[achievements objectAtIndex:i]];
	} else {
		NSLog(@"Achievements create new file");
		doorsOpened	= 0;
		for(NSUInteger i=1; i<=numAchievements; i++)
			[achieved addObject:[NSNumber numberWithInt:0]];
		[self save];
	}
}

- (void) save {
	NSLog(@"Achievements save");
	achievements = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:doorsOpened]];
	for(NSUInteger i=0; i<numAchievements; i++)
		[achievements addObject:[achieved objectAtIndex:i]];
	[achievements writeToFile:[self getFilePath] atomically:YES];
}

- (void) reset {
	[achieved dealloc];
	achieved = [[NSMutableArray alloc] initWithCapacity:numAchievements];
	for(NSUInteger i=1; i<=numAchievements; i++)
		[achieved addObject:[NSNumber numberWithInt:0]];
	[self save];
}

- (bool) unlock:(int)achievementId {
    if([(NSNumber*)[achieved objectAtIndex:achievementId] intValue] == 1) return false;
	[achieved replaceObjectAtIndex:achievementId withObject:[NSNumber numberWithInt:1]];
	[self save];
    return true;
}

- (NSString*) getName:(int)i {
	switch(i) {
		case 0: return ACHIEVEMENT0_NAME;
		case 1: return ACHIEVEMENT1_NAME;
		case 2: return ACHIEVEMENT2_NAME;
		case 3: return ACHIEVEMENT3_NAME;
		case 4: return ACHIEVEMENT4_NAME;
		case 5: return ACHIEVEMENT5_NAME;
		case 6: return ACHIEVEMENT6_NAME;
		case 7: return ACHIEVEMENT7_NAME;
		case 8: return ACHIEVEMENT8_NAME;
		case 9: return ACHIEVEMENT9_NAME;
		case 10: return ACHIEVEMENT10_NAME;
		case 11: return ACHIEVEMENT11_NAME;
		case 12: return ACHIEVEMENT12_NAME;
	}
	return @"";
}

- (NSString*) getDescription:(int)i {
	switch(i) {
		case 0: return ACHIEVEMENT0_DESC;
		case 1: return ACHIEVEMENT1_DESC;
		case 2: return ACHIEVEMENT2_DESC;
		case 3: return ACHIEVEMENT3_DESC;
		case 4: return ACHIEVEMENT4_DESC;
		case 5: return ACHIEVEMENT5_DESC;
		case 6: return ACHIEVEMENT6_DESC;
		case 7: return ACHIEVEMENT7_DESC;
		case 8: return ACHIEVEMENT8_DESC;
		case 9: return ACHIEVEMENT9_DESC;
		case 10: return ACHIEVEMENT10_DESC;
		case 11: return ACHIEVEMENT11_DESC;
		case 12: return ACHIEVEMENT12_DESC;
	}
	return @"";
}

@end
