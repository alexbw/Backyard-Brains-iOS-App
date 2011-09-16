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

#import "BBFileViewControllerTBV.h"
#import "FirstTimeSpikersViewController.h"
#import "DrawingDataManager.h"
#import "TabDetailViewController.h"


@interface Backyard_BrainsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UISplitViewControllerDelegate, DrawingViewControllerDelegate> {
    UIWindow *window;
    
    BBTabViewController *tabBarController;
    
    UISplitViewController *splitViewController;
    BBFileViewControllerTBV *rootVC;
    TabDetailViewController *detailVC;
    
    DrawingDataManager *drawingDataManager;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BBTabViewController *tabBarController;

@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet BBFileViewControllerTBV *rootVC;
@property (nonatomic, retain) IBOutlet TabDetailViewController *detailVC;

@property (nonatomic, retain) IBOutlet DrawingDataManager *drawingDataManager;

@end
