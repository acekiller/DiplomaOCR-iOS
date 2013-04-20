//
//  APAppDelegate.h
//  Diploma
//
//  Created by Alexey on 4/17/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APViewController;

@interface APAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) APViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@end
