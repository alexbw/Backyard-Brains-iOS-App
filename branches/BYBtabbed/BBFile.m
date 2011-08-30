//
//  BBFile.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 2/21/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "BBFile.h"



@implementation BBFile

@synthesize filename;
@synthesize shortname;
@synthesize subname;
@synthesize comment;
@synthesize date;
@synthesize samplingrate;
@synthesize gain;
@synthesize filelength;
@synthesize hasStim, stimLog;

- (void)dealloc {
	[filename release];
	[shortname release];
	[subname release];
	[comment release];
	[date release];
	
	[super dealloc];

}

- (id)initWithRecordingFile {
	if ((self = [super init])) {
		
		
		self.date = [NSDate date];		

		//Format date into the filename
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

		[dateFormatter setDateFormat:@"h'-'mm'-'ss'-'S a', 'M'-'d'-'yyyy'.aif'"];
		self.filename = [dateFormatter stringFromDate:self.date];
		
		[dateFormatter setDateFormat:@"h':'mm a"];
		self.shortname = [dateFormatter stringFromDate:self.date];
		
		[dateFormatter setDateFormat:@"M'/'d'/'yyyy',' h':'mm a"];
		self.subname = [dateFormatter stringFromDate:self.date];
				
		[dateFormatter release];
		
		self.comment = @"";

		self.hasStim = NO;
		
		// Grab the sampling rate from NSUserDefaults
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		self.samplingrate   = [[defaults valueForKey:@"samplerate"] floatValue];
		self.gain           = [[defaults valueForKey:@"gain"] floatValue];
		
	}
	
	return self;
}

- (id)initWithFilePath:(NSString *)path
{
    if ((self = [super init]))
    {
        //get all this from the metadata:
        self.date = [NSDate date];		
        
        
		self.filename = path;
		
		self.shortname = path;
		
		self.subname = @"";
		
		self.comment = @"";
        
		self.hasStim = NO;
    
		self.samplingrate   = 0;
		self.gain           = 0;
    }
    
    return self;
}


- (void)deleteObject {
	[super deleteObject];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	NSError *error = nil;
	if (!	[fileManager removeItemAtPath:[docPath stringByAppendingPathComponent:self.filename] error:&error]) {
		NSLog(@"Error deleting file: %@", error);
	}
	
}

@end
