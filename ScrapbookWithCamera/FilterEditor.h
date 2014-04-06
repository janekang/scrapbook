//
//  FilterEditor.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 10/9/13.
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropperViewController.h"
#import "ImageSearchViewController.h"
#import <CoreImage/CoreImage.h>

@interface FilterEditor : UIViewController

@property UIImageView *mainImageView;
@property UIButton *selectImageButton;
@property UIButton *cropImageButton;
@property UIButton *sepiaButton;
@property UIButton *circleButton;
@property UIButton *blurButton;
@property UIButton *bloomButton;
@property CropperViewController *cropViewController;
@property ImageSearchViewController *imageSearcher;

@property NSMutableArray *pastAttempts;
@property id target;
@property SEL action;

- (id)initWithTarget:(id)target andAction:(SEL)action andImage:(UIImage*)original;
- (void)getImage;
- (void)cropImage;
- (IBAction)undoImage:(id)sender;
- (void)handleCroppedImage:(UIImage *)croppedImage;

- (void)applySepiaFilter;
- (void)applyBloomFilter;
- (void)applyBlurFilter;
- (void)applyCircleFilter;

@end
