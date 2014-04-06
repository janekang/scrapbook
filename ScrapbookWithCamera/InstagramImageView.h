//
//  InstagramImageView.h
//  ScrapbookWithPictureCropper
//
//  Created by Jane Kang on 2/6/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstagramImageView : UIImageView <NSURLConnectionDataDelegate>

@property NSURLConnection *connection;
@property NSMutableData *webData;

- (id)initWithURL:(NSURL *)url andFrame:(CGRect) frame;

- (void)requestImage;
- (void)requestImageWithURLFromString:(NSString *)url;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
