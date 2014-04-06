//
//  Image.m
//  ScrapbookWithPictureCropper
//
// struct for an image and side data
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "Image.h"

@implementation Image

-(id)initWithTitle:(NSString *)ttle andComment:(NSString *)cmmnt andImage:(UIImage*)image andIndex:(int)indx
{
    self.title = ttle;
    self.comment = cmmnt;
    self.image = image;
    self.index = indx;
    return self;
}

@end
