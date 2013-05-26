//
//  APViewController.m
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import "APViewController.h"
#import "APEditViewController.h"
#import "APResultViewController.h"

@interface APViewController ()

@end

@implementation APViewController

@synthesize popOver, image;

- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Image"];
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];

    if (image) {
        imageView.image = image;
    }
    
    // ---
    [cropSelectorView setHidden:YES];
    [editMenuView setHidden:YES];
    
    is_edit_menu_shown = NO;
    //is_height_scaling = YES;
    [widthScale setMaximumValue:max_selector_width];
    [heightScale setMaximumValue:max_selector_height];
    
    [widthScale setValue:selectorWidth];
    [heightScale setValue:selectorHeight];
    
    [widthScale setMinimumValue:min_selector_width];
    [heightScale setMinimumValue:min_selector_height];
    
    [widthScale setStepValue:10];
    [heightScale setStepValue:10];
    // ---
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

-(IBAction)imageButtonPressed:(id)sender
{
    UIActionSheet *sourceType = [[UIActionSheet alloc] initWithTitle:@"Image source"
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"Camera", @"Library", nil];
    [sourceType setTag:1];
    [sourceType showFromBarButtonItem:sender animated:YES];
    [sourceType release];
}//imageButtonPressed

-(IBAction)doneButtonPressed:(id)sender
{
    // TODO: Replace to recognition by neuronet
    // ----------------------------------------
    NSString *nibName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nibName = @"APResultViewController_iPhone";
    }
    else{
        nibName = @"APResultViewController_iPad";
    }
    
    if (!resultControlller) {
        resultControlller = [[APResultViewController alloc] initWithNibName:nibName bundle:nil];
    }
    
    [nibName release];
    
    [self.navigationController pushViewController:resultControlller animated:YES];
    // ----------------------------------------
    
}//doneButtonPressed

-(void)editButtonPressed
{
    // ---
    if (editMenuView.hidden) {        
        CGRect editMenuFrame = editMenuView.frame;
        editMenuFrame.origin.x = 295;
        editMenuView.frame = editMenuFrame;
        
        [doneBtn setEnabled:NO];
        [imageButton setEnabled:NO];
        [editMenuView setHidden:NO];
        [cropSelectorView setHidden:NO];
        
        menuCallerBtn.transform = CGAffineTransformMakeRotation(M_PI);
        
        [editButton setTintColor:[UIColor darkGrayColor]];
    }
    else{
        [editMenuView setHidden:YES];
        [cropSelectorView setHidden:YES];
        [doneBtn setEnabled:YES];
        [imageButton setEnabled:YES];
        [editButton setTintColor:[UIColor lightGrayColor]];
    }
    // ---
    /*
    NSString *nibName;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        nibName = @"APEditViewController_iPhone";
    }
    else{
        nibName = @"APEditViewController_iPad";
    }
    
    if (!editController) {
        editController = [[APEditViewController alloc] initWithNibName:nibName bundle:nil];
        [editController setParent:self];
    }
    
    [nibName release];
    
    editController.image = self.image;
    [self.navigationController pushViewController:editController animated:YES];
    */
}

