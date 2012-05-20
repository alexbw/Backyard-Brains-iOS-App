//
//  BBFileDetailViewController 2.m
//  Backyard Brains
//
//  Created by Alex Wiltschko on 5/20/12.
//  Copyright (c) 2012 Backyard Brains. All rights reserved.
//

#import "BBFileDetailViewController 2.h"

@implementation BBFileDetailViewController_2
@synthesize bbfile;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Create the Task definition
    SCClassDefinition *fileDef = [SCClassDefinition
                                     definitionWithClass:[BBFile class]
                                     propertyNamesString:@"shortname;comment;subname;samplingrate;gain;filelength"];
    
    
    SCPropertyDefinition *titlePropertyDef = [fileDef propertyDefinitionWithName:@"shortname"];
    titlePropertyDef.type = SCPropertyTypeTextField;
    titlePropertyDef.title = @"Filename";
    
    SCPropertyDefinition *dateDef = [fileDef propertyDefinitionWithName:@"subname"];
    dateDef.type = SCPropertyTypeLabel;
    dateDef.title = @"Recorded On:";
    
    
    SCPropertyDefinition *samplingRateDef = [fileDef propertyDefinitionWithName:@"samplingrate"];
    samplingRateDef.type = SCPropertyTypeLabel;
    samplingRateDef.title = @"Sampling Rate:";
    

    SCPropertyDefinition *gainDef = [fileDef propertyDefinitionWithName:@"gain"];
    gainDef.type = SCPropertyTypeLabel;
    gainDef.title = @"Gain:";
    
    SCPropertyDefinition *fileLengthDef = [fileDef propertyDefinitionWithName:@"filelength"];
    fileLengthDef.type = SCPropertyTypeLabel;
    fileLengthDef.title = @"File Length (s):";


    
    SCPropertyDefinition *descPropertyDef = [fileDef
                                             propertyDefinitionWithName:@"comment"];
    descPropertyDef.type = SCPropertyTypeTextView;
    descPropertyDef.attributes = [SCTextViewAttributes attributesWithMinimumHeight:88 maximumHeight:1000 autoResize:YES editable:YES];
    descPropertyDef.title = @"Comment";
    
    // Create an instance of the Task object
    // Create the section(s) for the task object
    [self.tableViewModel generateSectionsForObject:bbfile
                                    withDefinition:fileDef];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [bbfile save];
}

- (void)dealloc
{
    [bbfile release];
    [super dealloc];
}

@end
