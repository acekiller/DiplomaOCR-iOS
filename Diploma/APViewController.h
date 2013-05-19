//
//  APViewController.h
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APEditViewController;
@class APResultViewController;

@interface APViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>
{
    UIBarButtonItem *editButton;
    IBOutlet UIBarButtonItem *imageButton;
    IBOutlet UIImageView *imageView;
    APEditViewController *editController;
    APResultViewController *resultControlller;
    
    // ---
    IBOutlet UIBarButtonItem *doneBtn;
    IBOutlet UIView *cropSelectorView;
    IBOutlet UIView *editMenuView;
    IBOutlet UIButton *menuCallerBtn;
    IBOutlet UIStepper *widthScale;
    IBOutlet UIStepper *heightScale;
    
    BOOL is_edit_menu_shown;
    //BOOL is_height_scaling;
    
    float bottomBorder;
    int selectorWidth;
    int selectorHeight;
    int min_selector_width;
    int max_selector_width;
    int min_selector_height;
    int max_selector_height;
    // ---
}

@property (retain, nonatomic) UIImage *image;
@property (strong, nonatomic) UIPopoverController *popOver;

-(IBAction)imageButtonPressed:(id)sender;
-(IBAction)doneButtonPressed:(id)sender;

-(void)editButtonPressed;
-(void)imagePickingCamera:(id)sender;
-(void)imagePickingLibrary:(id)sender;
-(void)clearImageView;

// ---
-(IBAction)showHideEditMenu:(id)sender;
-(IBAction)cropImage:(id)sender;
-(IBAction)confirmCrop:(id)sender;
-(IBAction)cancelCrop:(id)sender;

-(IBAction)selectArea:(UIPanGestureRecognizer *)recognizer;
-(IBAction)scaleSelector:(UIStepper *)sender;
-(IBAction)rotateImage:(UIRotationGestureRecognizer *)recognizer;

-(void)setEditMenuPosition:(int)x_position animationDirection:(NSString *)direction;
// ---

@end
