//
//  APAboutViewController.m
//  Diploma
//
//  Created by Alexey on 5/13/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import "APAboutViewController.h"

@interface APAboutViewController ()

@end

@implementation APAboutViewController

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
    [self.navigationItem setTitle:@"About"];
    [self.navigationController.navigationBar.backItem setTitle:@"Back"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
