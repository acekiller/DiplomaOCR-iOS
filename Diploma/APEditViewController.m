//
//  APEditViewController.m
//  Diploma
//
//  Created by Alexey on 4/24/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import "APEditViewController.h"
#import "APViewController.h"

@interface APEditViewController ()

@end

@implementation APEditViewController

@synthesize cropSelector, image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        is_height_scale_direction = YES;
        
        min_selector_height  = 50;
        min_selector_width   = 160;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            bottomBorder        = 375.0;
            selectorWidth       = 320;
            selectorHeight      = 150;
            max_selector_height = 375;
            max_selector_width  = 320;
        }
        else{
            bottomBorder        = 916.0;
            selectorWidth       = 768;
            selectorHeight      = 200;
            max_selector_height = 916;
            max_selector_width  = 768;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Edit"];
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    
    if (self.image) {
        [imageView setImage:self.image];
    }
    else{
        NSLog(@"Image link is empty");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Custom methods
// =====================

-(void)setParent:(APViewController *)p
{
    parent = p;
}//setParent

-(void)actionNavBarButtonPressed
{
    if ([actionNavBarButton tag] == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Direction"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Width", @"Height", nil];
        [actionSheet setTag:2];
        [actionSheet showFromBarButtonItem:actionNavBarButton animated:YES];
        [actionSheet release];
    } // if
    
    if ([actionNavBarButton tag] == 1) {
        [self cropImage];
    } // if
} // action nav bar button pressed

-(void)cropImage
{
    //in progress
}//cropImage

/*
 * 0 - Scale
 * 1 - Crop
 */
-(IBAction)actionToolBarButtonPressed:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Scale area",@"Crop", nil];
    [actionSheet setTag:1];
    [actionSheet showFromBarButtonItem:sender animated:YES];
    [actionSheet release];
} // action toolbar button pressed

-(IBAction)doneButtonPressed:(id)sender
{
    parent.image = self.image;
    [self.navigationController popViewControllerAnimated:YES];
} // done button pressed

-(IBAction)selectingArea:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            //get the top edge coordinate for the top left corner of crop frame
            float topEdgePosition = CGRectGetMinY(cropSelector.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float bottomEdgePosition = CGRectGetMaxY(cropSelector.frame);
            
            //if the top edge coordinate is less than or equal to 53
            if (topEdgePosition <= 0) {
                //draw drag view in max top position
                cropSelector.frame = CGRectMake(0, 0, selectorWidth, selectorHeight);
                
            }
            
            //if bottom edge coordinate is greater than or equal to 480
            
            if (bottomEdgePosition >= bottomBorder) {
                //draw drag view in max bottom position
                cropSelector.frame = CGRectMake(0, bottomBorder - selectorHeight, selectorWidth, selectorHeight);
            }
            
        }   break;
            
        default:
            
            break;
    }//switch
} // selecting area

-(IBAction)selectorSizeChanging:(UIPinchGestureRecognizer *)recognizer
{
    // in progress
    if ((recognizer.state == UIGestureRecognizerStateBegan) ||
        (recognizer.state == UIGestureRecognizerStateChanged)) {
        NSLog(@"Scaling: %f", recognizer.scale);
    }
}//selectorSizeChanging

// =====================



// Delegates
// =====================

/*
 * 1
 * ---------------------
 * 0 - Scale area button
 * 1 - Crop button
 * 2 - Cancel button
 * =====================
 *
 * 2
 * ---------------------
 * 0 - Width button
 * 1 - Height button
 * 2 - Cancel button
 * =====================
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //if actionNavBarButton is nil => create
    if (!actionNavBarButton) {
        actionNavBarButton = [[UIBarButtonItem alloc] init];
    } 
    
    if ([actionSheet tag] == 1) {
        switch (buttonIndex) {
            case 0:
                [actionNavBarButton setTitle:@"Scale"];
                [actionNavBarButton setTag:0];
                break;
                
            case 1:
                [actionNavBarButton setTitle:@"Crop"];
                [actionNavBarButton setTag:1];
                break;
                
            default:
                break;
        }
    }
    
    if ([actionSheet tag] == 2) {
        switch (buttonIndex) {
            case 0:
                is_height_scale_direction = NO;
                break;
                
            case 1:
                is_height_scale_direction = YES;
                break;
                
            default:
                break;
        }
    }
    
    //if rightBarButtonItem is nil => setup and add
    if (!self.navigationItem.rightBarButtonItem) {
        [actionNavBarButton setStyle:UIBarButtonItemStyleBordered];
        [actionNavBarButton setTarget:self];
        [actionNavBarButton setAction:@selector(actionNavBarButtonPressed)];
        [self.navigationItem setRightBarButtonItem:actionNavBarButton];
    }
}

// =====================
@end
