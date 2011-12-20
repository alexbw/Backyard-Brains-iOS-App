//
//  BBFileTitleEditorViewController.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/10/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBFile.h"

@protocol BBFileTitleEditorDelegate
	@required
		@property (nonatomic, retain) BBFile *file;

	@optional
	// nothing optional
@end


@interface BBFileTitleEditorViewController : UIViewController {
	IBOutlet UITextField *titleTextField;
	id <BBFileTitleEditorDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (assign) id <BBFileTitleEditorDelegate> delegate;

@end