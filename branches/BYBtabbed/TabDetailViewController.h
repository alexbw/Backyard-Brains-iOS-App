

#import <UIKit/UIKit.h>
#import "ContinuousWaveViewController_iPad.h"
#import "TriggerViewController.h"

@interface TabDetailViewController : UIViewController <SubstitutableDetailViewController> {

    UIToolbar *toolbar;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
