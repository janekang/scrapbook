//
//  Image.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject

@property NSString *title;
@property NSString *comment;
@property UIImage *image;
@property int index;

-(id)initWithTitle:(NSString *)ttle andComment:(NSString *)cmmnt andImage:(UIImage*)image andIndex:(int)indx;

@end
