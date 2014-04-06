//
//  ImageDetailViewController.m
//  ScrapbookWithPictureCropper
//
// view controller for displaying detail information about an image
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "ImageViewController.h"

@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        
        // Navigation bar
        [self.navigationItem setTitle:@"Image"];
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delete:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)], nil] animated:NO];
        
        // Image title
        UILabel* imageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        [imageTitleLabel setText:@"  Title"];
        [imageTitleLabel setTextColor:[UIColor whiteColor]];
        [imageTitleLabel setTextAlignment:NSTextAlignmentLeft];
        [imageTitleLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.view addSubview:imageTitleLabel];
        
        self.imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 47, 300, 20)];
        [self.imageTitle setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:self.imageTitle];
        
        // Image comment
        UILabel* imageCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, 300, 30)];
        [imageCommentLabel setText:@"  Comment"];
        [imageCommentLabel setTextColor:[UIColor whiteColor]];
        [imageCommentLabel setTextAlignment:NSTextAlignmentLeft];
        [imageCommentLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.view addSubview:imageCommentLabel];
        
        self.imageComment = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, 300, 50)];
        [self.imageComment setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:self.imageComment];
        
        // Image
        UILabel* imageContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, 300, 30)];
        [imageContentLabel setText:@"  Image"];
        [imageContentLabel setTextColor:[UIColor whiteColor]];
        [imageContentLabel setTextAlignment:NSTextAlignmentLeft];
        [imageContentLabel setBackgroundColor:[UIColor colorWithRed:0.121653f green:0.558395f blue:0.837748f alpha:1]];
        [self.view addSubview:imageContentLabel];
        
        CGRect rect = CGRectMake(10, 200, 300, 150);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        UIRectFill(rect);
        self.emptyImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.image = [[UIImageView alloc] initWithImage:self.emptyImage];
        [self.image setFrame:CGRectMake(10, 190, 300, 210)];
        [self.view addSubview:self.image];        
    }
    return self;
}

- (void)setFieldsWithImage:(Image *)selected{
    self.displayedImage = selected;
    
    [self.imageTitle setText:self.displayedImage.title];
    [self.imageComment setText:self.displayedImage.comment];
    [self.image setImage:self.displayedImage.image];
    [self.view reloadInputViews];
}

- (IBAction)delete:(id)sender {
    [self.target performSelector:self.action withObject:self.displayedImage];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    [self.editImageViewController selectedImage:self.displayedImage];
    [self.navigationController pushViewController:self.editImageViewController animated:YES];
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
