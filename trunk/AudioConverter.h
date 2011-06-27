//
//  AudioConverter.h
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/17/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBFile.h"

@interface AudioConverter : NSObject {
	BBFile *bbFile;
}

@property (nonatomic, retain) BBFile *bbFile;

- (id)initWithBBFile:(BBFile *)thisBBFile;

@end