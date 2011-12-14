//
//  BBFileTableViewControllerTBV.h
//  Backyard Brains
//
//  Created by Zachary King on 9-15-2011
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BBFile.h"
#import "BBFileTableCell.h"
#import "BBFileActionViewControllerTBV.h"
#import "DropboxSDK.h"

@class BBFileViewControllerTBV;

@interface BBFileViewControllerTBV: UITableViewController <UISplitViewControllerDelegate, UIActionSheetDelegate, BBFileTableCellDelegate, BBFileActionViewControllerDelegate, DBLoginControllerDelegate, DBRestClientDelegate>
 {
	
    /*UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
     
     
     IBOutlet UITableView *theTableView;
     IBOutlet UIButton *dbStatusBar;
     //UIActivityIndicatorView *activityIndicator;
     
     NSMutableArray *allFiles;
     NSArray *filesSelectedForAction;
     
     NSMutableArray *selectedArray;
     BOOL inPseudoEditMode;
     UIImage *selectedImage;
     UIImage *unselectedImage;
     NSUInteger lastRowSelected;
     
     NSDictionary *preferences;
     
     DBRestClient *restClient;
     NSString *status;
     
     NSArray* filePaths;
     NSString* filesHash;
     
     NSTimer *syncTimer;
     NSArray *lastFilePaths;
     
     NSString *docPath;*/

}

@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;


@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
//@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSMutableArray *allFiles;

@property (nonatomic, retain) NSMutableArray *selectedArray;
@property BOOL inPseudoEditMode;

@property (nonatomic, retain) UIButton *dbStatusBar;
@property BOOL triedCreatingFolder;

@property (nonatomic, retain) NSString *filesHash;


- (IBAction)togglePseudoEditMode;
- (void)checkForNewFilesAndReload;


@end