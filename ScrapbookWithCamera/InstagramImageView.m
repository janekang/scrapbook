//
//  InstagramImageView.m
//  ScrapbookWithPictureCropper
//
// Created from starter code. loads image using the collected information in dictionary format.
//
//  Created by Jane Kang on 2/6/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import "InstagramImageView.h"

@implementation InstagramImageView

// Basic constructor with no url given
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Constructor with given image url
- (id)initWithURL:(NSURL *)url andFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
        //NSLog(@"image view connection created");
    }
    return self;
}

// Request an image from Instagram
- (void)requestImage {
    if (self.connection) {
        [self.connection start];
    }
}

// Request a new image with new url from Instagram
- (void)requestImageWithURLFromString:(NSString *)url {
    // Stop old connection
    if (self.connection) {
        [self.connection cancel];
    }
    
    // Create new connection and start requesting
    self.connection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:self];
    if (self.connection) {
        [self.connection start];
        //NSLog(@"instagram image view connection started");
    }
}

// When connection successfully starts, create a fresh data object
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.webData = [[NSMutableData alloc] initWithCapacity:0];
    //NSLog(@"instagram image view received response");
}

// Append new data to existing data as it arrives
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.webData == nil) { // No data object created beforehand
        self.webData = [[NSMutableData alloc] initWithCapacity:0];
    }
    [self.webData appendData:data];
    //NSLog(@"instagram image view appending data");
}

// Connection finished loading, set the view image with web data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self setImage:[UIImage imageWithData:self.webData]];
    //NSLog(@"instagram image view loading finished");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
