//
//  FlickerTagSearcher.h
//  ScrapbookWithPictureCropper
//
//  Created by Jane Kang on 2/7/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrTagSearcher : NSObject <NSURLConnectionDataDelegate>

@property NSURLConnection* connection;
@property NSMutableData* imageData;
@property id target;
@property SEL action;

- (id) initWithTagQuery:(NSString *)query andTarget:(id)incomingTarget andAction:(SEL)incomingAction;
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void) connectionDidFinishLoading:(NSURLConnection *)connection;

@end
