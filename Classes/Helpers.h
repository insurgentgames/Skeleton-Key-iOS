//
//  Helpers.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 

// directions
typedef enum {
	GameDirNone = 0,
	GameDirUp = 1,
	GameDirDown = 2,
	GameDirLeft = 3,
	GameDirRight = 4
} GameDirs;

@interface Helpers : NSObject {
}

+ (NSUInteger) swipeDirectionStart:(CGPoint)start end:(CGPoint)end;
+ (NSMutableArray*) explodeDelimiter:(NSString*)delimiter string:(NSString*)str;

@end
