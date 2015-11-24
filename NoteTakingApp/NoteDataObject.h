//
//  NoteDataObject.h
//  NoteTakingApp
//
//  Copyright (c) 2015 Mohamed Sujahath. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface NoteDataObject : NSObject{

}

@property NSString *notetitle;
@property NSString *defaultTitle;
@property NSString *noteText;
@property NSString *createdDate;
@property NSString *dropboxFileName;
@property DBFile *dropboxFileObj;

@end