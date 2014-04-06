//
//  ImageSearchViewController.m
//  ScrapbookWithPictureCropper
//
// view controller in charge of instagram and flickr searches
//
//  Created by Jane Kang on 2/17/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import "ImageSearchViewController.h"
#import "AddImageViewController.h"

@interface ImageSearchViewController ()

@end

@implementation ImageSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTarget:(id)target andAction:(SEL)action {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        
        // Create the tab bar controller object
        self.tabBarController = [[UITabBarController alloc] init];
        
        // Create the Instagram view controller
        self.instagramViewController = [[InstagramViewController alloc] initWithTarget:target andAction:action];
        [self.instagramViewController.view setBackgroundColor:[UIColor whiteColor]];
        [self.instagramViewController.view setBounds:[[UIScreen mainScreen] bounds]];
        self.instagramViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Instagram" image:nil tag:1];
        
        // Create the Flicker view controller
        self.flickrViewController = [[FlickrViewController alloc] initWithTarget:target andAction:action];
        [self.flickrViewController.view setBackgroundColor:[UIColor whiteColor]];
        [self.flickrViewController.view setBounds:[[UIScreen mainScreen] bounds]];
        self.flickrViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Flickr" image:nil tag:2];
        
        // Add view controllers to the tab bar
        [self.tabBarController setViewControllers:[NSArray arrayWithObjects:self.instagramViewController, self.flickrViewController, nil]animated:YES];
    }
    return self;
}

- (void)clearField {
    [self.instagramViewController clearField];
    [self.flickrViewController clearField];
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
