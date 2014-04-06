//
//  FlickerTagSearcher.m
//  ScrapbookWithPictureCropper
//
// Requests image information using url, and creates a dictionary out of the received information
//
//  Created by Jane Kang on 2/7/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import "FlickrTagSearcher.h"

@implementation FlickrTagSearcher

- (id) initWithTagQuery:(NSString *)query andTarget:(id)incomingTarget andAction:(SEL)incomingAction {
    self = [super init];
    if (self) {
        //NSString *flickerKey = @"0382428f58d99b96c53c8b43d421763e";
        //NSString *flickerSecret = @"9a29d327efe842cb";
        
        self.target = incomingTarget;
        self.action = incomingAction;
        self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=0382428f58d99b96c53c8b43d421763e&tags=%@&content_type=1&format=json&nojsoncallback=1", query]]] delegate:self];
        //NSLog(@"flickr tag searcher base created");
    }
    return self;
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.imageData = [[NSMutableData alloc] initWithCapacity:0];
    //NSLog(@"flickr tag searcher received response");
    //NSLog(@"%@", response);
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.imageData == nil) {
        self.imageData = [[NSMutableData alloc] initWithCapacity:0];
    }
    [self.imageData appendData:data];
   //NSLog(@"flickr tag searcher appending data");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:self.imageData options:NSJSONReadingMutableContainers error:nil];
    [self.target performSelector:self.action withObject:dictionary afterDelay:0.0];
    //NSLog(@"flickr tag searcher created dictionary");
    //NSLog(@"%@", dictionary);
}

@end
