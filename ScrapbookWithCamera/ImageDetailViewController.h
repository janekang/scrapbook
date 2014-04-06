//
//  ImageDetailViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "EditImageViewController.h"

@class ImageViewController;

@interface ImageDetailViewController : UIViewController

@property EditImageViewController* editImageViewController;
@property IBOutlet UILabel *imageTitle;
@property IBOutlet UILabel *imageComment;
@property IBOutlet UIImageView *image;
@property Image* displayedImage;

@property UIBarButtonItem* deleteButton;
@property id target;
@property SEL action;
@property UIImage* emptyImage;

- (void)setFieldsWithImage:(Image*) selected;
- (IBAction)delete:(id)sender;

@end
