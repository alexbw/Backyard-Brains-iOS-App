//
//  LarvaJoltAppDelegate.h
//  LarvaJolt
//
//  Created by Zachary King on 1/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LarvaJoltViewController;

@interface LarvaJoltAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LarvaJoltViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LarvaJoltViewController *viewController;

@end

