// Creates a tab view programmatically, and connects up all the delegates.

#import "TabDetailViewController.h"


@implementation TabDetailViewController


@synthesize tabBarController;

@synthesize drawingDataManager, delegate;
@synthesize fileController;
@synthesize navigationController;

#pragma mark - View lifecycle

- (void)dealloc {
    [tabBarController release];
    [drawingDataManager release];
    [fileController release];
    [navigationController release];
    [super dealloc];
}	


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tabBarController.view];
    
    self.drawingDataManager = self.delegate.drawingDataManager;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
    self.tabBarController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController viewWillAppear:animated];
    
   // [[self.tabBarController.viewControllers objectAtIndex:0] setDelegate:self.delegate];
   // [[self.tabBarController.viewControllers objectAtIndex:1] showFileButton];
}





@end
