//
//  Level.m
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Level.h"


@implementation Level

@synthesize number;
@synthesize data;
@synthesize min_moves;
@synthesize complete;
@synthesize complete_easy;
@synthesize complete_medium;
@synthesize complete_hard;
@synthesize perfect;

+ (id) levelFromString:(NSString*)str {
	Level* level = [[[Level alloc] init] autorelease];
	[level fromString:str];
	return level;
}

- (void) fromString:(NSString*)str {
	NSMutableArray* values = [Helpers explodeDelimiter:@";" string:str];
	number			= [[values objectAtIndex:0] intValue];
	data			= [[NSString alloc] initWithString:[values objectAtIndex:1]];
	min_moves		= [[values objectAtIndex:2] intValue];
	complete		= [[values objectAtIndex:3] intValue];
	complete_easy	= [[values objectAtIndex:4] intValue];
	complete_medium	= [[values objectAtIndex:5] intValue];
	complete_hard	= [[values objectAtIndex:6] intValue];
	perfect			= [[values objectAtIndex:7] intValue];
}

- (NSString*) toString {
	return [NSString 
			stringWithFormat:@"%i;%@;%i;%i;%i;%i;%i;%i", 
			number, data, min_moves, complete, complete_easy, complete_medium, complete_hard, perfect];
}

- (void) dealloc {
	[data dealloc];
	[super dealloc];
}

@end
