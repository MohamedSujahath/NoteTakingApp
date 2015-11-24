//
//  NoteDataObject.m
//  
// NoteTakingApp
//
// Copyright (c) 2015 Mohamed Sujahath. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NoteDataObject.h"

@implementation NoteDataObject
@synthesize dropboxFileName,notetitle,noteText,defaultTitle,dropboxFileObj,createdDate;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end