//
//  FilterEditor.m
//  ScrapbookWithPictureCropper
//
// filter applicable view controller
//
//  Created by Patrick McNally on 10/9/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "FilterEditor.h"

@interface FilterEditor ()

@end

@implementation FilterEditor

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization        
    }
    return self;
}

- (id)initWithTarget:(id)target andAction:(SEL)action andImage:(UIImage *)original{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [self.navigationItem setTitle:@"Edit Image"];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoImage:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveImage:)], nil] animated:NO];

        self.target = target;
        self.action = action;
        self.pastAttempts = [[NSMutableArray alloc] initWithCapacity:0];
        
        // Main image view
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
        [self.mainImageView setImage:original];
        [self.view addSubview:self.mainImageView];
        
        // Selecting image button
        self.selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectImageButton setFrame:CGRectMake(1, 320, 159, 46)];
        [self.selectImageButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.selectImageButton setTitle:@"Get an Image" forState:UIControlStateNormal];
        [self.selectImageButton addTarget:self action:@selector(getImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.selectImageButton];
        
        // Cropping image button
        self.cropImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cropImageButton setFrame:CGRectMake(161, 320, 158, 46)];
        [self.cropImageButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.cropImageButton setTitle:@"Crop Image" forState:UIControlStateNormal];
        [self.cropImageButton addTarget:self action:@selector(cropImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.cropImageButton];
        
        // Sepia button
        self.sepiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.sepiaButton setFrame:CGRectMake(1, 368, 79, 46)];
        [self.sepiaButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.sepiaButton setTitle:@"Sepia" forState:UIControlStateNormal];
        [self.sepiaButton addTarget:self action:@selector(applySepiaFilter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.sepiaButton];
        
        // Highlight button
        self.circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.circleButton setFrame:CGRectMake(81, 368, 79, 46)];
        [self.circleButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.circleButton setTitle:@"Spiral" forState:UIControlStateNormal];
        [self.circleButton addTarget:self action:@selector(applyCircleFilter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.circleButton];
        
        // Blur button
        self.blurButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.blurButton setFrame:CGRectMake(161, 368, 77, 46)];
        [self.blurButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.blurButton setTitle:@"Blur" forState:UIControlStateNormal];
        [self.blurButton addTarget:self action:@selector(applyBlurFilter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.blurButton];
        
        // Bloom button
        self.bloomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bloomButton setFrame:CGRectMake(239, 368, 80, 46)];
        [self.bloomButton setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.bloomButton setTitle:@"Bloom" forState:UIControlStateNormal];
        [self.bloomButton addTarget:self action:@selector(applyBloomFilter) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.bloomButton];
        
        // Cropping image view controller
        self.cropViewController = [[CropperViewController alloc] initWithNibName:nil bundle:nil];
        self.cropViewController.target = self;
        self.cropViewController.action = @selector(handleCroppedImage:);
        
        // Instragram and Flickr image searcher
        self.imageSearcher = [[ImageSearchViewController alloc] initWithTarget:self andAction:@selector(setImage:)];
    }
    return self;
}

// Sepia filter
- (void)applySepiaFilter
{
    if ([self.pastAttempts lastObject] != nil) {
        
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *fromArray = [self.pastAttempts lastObject];
        CIImage *original = [CIImage imageWithCGImage:fromArray.CGImage];
       
        CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone"];
        [sepia setValue:original forKey:@"inputImage"];
        CIImage *newImage = [sepia valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newImage fromRect:[newImage extent]];
        
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        //NSLog(@"cicontext %@\n ciimage original %@\n cifilter sephia %@\n ciimage newnewimage %@\n cgimageref %@\n uiimage %@\n", context, original, sepia, newImage, cgimage, newUIImage);
        
        CGImageRelease(cgimage);
        
        // uncomment this line if you want to skip from CI to UI image... avoiding CG
        // this will allow you to avoid the need for creating a context and releasing a created CGImage
        //UIImage *newUIImage = [UIImage imageWithCIImage:newNewImage];
        
        [self.mainImageView setImage:newUIImage];
        [self.pastAttempts addObject:newUIImage];
    }
}

