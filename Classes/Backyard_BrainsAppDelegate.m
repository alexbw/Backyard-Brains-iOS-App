//
//  Backyard_BrainsAppDelegate.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright University of Michigan 2010. All rights reserved.
//

#import "Backyard_BrainsAppDelegate.h"

@class GainViewController;

@implementation Backyard_BrainsAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
//	self.gain = [[[NSUserDefaults standardUserDefaults] stringForKey:@"gain"] floatValue];
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"Root" ofType:@"plist"];
//	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//	[[NSUserDefaults standardUserDefaults] registerDefaults:dict];
	
	NSNumber *gain;
	NSNumber *samplerate;
	gain = [[NSUserDefaults standardUserDefaults] objectForKey:@"gain"];
	samplerate = [[NSUserDefaults standardUserDefaults] objectForKey:@"samplerate"];
	if (!gain) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:1.0f] forKey:@"gain"];
	}
	if (!samplerate) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:22050.f] forKey:@"samplerate"];
	}
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSLog(@"gain = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"gain"]);
	NSLog(@"sample rate = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"samplerate"]);
	
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = YES;

	
    // Add the tab bar controller's current view as a subview of the window
	[window addSubview:tabBarController.view];
	
	// make the window visible
	[window makeKeyAndVisible];

}


// Optional UITabBarControllerDelegate method
- (void)tabBarController:(BBTabViewController *)tabBarController didSelectViewController:(UIViewController *)viewController {	
	// Should fire on tab changes
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait) {
		return NO;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		return NO;
	}
	
	return NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
//	[self deleteAllDummyFiles];
	
	UIApplication *thisApp = [UIApplication sharedApplication];
	thisApp.idleTimerDisabled = NO;
	
}


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

