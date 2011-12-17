

#import <UIKit/UIKit.h>
#import "BBFileActionViewControllerTBV.h"

@class DrawingDataManager;

@interface TabDetailViewController : UIViewController <SubstitutableDetailViewController, DrawingViewControllerDelegate, UISplitViewControllerDelegate> {}

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) DrawingDataManager *drawingDataManager;
@property (nonatomic, retain) IBOutlet BBFileViewControllerTBV *fileController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, assign) IBOutlet id <DrawingViewControllerDelegate> delegate;


@end
