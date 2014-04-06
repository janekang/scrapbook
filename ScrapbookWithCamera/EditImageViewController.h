//
//  EditImageViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Image.h"
#import "FilterEditor.h"

@class ImageSearchViewController;

@interface EditImageViewController : UIViewController <UITextFieldDelegate>

@property IBOutlet UITextField *imageTitle;
@property IBOutlet UITextField *imageComment;
@property UIImageView *imageDisplay;
@property IBOutlet UIButton *editImageButton;
@property FilterEditor *imageEditor;
@property Image* imageSelected;

@property id target;
@property id deleteTarget;
@property SEL saveAction;
@property SEL deleteAction;

// Load image details
-(void)selectedImage:(Image*) selected;

-(IBAction)saveButtonDidGetPressed:(id)sender;
- (IBAction)deleteButtonDidGetPressed:(id)sender;

// Call image search, set image
-(void) editImage:(id)sender;
-(void) setImage:(UIImageView*) imageView;

// Dismiss keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField;

-(CGRect)textRectForBounds:(CGRect)bounds;
-(CGRect)editingRectForBounds:(CGRect)bounds;

@end
