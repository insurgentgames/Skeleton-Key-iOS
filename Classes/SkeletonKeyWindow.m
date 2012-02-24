//
//  SkeletonKeyWindow.m
//  Skeleton Key
//
//  Created by micah on 5/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SkeletonKeyWindow.h"
#import "SkeletonKeyAppDelegate.h"

@implementation SkeletonKeyWindow

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        GameScene* currentGame = ((SkeletonKeyAppDelegate*)([UIApplication sharedApplication].delegate)).currentGame;
        if(currentGame) {
            NSLog(@"SkeletonKeyWindow shake detected, telling the game about it");
            [currentGame shake];
        } else {
            NSLog(@"SkeletonKeyWindow shake detected, but there's no game to tell it to :(");
        }
    }
}

@end
