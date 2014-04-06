//
//  ImageSearchViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Jane Kang on 2/17/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramViewController.h"
#import "FlickrViewController.h"

@class AddImageViewController;

@interface ImageSearchViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) InstagramViewController* instagramViewController;
@property (strong, nonatomic) FlickrViewController* flickrViewController;

@property id target;
@property SEL action;

- (id)initWithTarget:(id)target andAction:(SEL)action;
- (void)clearField;

- (void)randomImageSearchWithQuery:(NSString*)query andAction:(SEL)action;

@end
