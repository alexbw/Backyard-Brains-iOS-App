//
//  AudioConverter.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 3/17/10.
//  Copyright 2010 University of Michigan. All rights reserved.
//

#import "AudioConverter.h"


@implementation AudioConverter

@synthesize bbFile;

- (void)dealloc {
	[bbFile release];
	
	[super dealloc];
}

- (id)initWithBBFile:(BBFile *)thisBBFile {
	if (self = [super init]) {
		self.bbFile = thisBBFile;
	}
	
	return self;
}

- (void)convertBBFileDataToWAV {
	// TODO Check if we have enough space or something... 
//	AudioFileCreateWithURL (
//							audioFileURL,
//							kAudioFileWAVEType,
//							&audioFormat,
//							kAudioFileFlags_EraseFile,
//							&audioFileID
//							);
}

@end
