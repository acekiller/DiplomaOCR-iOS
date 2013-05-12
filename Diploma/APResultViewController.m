//
//  APResultViewController.m
//  Diploma
//
//  Created by Alexey on 5/13/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import "APResultViewController.h"
#import "APViewController.h"
#import "APAboutViewController.h"

@interface APResultViewController ()

@end

@implementation APResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationItem setTitle:@"Result"];
    
    if (!aboutButton) {
        aboutButton = [[UIBarButtonItem alloc] initWithTitle:@"About"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(aboutBarButtonPressed)];
    }
    
    [self.navigationItem setRightBarButtonItem:aboutButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Custom methods
// =============================

-(void)aboutBarButtonPressed
{
    NSString *nibName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nibName = @"APAboutViewController_iPhone";
    }
    else{
        nibName = @"APAboutViewController_iPad";
    }
    
    if (!aboutController) {
        aboutController = [[APAboutViewController alloc] initWithNibName:nibName bundle:nil];
    }
    
    [nibName release];
    
    [self.navigationController pushViewController:aboutController animated:YES];
}//aboutButtonPressed

-(IBAction)actionButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Call", @"SMS", @"Email", nil];
    [actionSheet setTag:1];
    [actionSheet showFromBarButtonItem:sender animated:YES];

    [actionSheet release];
}
// =============================

// Delegates
// =============================

/*
 * Tag == 1
 * 0 - Call
 * 1 - SMS
 * 2 - Email
 * 3 - Cancel
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"In progress");
}
// =============================

-(void)dealloc
{
    [parent release];
    [aboutController release];
    
    [aboutButton release];
    
    [super dealloc];
}
@end
