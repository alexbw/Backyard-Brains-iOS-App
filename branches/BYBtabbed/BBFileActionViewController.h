//
//  BBFileActionViewController.h
//  Backyard Brains
//
//  Created by Zachary King on 7/13/11.
//  Copyright 2011 Backyard Brains. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFileDetailViewController.h"
#import "BBFileTableCell.h"
#import "PlaybackViewController.h"

@protocol BBFileActionViewControllerDelegate
@required
- (NSArray *)returnSelectedFiles;
@end


@interface BBFileActionViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *theTableView;
    
    NSArray *files;
    
    id <BBFileActionViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, retain) NSArray *files;

@property (nonatomic, assign) id <BBFileActionViewControllerDelegate> delegate;

- (void)play;
- (void)editFiles;
- (void)emailFiles;
- (void)downloadFiles;
- (void)analyzeFiles;
- (void)deleteFiles;

@end
