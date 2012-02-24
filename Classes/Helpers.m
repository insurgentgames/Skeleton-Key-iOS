//
//  Helpers.m
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Helpers.h"


@implementation Helpers

+ (NSUInteger) swipeDirectionStart:(CGPoint)start end:(CGPoint)end {
	const int swipeDist = 15;
	
	float dx = end.x - start.x;
	float dy = end.y - start.y;
	float dist = sqrt(dx*dx + dy*dy);
	if(dist > swipeDist && dx != dy) {
		// left or right
		if(abs(dx) > abs(dy)) {
			if(dx > 0) {
				return GameDirRight;
			} else {
				return GameDirLeft;
			}
		}
		// up or down
		else {
			if(dy > 0) {
				return GameDirUp;
			} else {
				return GameDirDown;
			}
		}
	}
	return GameDirNone;
}

+ (NSMutableArray*) explodeDelimiter:(NSString*)delimiter string:(NSString*)str {
	NSMutableArray* arr = [NSMutableArray array];
	
	int strleng = [str length];
	int delleng = [delimiter length];
	if(delleng == 0)
		return arr; // no change
	
	int i = 0;
	int k = 0;
	while(i < strleng) {
		int j=0;
		while(i + j < strleng && j < delleng && [str characterAtIndex:i+j] == [delimiter characterAtIndex:j])
			j++;
		if(j == delleng) { // found delimiter
			[arr addObject:[[str substringFromIndex:k] substringToIndex:i-k]];
			i += delleng;
			k = i;
		} else {
			i++;
		}
	}
	[arr addObject:[[str substringFromIndex:k] substringToIndex:i-k]];
	return arr;
}

@end
