//
//  MasterViewController.h
//  NoteTakingApp
//
//  Copyright (c) 2015 Mohamed Sujahath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Dropbox/Dropbox.h>

@interface MasterViewController : UITableViewController<UIAlertViewDelegate>



@property (strong, nonatomic) IBOutlet UITableView *notesListTableView;
@property NSIndexPath *currentDeletedIndexPath;

@end

