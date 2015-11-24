//
//  MasterViewController.m
//  NoteTakingApp
//
//  Copyright (c) 2015 Mohamed Sujahath. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NoteDataObject.h"

@interface MasterViewController ()

@property NSMutableArray *notesArrayList;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.notesListTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]]; 

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.title = [NSString stringWithFormat:@"Notes List (%ld)", (long)self.notesArrayList.count];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginNotification:)
                                                 name:@"loginNotification"
                                               object:nil];
    
    //Link to the Drop box
    
    //DBAccount *linkedAccount = [[DBAccountManager sharedManager] linkedAccount];
    
    //if (!linkedAccount.isLinked) {
        [[DBAccountManager sharedManager] linkFromController:self];
    //}
}

- (void) receiveLoginNotification:(NSNotification *) notification
{
    
    if ([[notification name] isEqualToString:@"loginNotification"])
    {
        NSLog (@"Successfully received the login notification!");
        DBAccount *linkedAccount = [[DBAccountManager sharedManager] linkedAccount];
        
        //if (!self.notesArrayList) {
            self.notesArrayList = [[NSMutableArray alloc] init];
        //}
        
        if (linkedAccount.isLinked) {
            NSLog(@"Account Linked");
            
            NSArray *fileListArray = [[DBFilesystem sharedFilesystem] listFolder:[DBPath root] error:nil];
            
            if([fileListArray count] > 0){
                NSLog(@"File List Count : %ld", [fileListArray count]);
                //NSLog(@"File List: %@", [fileListArray objectAtIndex:1]);
                //[self.notesArrayList addObjectsFromArray:fileListArray];
            
            
                for(DBFileInfo *file in fileListArray)
                {
                    DBPath *filePath = [file path];
                    DBFile *serverFile = [[DBFilesystem sharedFilesystem] openFile:filePath error:nil];
                   
                    NSString *fileContents = [serverFile readString:nil];
                    NSLog(@"file contents: %@", fileContents);
                    
                    NoteDataObject *noteObj = [[NoteDataObject alloc] init];
                    [noteObj setNoteText:fileContents];
                        NSString *fileName = [[[serverFile info] path] name];
                    [noteObj setDropboxFileName:fileName];
                    
                        NSString *createdDate = [fileName substringFromIndex:15];
                        createdDate = [createdDate stringByReplacingOccurrencesOfString:@".txt" withString:@""];
                         NSLog(@"createdDate : %@", createdDate);
                    [noteObj setCreatedDate:createdDate];
        
                    if(noteObj.noteText.length == 0 && [[noteObj.noteText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0 && [[noteObj.noteText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
                    {
                        noteObj.notetitle = @"New Note";
                    }
                    else if(noteObj.noteText.length > 0 && noteObj.noteText.length <= 9){
                    
                        noteObj.notetitle = [noteObj.noteText stringByAppendingString:@"..."];
                    }
                    else if(noteObj.noteText.length > 9)
                    {
                        noteObj.notetitle = [[noteObj.noteText substringToIndex:9]  stringByAppendingString:@"..."];
                    }
                
                    [noteObj setDropboxFileObj:serverFile];
                    [self.notesArrayList addObject:noteObj];
                }
            }
        
            [self.notesListTableView reloadData];
        }
        
        self.navigationItem.title = [NSString stringWithFormat:@"Notes List (%ld)", (long)self.notesArrayList.count];
        NSLog(@"Notes array list count: %ld", [self.notesArrayList count]);
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
    
    
    [self.notesListTableView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.notesArrayList) {
        self.notesArrayList = [[NSMutableArray alloc] init];
    }
    
    NoteDataObject *noteObj = [[NoteDataObject alloc] init];
    [noteObj setNotetitle:@"New Note"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    [noteObj setCreatedDate:[dateFormatter stringFromDate:[NSDate date]]];
    //Create a corresponding text file in dropbox
    NSString *fileName = [NSString stringWithFormat:@"New Note - %ld - %@.txt", [self.notesArrayList count] + 1,[noteObj createdDate]];
    [noteObj setDropboxFileName:fileName];
    
    DBPath *newPath = [[DBPath root] childPath:fileName];
    DBFile *file = [[DBFilesystem sharedFilesystem] createFile:newPath error:nil];
    [noteObj setDropboxFileObj:file];
    
    [self.notesArrayList addObject:noteObj];
    
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.notesArrayList.count inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    self.navigationItem.title = [NSString stringWithFormat:@"Notes List (%ld)", (long)self.notesArrayList.count];
    
    [self.notesListTableView reloadData];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NoteDataObject *noteObj = self.notesArrayList[indexPath.row];
        [[segue destinationViewController] setDetailItem:noteObj];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notesArrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    NoteDataObject *noteObj = self.notesArrayList[indexPath.row];
    cell.textLabel.text = [noteObj notetitle];
    cell.detailTextLabel.text = [noteObj createdDate];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.currentDeletedIndexPath = indexPath;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Are you sure you want to delete the Note?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK",nil];
        [alert show];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked Cancel
    if (buttonIndex == 0) {
        // do something here...
        //NSLog(@"Printing the button Index: %ld",(long)buttonIndex);
        
    }// the user clicked OK
    else if(buttonIndex == 1)
    {
        //NSLog(@"Printing the button Index: %ld",(long)buttonIndex);
        NoteDataObject *noteObj = [self.notesArrayList objectAtIndex:self.currentDeletedIndexPath.row];
        DBPath *deletefilePath = [[DBPath root] childPath:noteObj.dropboxFileName];
        [[DBFilesystem sharedFilesystem] deletePath:deletefilePath error:nil];
        
        [self.notesArrayList removeObjectAtIndex:self.currentDeletedIndexPath.row];
        [self.notesListTableView deleteRowsAtIndexPaths:@[self.currentDeletedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.navigationItem.title = [NSString stringWithFormat:@"Notes List (%ld)", (long)self.notesArrayList.count];
        
        
    }
}


@end
