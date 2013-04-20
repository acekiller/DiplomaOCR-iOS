//
//  APViewController.m
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import "APViewController.h"

@interface APViewController ()

@end

@implementation APViewController

@synthesize imageView, popOver, cropSelector;

- (void)viewDidLoad
{
    is_source_type_selected   = NO;
    is_Camera_Source          = YES;
    is_Y_scale_direction      = YES;
    
    min_selector_height = 50;
    min_selector_width  = 160;
    
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
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Image"];
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];
    
    if (!scaleButton) {
        scaleButton = [[UIBarButtonItem alloc] initWithTitle:@"Scale area"
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(scaleChangingPressed)];
        [scaleButton setTintColor:[UIColor lightGrayColor]];
        [self.navigationItem setRightBarButtonItem:scaleButton];
    }
    [scaleButton setEnabled:NO];
    
    if (!cancelButton) {
        cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel crop"
                                                        style:UIBarButtonItemStyleBordered
                                                       target:self
                                                       action:@selector(cancelButtonPressed)];
        [cancelButton setTintColor:[UIColor colorWithRed:0.5 green:0.25 blue:0.25 alpha:1]];
        [self.navigationItem setLeftBarButtonItem:cancelButton];
    }
    [cancelButton setEnabled:NO];
    
    [cropSelector setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!is_source_type_selected) {
        [self showAlertView];
    }
    
    NSLog(@"Origin: %f x %f", CGRectGetMinX(self.cropSelector.frame), CGRectGetMinY(self.cropSelector.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 * Custom methods
 * ===================================================
 */

-(void)showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image source"
                                                    message:@"Select your image source"
                                                   delegate:self
                                          cancelButtonTitle:@"Library"
                                          otherButtonTitles:@"Camera", nil];
    [alert show];
    [alert release];
    
}//showAlertView

-(IBAction)imageButtonPressed:(id)sender
{
    //create a image picker
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    //select source type
    if (is_Camera_Source) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                            message:@"Camera unavailable.\nChoose from library."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok :`("
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    imagePicker.allowsEditing = NO;
    imagePicker.navigationBarHidden = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imagePicker.wantsFullScreenLayout = YES;
        [self presentModalViewController:imagePicker animated:YES];        
    } else {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:YES];
            [self.popOver release];
        }
        else{
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popOver.delegate = self;
            [self.popOver presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionDown
                                                 animated:YES];
            
        }
    }
    
    [imagePicker release];
}//imageButtonPressed

//Tag = 5 first and visible items
//Tag = 6 second and crop
-(IBAction)cropButtonPressed:(id)sender
{
    //sender is cropButton
    if ([imageView image]) {
        if ([sender tag] == 5) {
            [scaleButton setEnabled:YES];
            [cancelButton setEnabled:YES];
            [cropSelector setHidden:NO];
            
            [sender setTag:6];
        }
        else {
            NSLog(@"Crop accepted!");
            [sender setTag:5];
        }
    }
    
}//cropButtonPressed

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
}//selectingArea

-(void)scaleChangingPressed
{
    UIActionSheet *scaleDirection = [[UIActionSheet alloc] initWithTitle:@"Direction"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"X", @"Y", nil];
    [scaleDirection showFromBarButtonItem:scaleButton animated:YES];
    [scaleDirection release];
}//scaleChaningPressed

-(void)cancelButtonPressed
{
    [cropButton setTag:5];
    [cropSelector setHidden:YES];
    [cancelButton setEnabled:NO];
    [scaleButton setEnabled:NO];
    
}//cancelButtonPressed

-(IBAction)selectorSizeChanging:(UIPinchGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateBegan) ||
        (recognizer.state == UIGestureRecognizerStateChanged)) {
        NSLog(@"Scaling: %f", recognizer.scale);
    }
}//selectorSizeChanging

// ===================================================





/*
 * Delegates
 * ===================================================
 */

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!is_source_type_selected) {
        if (buttonIndex == 0) {
            is_Camera_Source = NO;
        }
        else{
            is_Camera_Source = YES;
        }
        
        is_source_type_selected = YES;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.popOver dismissPopoverAnimated:YES];
        [self.popOver release];
    }
    
    NSString *contentType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    
    if ([contentType isEqualToString:@"public.image"]) {
        UIImage *imageFromLibrary = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = imageFromLibrary;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"This content is not supported.\nPick the image."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

// 0 - X
// 1 - Y
// 2 - Cancel
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            is_Y_scale_direction = NO;
            break;
        case 1:
            is_Y_scale_direction = YES;
        default:
            break;
    }
}

// ===================================================

-(void)dealloc
{
    [scaleButton release];
    [cancelButton release];
    [cropButton release];
    [cropSelector release];
    
    [super dealloc];
}

@end
