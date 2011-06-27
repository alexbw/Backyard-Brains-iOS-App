//
//  Backyard_BrainsAppDelegate.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright University of Michigan 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioSignalManager.h"
#import "BBTabViewController.h"

#import "BBFileViewController.h"
#import "FirstTimeSpikersViewController.h"

@interface Backyard_BrainsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    BBTabViewController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BBTabViewController *tabBarController;


@end
