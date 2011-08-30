//
//  Backyard_BrainsAppDelegate.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/6/10.
//  Copyright University of Michigan 2010. All rights reserved.
//

#import "Backyard_BrainsAppDelegate.h"
#import "DropboxSDK.h"

@class GainViewController;

@implementation Backyard_BrainsAppDelegate

@synthesize window;
@synthesize tabBarController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
        
    #define kGain 1.0f
    #define kSamplerate 22050.f
    #define kLedcontrolfreq 10000.f
    
	//Register defaults. Necessary for proper initializaiton of preferences.
    NSDictionary *def = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"gain", [NSNumber numberWithFloat:kGain],
                         @"samplerate", [NSNumber numberWithFloat:kSamplerate],
                         @"ledcontrolfreq", [NSNumber numberWithFloat:kLedcontrolfreq],
                         nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:def];
    
	//Check current values
    NSNumber *gain = [[NSUserDefaults standardUserDefaults] objectForKey:@"gain"];
	NSNumber *samplerate = [[NSUserDefaults standardUserDefaults] objectForKey:@"samplerate"];
    NSNumber *ledcontrolfreq = [[NSUserDefaults standardUserDefaults] objectForKey:@"ledcontrolfreq"];
    if (!gain) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kGain] forKey:@"gain"];
	}
	if (!samplerate) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kSamplerate] forKey:@"samplerate"];
	}
    if (!ledcontrolfreq) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:kLedcontrolfreq] forKey:@"ledcontrolfreq"];
    }
    
    //Save changes
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSLog(@"gain = %@", gain);
	NSLog(@"sample rate = %@", samplerate);
    NSLog(@"led control frequency = %@", ledcontrolfreq);
    
    //Dropbox code:
    DBSession* dbSession = 
    [[[DBSession alloc]
      initWithConsumerKey:@"gko0ired85ogh0e"
      consumerSecret:@"vmxyfeju241zqpk"]
     autorelease];
    [DBSession setSharedSession:dbSession];
    
		
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

