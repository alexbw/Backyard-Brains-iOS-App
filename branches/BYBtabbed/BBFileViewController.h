//
//  BBFileTableViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Modified by Zachary King
//      7/12/11 Set up everything for new tabbed interface. Removed audio player.
//  Copyright 2010 Backyard Brains. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBFile.h"
#import "BBFileTableCell.h"
#import "BBFileActionViewController.h"


@interface BBFileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BBFileTableCellDelegate, BBFileActionViewControllerDelegate>
{
	IBOutlet UINavigationController *navigationController;
    IBOutlet UITableView *theTableView;
	
	NSMutableArray *allFiles;
    
	NSMutableArray *selectedArray;
	BOOL inPseudoEditMode;
	UIImage *selectedImage;
	UIImage *unselectedImage;
    NSUInteger lastRowSelected;
    
}

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;
@property (nonatomic, retain) NSMutableArray *allFiles;

@property (nonatomic, retain) NSMutableArray *selectedArray;
@property BOOL inPseudoEditMode;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) UIImage *unselectedImage;

- (IBAction)togglePseudoEditMode;
- (void)populateSelectedArray;

- (NSString *)stringWithFileLengthFromBBFile:(BBFile *)thisFile;

//For BBFileActionViewControllerDelegate
- (NSArray *)returnSelectedFiles;


//For BBFileActionViewControllerDelegate
- (NSArray *)returnSelectedFiles;

@end