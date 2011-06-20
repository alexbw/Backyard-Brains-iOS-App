//
//  BBFileTableCell.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBFileTableCellDelegate
-(void)cellActionTriggeredFrom:(NSIndexPath *) index;
@end


@interface BBFileTableCell : UITableViewCell {
	IBOutlet UILabel *shortname;
	IBOutlet UILabel *subname;
	IBOutlet UILabel *lengthname;
	IBOutlet UIButton *actionButton;
    IBOutlet UIButton *selectButton;
    
    BOOL selected;
    NSIndexPath *index;
    
    id <BBFileTableCellDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *shortname;
@property (nonatomic, retain) IBOutlet UILabel *subname;
@property (nonatomic, retain) IBOutlet UILabel *lengthname;
@property (nonatomic, retain) IBOutlet UIButton *actionButton;

@property (nonatomic) BOOL isSelected;
@property (nonatomic, retain) NSIndexPath *index;

@property (nonatomic, assign) id <BBFileTableCellDelegate> delegate;

-(IBAction)actionButtonSelected;


@end
