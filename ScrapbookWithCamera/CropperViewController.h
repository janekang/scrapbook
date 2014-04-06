//
//  CropperViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 10/8/13.
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropRegionView.h"

@interface CropperViewController : UIViewController

@property UIImageView *mainImageView;
@property CropRegionView *cropper;
@property UIButton *undoAllButton;
@property UITapGestureRecognizer *doubleTabRecognizer;

@property NSMutableArray *pastAttempts;
@property UIImage *defaultImage;

@property id target;
@property SEL action;

- (IBAction)undoImage:(id)sender;
- (IBAction)undoAll:(id)sender;
- (IBAction)done:(id)sender;
- (void)cropImage;

@end
