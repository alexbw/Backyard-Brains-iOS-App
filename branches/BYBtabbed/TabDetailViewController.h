

#import <UIKit/UIKit.h>
#import "ContinuousWaveViewController_iPad.h"
#import "TriggerViewController.h"

@interface TabDetailViewController : UIViewController <SubstitutableDetailViewController, DrawingViewControllerDelegate> {

    UIToolbar *toolbar;
    UITabBarController *tabBarController;
    
    DrawingDataManager *drawingDataManager;
    
    id <DrawingViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) DrawingDataManager *drawingDataManager;

@property (nonatomic, assign) IBOutlet id <DrawingViewControllerDelegate> delegate;

@end