// Bloom filter
- (void)applyBloomFilter
{
    if ([self.pastAttempts lastObject] != nil) {
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *fromArray = [self.pastAttempts lastObject];
        CIImage *original = [CIImage imageWithCGImage:fromArray.CGImage];
        
        CIFilter *bloom = [CIFilter filterWithName:@"CIBloom"];
        [bloom setValue:original forKey:@"inputImage"];
        CIImage *newImage = [bloom valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newImage fromRect:[newImage extent]];
        
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        //NSLog(@"cicontext %@\n ciimage original %@\n cifilter bloom %@\n ciimage newnewimage %@\n cgimageref %@\n uiimage %@\n", context, original, bloom, newImage, cgimage, newUIImage);
        
        CGImageRelease(cgimage);
        
        // uncomment this line if you want to skip from CI to UI image... avoiding CG
        // this will allow you to avoid the need for creating a context and releasing a created CGImage
        //UIImage *newUIImage = [UIImage imageWithCIImage:newNewImage];
        
        [self.mainImageView setImage:newUIImage];
        [self.pastAttempts addObject:newUIImage];
    }
}

// Blur filter
- (void)applyBlurFilter
{
    if ([self.pastAttempts lastObject] != nil) {
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *fromArray = [self.pastAttempts lastObject];
        CIImage *original = [CIImage imageWithCGImage:fromArray.CGImage];
        
        CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
        [blur setValue:original forKey:@"inputImage"];
        CIImage *newImage = [blur valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newImage fromRect:[newImage extent]];
        
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        //NSLog(@"cicontext %@\n ciimage original %@\n cifilter blur %@\n ciimage newnewimage %@\n cgimageref %@\n uiimage %@\n", context, original, blur, newImage, cgimage, newUIImage);
        
        CGImageRelease(cgimage);
        
        // uncomment this line if you want to skip from CI to UI image... avoiding CG
        // this will allow you to avoid the need for creating a context and releasing a created CGImage
        //UIImage *newUIImage = [UIImage imageWithCIImage:newNewImage];
        
        [self.mainImageView setImage:newUIImage];
        [self.pastAttempts addObject:newUIImage];
    }
}

// Circle filter
- (void)applyCircleFilter
{
    if ([self.pastAttempts lastObject] != nil) {
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage *fromArray = [self.pastAttempts lastObject];
        CIImage *original = [CIImage imageWithCGImage:fromArray.CGImage];
        
        CIFilter *circle = [CIFilter filterWithName:@"CICircularScreen"];
        [circle setValue:original forKey:@"inputImage"];
        CIImage *newImage = [circle valueForKey:@"outputImage"];
        
        CGImageRef cgimage = [context createCGImage:newImage fromRect:[newImage extent]];
        
        UIImage *newUIImage = [UIImage imageWithCGImage:cgimage];
        //NSLog(@"cicontext %@\n ciimage original %@\n cifilter spiral %@\n ciimage newnewimage %@\n cgimageref %@\n uiimage %@\n", context, original, circle, newImage, cgimage, newUIImage);
        
        CGImageRelease(cgimage);
        
        // uncomment this line if you want to skip from CI to UI image... avoiding CG
        // this will allow you to avoid the need for creating a context and releasing a created CGImage
        //UIImage *newUIImage = [UIImage imageWithCIImage:newNewImage];
        
        [self.mainImageView setImage:newUIImage];
        [self.pastAttempts addObject:newUIImage];
    }
}

// Image given from another view, editor view activation
-(void)setImage:(UIImageView *)imageView {
    [self.mainImageView setImage:imageView.image];
    [self.pastAttempts addObject:imageView.image];
}

// Got back cropped image
- (void)handleCroppedImage:(UIImage *)croppedImage
{
    [self.mainImageView setImage:croppedImage];
    [self.pastAttempts addObject:croppedImage];
}

// Load image searcher
- (void)getImage
{
    [self.imageSearcher clearField];
    [self.navigationController pushViewController:self.imageSearcher.tabBarController animated:YES];
}

// Load crop view controller
- (void)cropImage
{
    if ([self.cropViewController.pastAttempts count] > 0) { // Erase all past attempts on cropping
        [self.cropViewController.pastAttempts removeAllObjects];
    }
    [self.cropViewController.mainImageView setImage:self.mainImageView.image];
    [self.cropViewController.pastAttempts addObject:self.mainImageView.image];
    [self.navigationController pushViewController:self.cropViewController animated:YES];
}

// Undo user's last attempt
- (IBAction)undoImage:(id)sender
{
    if ([self.pastAttempts count] > 1 && [self.pastAttempts lastObject] != nil) { // Undo last attempt
        [self.pastAttempts removeLastObject];
        [self.mainImageView setImage:[self.pastAttempts lastObject]];
    }
    else { // No past attempts, original image on display
    }
}

// Save the image, return to original view controller
- (IBAction)saveImage:(id)sender
{
    //NSLog(@"view %@, original %@", self.mainImageView, self.originalImage);
    [self.target performSelector:self.action withObject:self.mainImageView];
    [self.pastAttempts removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
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
