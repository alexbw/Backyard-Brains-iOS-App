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

- (id)initWithFilename:(NSString *)theFilename
{
    if ((self = [super init]))
    {
        //get all this from the metadata:
        
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:theFilename]];
        
        NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:theFilename]);
        // Open the audio file, type = AIFF
        AudioFileID id;
        AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id); //inFileTypeHint?? just gonna pass 0


        //in case of renaming, use the name of the file (NSString path)
		self.filename = theFilename;
        
        UInt32 propertySize;
        AudioFileGetPropertyInfo(id, kAudioFilePropertyInfoDictionary, &propertySize, NULL);
        CFDictionaryRef dictionary;
        AudioFileGetProperty(id, kAudioFilePropertyInfoDictionary, &propertySize, &dictionary);
        NSMutableDictionary *theDict = (NSMutableDictionary*)dictionary;

		self.shortname    = [theDict objectForKey:@"shortname"];
		self.subname      = [theDict objectForKey:@"subname"];
		self.comment      = [theDict objectForKey:@"comment"];
        self.date         = [theDict objectForKey:@"date"];		
        self.samplingrate = [[theDict objectForKey:@"samplingrate"] floatValue];
        self.gain         = [[theDict objectForKey:@"gain"] floatValue];
        self.filelength   = [[theDict objectForKey:@"filelength"] floatValue];
		self.hasStim      = [[theDict objectForKey:@"hasStim"] boolValue];
        self.stimLog      = [[theDict objectForKey:@"stimLog"] intValue];

        [theDict setValue:theFilename forKey:@"filename"];
        AudioFileSetProperty(id, kAudioFilePropertyInfoDictionary, propertySize, (CFDictionaryRef)theDict);
        [theDict release];
        AudioFileClose(id);
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

- (void)save
{   

    /*NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:[docPath stringByAppendingPathComponent:self.filename]];
    
    
    
    NSLog(@"Full file path: %@", [docPath stringByAppendingPathComponent:self.filename]);
    // Open the audio file, type = AIFF
    AudioFileID id;
    AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id); 

    
    NSDictionary *theDict = [NSDictionary dictionaryWithObjectsAndKeys:self.filename, @"filename",
                             self.shortname, @"shortname",
                             self.subname, @"subname",
                             self.comment, @"comment",
                             self.date, @"data",
                             self.samplingrate, @"samplingrate",
                             self.gain, @"gain",
                             self.filelength, @"filelength",
                             self.hasStim, @"hasStim",
                             self.stimLog, @"stimLog", nil];   
    UInt32 propertySize = sizeof(theDict);
    AudioFileSetProperty(id, kAudioFilePropertyInfoDictionary, propertySize, (CFDictionaryRef)theDict);

    AudioFileClose(id);
    
    //
    //TEST CODE
    // Open the audio file, type = AIFF
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[docPath stringByAppendingPathComponent:self.filename]];
    
    AudioFileOpenURL ((CFURLRef)fileURL, kAudioFileReadWritePermission, kAudioFileAIFFType, &id);     
    
    //in case of renaming, use the name of the file (NSString path)
    
    AudioFileGetPropertyInfo(id, kAudioFilePropertyInfoDictionary, &propertySize, NULL);
    CFDictionaryRef dictionary;
    AudioFileGetProperty(id, kAudioFilePropertyInfoDictionary, &propertySize, &dictionary);
    NSMutableDictionary *newDict = (NSMutableDictionary*)dictionary;
    
    AudioFileSetProperty(id, kAudioFilePropertyInfoDictionary, propertySize, (CFDictionaryRef)theDict);
    [theDict release];
    AudioFileClose(id);
    
    //END TEST CDOE
    //*/
    
    [super save];
}

@end
