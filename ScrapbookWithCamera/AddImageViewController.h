//
//  AddImageViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "ImageSearchViewController.h"
#import "FilterEditor.h"

@interface AddImageViewController : UIViewController <UITextFieldDelegate>

@property IBOutlet UITextField *imageTitle;
@property IBOutlet UITextField *imageComment;
@property UIImageView *imageDisplay;
@property IBOutlet UIButton *editImageButton;
@property FilterEditor *imageEditor;
@property Image* imageCreated;

@property UIImage* emptyImage;
@property UIImage* currentImage;
@property id target;
@property SEL action;

-(IBAction)saveButtonDidGetPressed:(id)sender;
-(void)clearFields;

// Call image search, set image
-(void) setImage:(UIImageView*)imageView;
-(void) loadImageEditor:(id)sender;

// Dismiss keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField;

-(CGRect)textRectForBounds:(CGRect)bounds;
-(CGRect)editingRectForBounds:(CGRect)bounds;

@end
