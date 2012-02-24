//
//  NagScene.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Sound.h"

@interface NagScene : CCLayer {

}

+ (id) scene;

- (void) onYes:(id)sender;
- (void) onNo:(id)sender;

@end
