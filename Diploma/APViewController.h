//
//  APViewController.h
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIPopoverControllerDelegate>
{
    BOOL is_source_type_selected;
    BOOL is_Camera_Source;
    BOOL is_Y_scale_direction;
    BOOL is_scale_changing_pressed;
    
    UIBarButtonItem *scaleButton;
    IBOutlet UIBarButtonItem *xButton;
    IBOutlet UIBarButtonItem *yButton;
    
    float bottomBorder;
    int selectorWidth;
    int selectorHeight;
    int min_selector_width;
    int max_selector_width;
    int min_selector_height;
    int max_selector_height;
}

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIView *cropSelector;
@property (strong, nonatomic) UIPopoverController *popOver;

-(IBAction)imageButtonPressed:(id)sender;
-(IBAction)cropButtonPressed:(id)sender;

-(void)scaleChangingPressed:(id)sender;
-(IBAction)x_pressed:(id)sender;
-(IBAction)y_pressed:(id)sender;

-(IBAction)selectingArea:(UIPanGestureRecognizer *)recognizer;
-(IBAction)selectorSizeChanging:(UIPinchGestureRecognizer *) recognizer;

-(void)showAlertView;

/*
 
  * TODO: Scaling
  * HAVE: origin position (x, y)
  * SET : 
 
 x: 128 64 0  (RGB)
 y: 63 182 43 (RGB)
 
 */

@end