-(void)imagePickingCamera:(id)sender
{
    //create a image picker
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.navigationBarHidden = YES;
    
    //set source type
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        [imagePicker release];
        imagePicker = nil;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                        message:@"Camera unavailable.\nChoose from library."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok :`("
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        [self imagePickingLibrary:sender];
        return;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imagePicker.wantsFullScreenLayout = YES;
        [self presentModalViewController:imagePicker animated:NO];
    } else {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:NO];
            //[self.popOver release];
        }
        else{
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popOver.delegate = self;
            [self.popOver presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:NO];
            
        }
    }
    
    if (imagePicker) {
        [imagePicker release];
    }
}//imagePickingCamera

-(void)imagePickingLibrary:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.navigationBarHidden = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imagePicker.wantsFullScreenLayout = YES;
        [self presentModalViewController:imagePicker animated:NO];
    } else {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:NO];
            //[self.popOver release];
        }
        else{
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popOver.delegate = self;
            [self.popOver presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:NO];
            
        }
    }
    
    [imagePicker release];
}//imagePickingLibrary

-(void)clearImageView
{
    [imageView removeFromSuperview];
}//clearImageView

// ---

-(IBAction)showHideEditMenu:(id)sender
{
    if (is_edit_menu_shown) {
        [self setEditMenuPosition:295 animationDirection:@"Out"];
        [editMenuView setAlpha:0.3];
        is_edit_menu_shown = NO;
    }
    else{
        [self setEditMenuPosition:191 animationDirection:@"In"];
        [editMenuView setAlpha:0.8];
        is_edit_menu_shown = YES;
    }
}//showHideEditMenu

-(IBAction)cropImage:(id)sender
{
    
}//cropImage

-(IBAction)confirmCrop:(id)sender
{
    
}//confirmCrop

-(IBAction)selectArea:(UIPanGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
            
        case UIGestureRecognizerStateChanged: {
            
            CGPoint translation = [recognizer translationInView:self.view];
            
            //allow dragging only in Y coordinates by only updating the Y coordinate with translation position
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
            //get the top edge coordinate for the top left corner of crop frame
            float leftEdgePosition = CGRectGetMinX(cropSelectorView.frame);
            float topEdgePosition = CGRectGetMinY(cropSelectorView.frame);
            
            //get the bottom edge coordinate for bottom left corner of crop frame
            float rightEdgePosition = CGRectGetMaxX(cropSelectorView.frame);
            float bottomEdgePosition = CGRectGetMaxY(cropSelectorView.frame);
            
            float newX = cropSelectorView.frame.origin.x;
            float newY = cropSelectorView.frame.origin.y;
            
            if (leftEdgePosition <= 0) {
                newX = 0;
            }
            if (rightEdgePosition >= max_selector_width) {
                newX = max_selector_width - selectorWidth;
            }
            
            if (topEdgePosition <= 0) {
                newY = 0;
            }
            if (bottomEdgePosition >= max_selector_height) {
                newY = max_selector_height - selectorHeight;
            }
            
            cropSelectorView.frame = CGRectMake(newX, newY, selectorWidth, selectorHeight);
            
        }   break;
            
        default:
            
            break;
    }//switch
}//selectArea

// Tag == 1: Height
// Tag == 2: Width
-(IBAction)scaleSelector:(UIStepper *)sender
{
    CGFloat x = cropSelectorView.frame.origin.x;
    CGFloat y = cropSelectorView.frame.origin.y;
    
    float newWidth = cropSelectorView.frame.size.width;
    float newHeight = cropSelectorView.frame.size.height;
    
    if (sender.tag == 1) {
        newHeight = (float)sender.value;
    }
    if (sender.tag == 2) {
        newWidth = (float)sender.value;
    }

    cropSelectorView.frame = CGRectMake(x, y, newWidth, newHeight);
    
    selectorHeight = newHeight;
    selectorWidth = newWidth;
}//scaleSelector

-(IBAction)rotateImage:(UIRotationGestureRecognizer *)recognizer
{
    
}//rotateImage

-(void)setEditMenuPosition:(int)x_position animationDirection:(NSString *)direction
{
    CGRect editMenuFrame = editMenuView.frame;
    editMenuFrame.origin.x = x_position;
    
    if ([direction isEqualToString:@"In"]) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        menuCallerBtn.transform = CGAffineTransformMakeRotation(0);
        
    }
    else if ([direction isEqualToString:@"Out"]) {
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        menuCallerBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }
    else{
        NSLog(@"Wrong animation direction!\nIn/Out only.");
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    
    editMenuView.frame = editMenuFrame;
}//setEditMenuPosition

// ---

// ===================================================





/*
 * Delegates
 * ===================================================
 */

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.popOver dismissPopoverAnimated:YES];
    }
    
    NSString *contentType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    
    if ([contentType isEqualToString:@"public.image"]) {
        UIImage *imageFromLibrary = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.image = imageFromLibrary;
        [imageView setImage:imageFromLibrary];
        
        [imageFromLibrary release];
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
    
    if (!editButton) {
        editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                      style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(editButtonPressed)];
        [self.navigationItem setRightBarButtonItem:editButton];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}


/*
 * Tag == 1: Image source
 * 0 - Camera
 * 1 - Library
 * 2 - Cancel
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        switch (buttonIndex) {
            case 0: // Camera
                [self imagePickingCamera:imageButton];
                break;
            case 1: //Library
                [self imagePickingLibrary:imageButton];
                break;
            default:
                break;
        }
    }
}

// ===================================================

-(void)dealloc
{
    [editButton release];
    [editController release];
    [imageButton release];
    [imageView release];
    [resultControlller release];
    [doneBtn release];
    [cropSelectorView release];
    [editMenuView release];
    [menuCallerBtn release];
    
    [super dealloc];
}

@end
