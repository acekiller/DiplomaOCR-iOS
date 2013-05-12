//
//  APResultViewController.h
//  Diploma
//
//  Created by Alexey on 5/13/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APViewController;
@class APAboutViewController;

@interface APResultViewController : UIViewController <UIActionSheetDelegate>
{
    APViewController *parent;
    APAboutViewController *aboutController;
    
    UIBarButtonItem *aboutButton;
}

-(void)aboutBarButtonPressed;

-(IBAction)actionButtonPressed:(id)sender;

@end
