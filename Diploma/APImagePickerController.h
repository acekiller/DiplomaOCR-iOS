//
//  APImagePickerController.h
//  Diploma
//
//  Created by Alexey on 4/18/13.
//  Copyright (c) 2013 AlexeyPivovar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagePickerDelegate <NSObject>
@required
-(void)imagePicked:(UIImage *)pickedImage;
@end

@interface APImagePickerController : UIImagePickerController //<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) id<ImagePickerDelegate> delegate;

@end