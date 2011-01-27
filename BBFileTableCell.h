//
//  BBFileTableCell.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/9/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BBFileTableCell : UITableViewCell {
	IBOutlet UILabel *shortname;
	IBOutlet UILabel *subname;
	IBOutlet UILabel *lengthname;
	IBOutlet UIButton *playPauseButton;
}

@property (nonatomic, retain) IBOutlet UILabel *shortname;
@property (nonatomic, retain) IBOutlet UILabel *subname;
@property (nonatomic, retain) IBOutlet UILabel *lengthname;
@property (nonatomic, retain) IBOutlet UIButton *playPauseButton;

@end
