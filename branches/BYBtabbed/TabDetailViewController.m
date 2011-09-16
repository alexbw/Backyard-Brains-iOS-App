// Creates a tab view programmatically, and connects up all the delegates.

#import "TabDetailViewController.h"


@implementation TabDetailViewController

@synthesize toolbar;
@synthesize tabBarController;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:tabBarController.view];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.toolbar = nil;
    self.tabBarController = nil;
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    //for (int i = 0; i < [self.tabBarController.viewControllers count]; ++i)
        [[self.tabBarController.viewControllers objectAtIndex:0] showRootPopoverButtonItem:barButtonItem];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    //for (int i = 0; i < [self.tabBarController.viewControllers count]; ++i)
        [[self.tabBarController.viewControllers objectAtIndex:0]  invalidateRootPopoverButtonItem:barButtonItem];

}



#pragma mark - Memory management

- (void)dealloc {
    [toolbar release];
    [super dealloc];
}	



@end
