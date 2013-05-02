//
//  APViewController.h
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APEditViewController;

@interface APViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    UIBarButtonItem *editButton;
    IBOutlet UIBarButtonItem *imageButton;
    IBOutlet UIImageView *imageView;
    APEditViewController *editController;
}

@property (retain, nonatomic) UIImage *image;
@property (strong, nonatomic) UIPopoverController *popOver;

-(IBAction)imageButtonPressed:(id)sender;

-(void)editButtonPressed;
-(void)imagePickingCamera:(id)sender;
-(void)imagePickingLibrary:(id)sender;

@end
