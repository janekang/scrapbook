//
//  CropperViewController.m
//  ScrapbookWithPictureCropper
//
// view controller for cropping picture
//
//  Created by Patrick McNally on 10/8/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "CropperViewController.h"

@interface CropperViewController ()

@end

@implementation CropperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
        [self.navigationItem setTitle:@"Crop Image"];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoImage:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(done:)], nil] animated:NO];
        
        // Main view, where the image is displayed
        self.defaultImage = [UIImage imageNamed:@"NoImageDefault.png"];
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
        [self.mainImageView setImage:self.defaultImage];
        [self.mainImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self.mainImageView setUserInteractionEnabled:YES];
        
        // Cropping region selector
        self.cropper = [[CropRegionView alloc] initWithFrame:CGRectMake(110, 110, 100, 100)];
        self.cropper.parentView = self.mainImageView;
        [self.cropper checkBounds];
        [self.mainImageView addSubview:self.cropper];
        
        // Tab recognizer for user interaction
        self.doubleTabRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cropImage)];
        [self.doubleTabRecognizer setNumberOfTapsRequired:2];
        [self.cropper addGestureRecognizer:self.doubleTabRecognizer];
        
        // Undo all button
        self.undoAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.undoAllButton setFrame:CGRectMake(100, 330, 120, 32)];
        [self.undoAllButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.undoAllButton setTitle:@"Undo All" forState:UIControlStateNormal];
        [self.undoAllButton addTarget:self action:@selector(undoAll:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.undoAllButton];
        
        // Array for storing user's past attempts
        self.pastAttempts = [[NSMutableArray alloc] initWithCapacity:0];
        
        //[self.mainImageView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:self.mainImageView];
    }
    return self;
}

- (IBAction)done:(id)sender
{
    if (self.target != nil && self.action != nil) {
        //NSLog(@"sending the image");
        [self.target performSelector:self.action withObject:self.mainImageView.image];
        [self.pastAttempts removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

// Undo editings
- (IBAction)undoImage:(id)sender
{
    if ([self.pastAttempts count] > 1 && [self.pastAttempts lastObject] != nil) { // Undo last attempt
        [self.pastAttempts removeLastObject];
        [self.mainImageView setImage:[self.pastAttempts lastObject]];
    }
    else { // No past attempts, original image on display
    }
}

// Undo editings
- (IBAction)undoAll:(id)sender
{
    if ([self.pastAttempts count] > 1) { // Undo all attempts
        [self.mainImageView setImage:[self.pastAttempts objectAtIndex:0]];
        [self.pastAttempts removeAllObjects];
        [self.pastAttempts addObject:self.mainImageView.image];
    }
    else { // No past attempts, original image on display
    }
}

- (void)cropImage
{
    // crop a CGImage using the cropper's region and the main Image View's CGImage
    CGImageRef temp = CGImageCreateWithImageInRect(self.mainImageView.image.CGImage, [self.cropper cropBounds]);
    
    // turn it into a UIImage
    UIImage *croppedFromCG = [UIImage imageWithCGImage:temp];
    
    // begin a magical 'graphics context' (think of this as an arbitrary place to draw things that is NOT a screen)
    UIGraphicsBeginImageContext(CGSizeMake(300.0, 300.0));
    
    // draw the UIImage to the new dimensions (this just magically draws it in the magical context we just opened)
    [croppedFromCG drawInRect:CGRectMake(0, 0, 300, 300)];
    
    // fetch the freshly drawn image with it's new dimensions
    UIImage *croppedUIImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end the graphics context
    UIGraphicsEndImageContext();
    
    // release the CGImage we created
    CGImageRelease(temp);
    
    // Set the main view with the created cropped image
    [self.mainImageView setImage:croppedUIImage];
    [self.pastAttempts addObject:croppedUIImage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
