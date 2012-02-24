//
//  Levels.h
//  Skeleton Key
//
//  Created by micah on 1/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "Level.h"
#import "Helpers.h"

#define LEVEL_COUNT 120

@interface Levels : NSObject {
	NSMutableArray* levels;
}

@property (nonatomic,retain) NSMutableArray* levels;

- (NSString*)getFilePath;
- (void) load;
- (void) save;
- (void) reset;
- (void) markAsPerfect:(int)level;
- (int) perfectLevels;
- (BOOL) isComplete:(int)level;

@end
