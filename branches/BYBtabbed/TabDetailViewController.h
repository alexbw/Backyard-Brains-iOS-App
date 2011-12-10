

#import <UIKit/UIKit.h>
#import "BBFileActionViewControllerTBV.h"

@class DrawingDataManager;

@interface TabDetailViewController : UIViewController <SubstitutableDetailViewController, DrawingViewControllerDelegate> {

    UIToolbar *toolbar;
    UITabBarController *tabBarController;
    
    DrawingDataManager *drawingDataManager;
    BBFileViewControllerTBV *fileController;
    
    id <DrawingViewControllerDelegate> delegate;
    
    
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@property (nonatomic, retain) DrawingDataManager *drawingDataManager;
@property (nonatomic, retain) IBOutlet BBFileViewControllerTBV *fileController;

@property (nonatomic, assign) IBOutlet id <DrawingViewControllerDelegate> delegate;


@end
