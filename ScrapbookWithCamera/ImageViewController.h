//
//  ImageViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/25/13.
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImageViewController.h"
#import "ImageDetailViewController.h"
#import "EditImageViewController.h"
#import "Image.h"

@interface ImageViewController : UITableViewController

@property NSMutableArray *images; // the main data array
@property AddImageViewController *addImageViewController;
@property ImageDetailViewController *imageDetailViewController;
@property EditImageViewController *editImageViewController;

- (void)addImage:(NSMutableDictionary *)imageInfo;
- (void)addButtonPressed;

@end
