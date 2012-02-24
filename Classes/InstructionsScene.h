//
//  InstructionsScene.h
//  Skeleton Key
//
//  Created by micah on 12/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Helpers.h"
#import "Sound.h"

@interface InstructionsScene : CCLayer {
	NSInteger pageNumber;
	CCMenuItemImage* back;
	CCMenuItemImage* next;
	CCLayer* pageLayer;
	
	CGPoint touchStart;
	
	Sound* sound;
}

+ (id) scene;

- (void) onBack:(id)sender;
- (void) onNext:(id)sender;
- (void) onMenu:(id)sender;
- (void) moveBack;
- (void) moveNext;
- (void) scroll;

@end
