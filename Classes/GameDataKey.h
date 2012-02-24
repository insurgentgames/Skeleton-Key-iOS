//
//  GameDataKey.h
//  Skeleton Key
//
//  Created by micah on 12/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h> 


@interface GameDataKey : NSObject {
	int x;
	int y;
	bool used;
	int ident;
}

@property (readwrite) int x;
@property (readwrite) int y;
@property (readwrite) bool used;
@property (readwrite) int ident;

@end
