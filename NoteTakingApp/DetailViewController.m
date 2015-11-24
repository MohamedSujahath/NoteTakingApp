//
//  DetailViewController.m
//  NoteTakingApp
//
//  Copyright (c) 2015 Mohamed Sujahath. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UITextViewDelegate>

@property (nonatomic, retain) UITextView *textView;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id) newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemSave
     target:self action:@selector(didPressSave)];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.textView setFont:[UIFont systemFontOfSize:18]];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.textView.delegate = self;
    self.textView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.textView becomeFirstResponder];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.textView action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    
    toolbar.items = [NSArray arrayWithObject:barButton];
    
    self.textView.inputAccessoryView = toolbar;
    
    
    
    if(self.detailItem.noteText.length > 0)
    {
        self.textView.text = self.detailItem.noteText;
    }
    
    if(self.detailItem.noteText.length == 0)
    {
        self.navigationItem.title = @"New Note";
    }
    else{
        self.navigationItem.title = self.detailItem.notetitle;
    }
    
    [self.view addSubview:self.textView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}


- (void)didPressSave {
    
    if(self.textView.text.length != 0 && [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0 && [[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] != 0)
    {
        self.detailItem.noteText = self.textView.text;
        
        if(self.textView.text.length > 9)
        {
        self.detailItem.notetitle = [[self.textView.text substringToIndex:9] stringByAppendingString:@"..."];
        }
        else{
        
            self.detailItem.notetitle = [self.textView.text stringByAppendingString:@"..."];
        }
        
        [self.detailItem.dropboxFileObj writeString:self.detailItem.noteText error:nil];
    }
    else
    {
        self.detailItem.noteText = self.textView.text;
        self.detailItem.notetitle = @"New Note";
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@"End editing");
    [self.textView resignFirstResponder];
}

@end
