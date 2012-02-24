//
//  Level.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "Helpers.h"

@interface Level : NSObject {
	int number;
	NSString* data;
	int min_moves;
	bool complete;
	bool complete_easy;
	bool complete_medium;
	bool complete_hard;
	bool perfect;
}

@property (readwrite) int number;
@property (nonatomic,retain) NSString* data;
@property (readwrite) int min_moves;
@property (readwrite) bool complete;
@property (readwrite) bool complete_easy;
@property (readwrite) bool complete_medium;
@property (readwrite) bool complete_hard;
@property (readwrite) bool perfect;

+ (id) levelFromString:(NSString*)str;

- (void) fromString:(NSString*)str;
- (NSString*) toString;

@end
