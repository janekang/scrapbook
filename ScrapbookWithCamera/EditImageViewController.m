//
//  EditImageViewController.m
//  ScrapbookWithPictureCropper
//
// in charge of the 'edit' view, accessable through detail view
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "EditImageViewController.h"
#import "ImageSearchViewController.h"

@interface EditImageViewController ()

@end

@implementation EditImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.navigationItem setTitle:@"Edit Content"];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteButtonDidGetPressed:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonDidGetPressed:)], nil] animated:NO];
        
        // Image title
        UILabel* imageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 30)];
        [imageTitleLabel setText:@"  Title"];
        [imageTitleLabel setTextColor:[UIColor whiteColor]];
        [imageTitleLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [imageTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.view addSubview:imageTitleLabel];
        
        self.imageTitle = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, 300, 35)];
        [self.imageTitle setBorderStyle:UITextBorderStyleRoundedRect];
        [self.imageTitle setBackgroundColor:[UIColor whiteColor]];
        [self.imageTitle setDelegate:self];
        [self.view addSubview:self.imageTitle];
        
        // Image comment
        UILabel* imageCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 300, 30)];
        [imageCommentLabel setText:@"  Comment"];
        [imageCommentLabel setTextColor:[UIColor whiteColor]];
        [imageCommentLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [imageCommentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.view addSubview:imageCommentLabel];
        
        self.imageComment = [[UITextField alloc] initWithFrame:CGRectMake(10, 115, 300, 45)];
        [self.imageComment setBorderStyle:UITextBorderStyleRoundedRect];
        [self.imageComment setBackgroundColor:[UIColor whiteColor]];
        [self.imageComment setDelegate:self];
        [self.view addSubview:self.imageComment];
        
        // Image
        UILabel* imageContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 165, 300, 30)];
        [imageContentLabel setText:@"  Image"];
        [imageContentLabel setTextColor:[UIColor whiteColor]];
        [imageContentLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [imageContentLabel setTextAlignment:NSTextAlignmentLeft];
        [self.view addSubview:imageContentLabel];
        
        CGRect rect = CGRectMake(10, 200, 300, 150);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        UIRectFill(rect);
        UIImage* emptyImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.imageDisplay = [[UIImageView alloc] initWithImage:emptyImage];
        [self.imageDisplay setFrame:CGRectMake(10, 200, 300, 210)];
        [self.view addSubview:self.imageDisplay];
        //NSLog(@"create imageview for first time %@", self.imageDisplay);
        
        // Image search button
        self.editImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.editImageButton setFrame:CGRectMake(225, 167, 80, 25)];
        [self.editImageButton setTitle:@"Edit" forState:UIControlStateNormal];
        [self.editImageButton addTarget:self action:@selector(editImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.editImageButton];
        
        // Image editor
        self.imageEditor = [[FilterEditor alloc] initWithTarget:self andAction:@selector(setImage:) andImage:emptyImage];
        
        // Create tap recognizer to dismiss keyboard when user touches outside of text field
        UITapGestureRecognizer* tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textFieldShouldReturn:)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    // customize
}

-(void)selectedImage:(Image *)selected {    
    self.imageSelected = selected;
    
    // If no title, display nothing as title
    if (![self.imageSelected.title isEqualToString:@"(No Title)"]) {
        [self.imageTitle setText:self.imageSelected.title];
    }
    else {
        [self.imageTitle setText:@""];
    }
    
    // If no comment, display nothing as comment
    if (![self.imageSelected.comment isEqualToString:@"(No Comment)"]) {
        [self.imageComment setText:self.imageSelected.comment];
    }
    else {
        [self.imageComment setText:@""];
    }

    self.imageDisplay.image = self.imageSelected.image;
}

-(IBAction)saveButtonDidGetPressed:(id)sender {
    // Update in case anything changed
    if ([self.imageTitle.text isEqualToString:@""] || [self.imageComment.text isEqualToString:@""]) {
        // Depending on user's choice, stored content differs
        UIAlertView* missingTitle = [[UIAlertView alloc] initWithTitle:@"Missing title, or comment,\n or both" message:@"You left a text field empty!\n If you don't fill it in, computer will put in something by default." delegate:self cancelButtonTitle:@"Save Anyway" otherButtonTitles:@"Back", nil];
        [missingTitle show];
    }
    else { // Save everything as normal
        self.imageSelected.title = self.imageTitle.text;
        self.imageSelected.comment = self.imageComment.text;
        
        if (self.imageDisplay.image != nil) {
            self.imageSelected.image = self.imageDisplay.image;
        }
        
        // Add the image and accompanied data to the main table view
        [self.target performSelector:self.saveAction withObject:self.imageSelected];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)deleteButtonDidGetPressed:(id)sender {
    [self.target performSelector:self.deleteAction withObject:self.imageSelected];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)editImage:(id)sender {
    // Load image editing view controller
    if ([self.imageEditor.pastAttempts count] > 0) { // Undo all past attemps on editing
        [self.imageEditor.pastAttempts removeAllObjects];
    }
    [self.imageEditor.pastAttempts addObject:self.imageSelected.image];
    [self.imageEditor.mainImageView setImage:[self.imageEditor.pastAttempts lastObject]];
    [self.navigationController pushViewController:self.imageEditor animated:YES];
}

-(void) setImage:(UIImageView*)imageView {
    //NSLog(@"setting image");
    self.imageSelected.image = imageView.image;
    [self.imageDisplay setImage:self.imageSelected.image];
}

// Text field return key clicked, dismiss keyboard
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    if ([self.imageTitle isFirstResponder]) {
        [self.imageTitle resignFirstResponder];
    }
    if ([self.imageComment isFirstResponder]) {
        [self.imageComment resignFirstResponder];
    }
    return YES;
}

// Conditional approach in response to alert pop-ups
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Check what the title of the selected button is
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Save Anyway"]) { // User chose to leave some text fields empty
        
        // Do not save empty string as title
        if ([self.imageTitle.text isEqualToString:@""]) {
            self.imageSelected.title = @"(No Title)";
        }
        else {
            self.imageSelected.title = self.imageTitle.text;
        }
        
        // Do not save empty string as comment
        if ([self.imageComment.text isEqualToString:@""]) {
            self.imageSelected.comment = @"(No Comment)";
        }
        else {
            self.imageSelected.comment = self.imageComment.text;
        }
        
        if (self.imageDisplay.image != nil) {
            self.imageSelected.image = self.imageDisplay.image;
        }

        // Add the image and accompanied data to the main table view
        [self.target performSelector:self.saveAction withObject:self.imageSelected];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else { // Let the user edit it
        
    }
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
