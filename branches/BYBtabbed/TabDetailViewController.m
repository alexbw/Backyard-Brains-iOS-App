// Creates a tab view programmatically, and connects up all the delegates.

#import "TabDetailViewController.h"


@implementation TabDetailViewController

@synthesize toolbar;
@synthesize tabBarController;

@synthesize drawingDataManager, delegate;
@synthesize fileController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.tabBarController.view];
    
    self.drawingDataManager = self.delegate.drawingDataManager;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.toolbar = nil;
    self.tabBarController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController viewWillAppear:animated];
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    [[self.tabBarController.viewControllers objectAtIndex:0] showRootPopoverButtonItem:barButtonItem];
    [[self.tabBarController.viewControllers objectAtIndex:1] showRootPopoverButtonItem:barButtonItem];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    [[self.tabBarController.viewControllers objectAtIndex:0]  invalidateRootPopoverButtonItem:barButtonItem];
    [[self.tabBarController.viewControllers objectAtIndex:1]  invalidateRootPopoverButtonItem:barButtonItem];

}



#pragma mark - Memory management

- (void)dealloc {
    [toolbar release];
    [tabBarController release];
    [super dealloc];
}	



@end
