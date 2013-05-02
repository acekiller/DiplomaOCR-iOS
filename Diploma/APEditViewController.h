//
//  APEditViewController.h
//  Diploma
//
//  Created by Alexey on 4/24/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APViewController;

@interface APEditViewController : UIViewController <UIActionSheetDelegate>
{
    APViewController *parent;
    
    UIBarButtonItem *actionNavBarButton;
    IBOutlet UIImageView *imageView;
    
    BOOL is_height_scale_direction;
    float bottomBorder;
    int selectorWidth;
    int selectorHeight;
    int min_selector_width;
    int max_selector_width;
    int min_selector_height;
    int max_selector_height;
}

@property (retain, nonatomic) UIImage *image;
@property (retain, nonatomic) IBOutlet UIView *cropSelector;

-(void)setParent:(APViewController *) p;
-(void)actionNavBarButtonPressed;// displays uiactionsheet (width/height or crop image)
-(void)cropImage;                           // crop image

-(IBAction)actionToolBarButtonPressed:(id)sender; // displays uiactionsheet (crop/scale)
-(IBAction)doneButtonPressed:(id)sender; // set edited image to parent
-(IBAction)selectingArea:(UIPanGestureRecognizer *)recognizer; // change position of cropping area
-(IBAction)selectorSizeChanging:(UIPinchGestureRecognizer *) recognizer; // change  size of width/height of the cropping area

@end
