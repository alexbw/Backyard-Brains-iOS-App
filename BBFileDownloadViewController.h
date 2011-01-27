//
//  BBFileDownloadViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/20/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPServer.h"
#import "MyHTTPConnection.h"
#import "localhostAddresses.h"
@class   HTTPServer;




@protocol BBFileDownloadViewControllerDelegate

@property (nonatomic, retain) NSString *filename;

@end



@interface BBFileDownloadViewController : UIViewController {
    UIWindow *window;
	HTTPServer *httpServer;
	NSDictionary *addresses;	
	IBOutlet UILabel *ipLabel;
	IBOutlet UILabel *fileNameLabel;
	id <BBFileDownloadViewControllerDelegate> delegate;
}

@property (nonatomic, retain) id <BBFileDownloadViewControllerDelegate> delegate;

- (void)setupServer;
- (void)startServer;
- (void)stopServer;
- (void)displayInfoUpdate:(NSNotification *) notification;

@end
