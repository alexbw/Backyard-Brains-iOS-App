// Creates a tab view programmatically, and connects up all the delegates.

#import "TabDetailViewController.h"


@implementation TabDetailViewController


@synthesize tabBarController;

@synthesize drawingDataManager, delegate;
@synthesize fileController;
@synthesize navigationController;

#pragma mark - View lifecycle

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
}

#pragma mark - Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {

    [[self.tabBarController.viewControllers objectAtIndex:0] showFileButton];
    [[self.tabBarController.viewControllers objectAtIndex:1] showFileButton];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {

    [[self.tabBarController.viewControllers objectAtIndex:0]  hideFileButton];
    [[self.tabBarController.viewControllers objectAtIndex:1]  hideFileButton];

}



#pragma mark - Memory management

- (void)dealloc {
    [tabBarController release];
    [super dealloc];
}	

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}


@end
