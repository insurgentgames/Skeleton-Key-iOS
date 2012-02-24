//
//  Options.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 


@interface Options : NSObject {
	NSArray* options;
	NSUInteger sound;
	NSUInteger music;
	NSUInteger shake;
	NSUInteger difficulty;
	NSUInteger loadCount;
}

@property (nonatomic,retain) NSArray* options;
@property (readwrite) NSUInteger sound;
@property (readwrite) NSUInteger music;
@property (readwrite) NSUInteger shake;
@property (readwrite) NSUInteger difficulty;
@property (readwrite) NSUInteger loadCount;

- (NSString*)getFilePath;
- (void) load;
- (void) save;

@end
