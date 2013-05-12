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
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"Image"];
    [self.navigationController.navigationBar setTintColor:[UIColor lightGrayColor]];

    if (image) {
        imageView.image = image;
    }
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
                                                        message:@"Camera unavailable.\nChoose from library."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok :`("
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
            
        [imagePicker release];
        [self imagePickingLibrary:sender];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imagePicker.wantsFullScreenLayout = YES;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:YES];
            //[self.popOver release];
        }
        else{
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popOver.delegate = self;
            [self.popOver presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
            
        }
    }
    
    [imagePicker release];
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
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        if ([self.popOver isPopoverVisible]) {
            [self.popOver dismissPopoverAnimated:YES];
            //[self.popOver release];
        }
        else{
            self.popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            self.popOver.delegate = self;
            [self.popOver presentPopoverFromBarButtonItem:sender
                                 permittedArrowDirections:UIPopoverArrowDirectionAny
                                                 animated:YES];
            
        }
    }
    
    [imagePicker release];
}//imagePickingLibrary

-(void)clearImageView
{
    [imageView removeFromSuperview];
}//clearImageView

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
    
    [super dealloc];
}

@end
