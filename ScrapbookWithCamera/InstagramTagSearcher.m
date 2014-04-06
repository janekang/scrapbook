//
//  InstagramTagSearcher.m
//  ScrapbookWithPictureCropper
//
// Based on starter code. Requests image information using given url and appends all image data into a dictionary.
//
//  Created by Jane Kang on 2/6/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import "InstagramTagSearcher.h"

@implementation InstagramTagSearcher

- (id) initWithTagQuery:(NSString *)query andTarget:(id)incomingTarget andAction:(SEL)incomingAction {
    self = [super init];
    
    if (self) { // Once base is created
        self.target = incomingTarget;
        self.action = incomingAction;
        self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=52b557afb1c64d5aa7480bef6c368f3e", query]]] delegate:self];
            //NSLog(@"instagram tag searcher base created");
    }
    
    return self;
}

// When connection start, initialize data object
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.imageData = [[NSMutableData alloc] initWithCapacity:0];
    //NSLog(@"instagram tag searcher received response");
    //NSLog(@"%@", [[[connection currentRequest] URL] absoluteString]);
}

// As data comes in, append it to existing data
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.imageData == nil) { // Make sure data object is created
        self.imageData = [[NSMutableData alloc] initWithCapacity:0];
    }
    [self.imageData appendData:data];
    //NSLog(@"%@", self.imageData);
    //NSLog(@"instagram tag searcher appends data");
}

// When all JSON data is loaded, read it and pass it to the target using action selector
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSLog(@"instagram tag searcher created dictionary");
    
    // Create a dictionary out of received data
    NSMutableDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:self.imageData options:NSJSONReadingMutableContainers error:nil];

    [self.target performSelector:self.action withObject:dictionary];
}

@end
