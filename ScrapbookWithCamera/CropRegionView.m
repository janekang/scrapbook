//
//  CropRegionView.m
//  ScrapbookWithPictureCropper
//
// movable square region
//
//  Created by Patrick McNally on 10/8/13.
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "CropRegionView.h"

@implementation CropRegionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor redColor]];
        [self setAlpha:0.5];
    }
    return self;
}

- (CGRect)cropBounds
{
    CGFloat parentImageHeight;
    CGFloat parentImageWidth;
    
    if (self.parentView.image.size.height > self.parentView.image.size.width) {
        parentImageHeight = self.parentView.frame.size.height;
        parentImageWidth = (parentImageHeight/self.parentView.image.size.height) * self.parentView.image.size.width;
    } else {
        parentImageWidth = self.parentView.frame.size.width;
        parentImageHeight = (parentImageWidth/self.parentView.image.size.width) * self.parentView.image.size.height;
    }
    
    CGFloat minX = (self.parentView.frame.size.width - parentImageWidth)/2;
    CGFloat minY = (self.parentView.frame.size.height - parentImageHeight)/2;
    
    CGFloat inImageX = ((self.frame.origin.x - minX) / parentImageWidth) * self.parentView.image.size.width;
    CGFloat inImageY = ((self.frame.origin.y - minY) / parentImageHeight) * self.parentView.image.size.height;
    CGFloat inImageSize = (self.frame.size.width / parentImageWidth) * self.parentView.image.size.width;
    //return CGRectMake(inImageX, self.parentView.image.size.height-inImageY-inImageSize, inImageSize, inImageSize);
    return CGRectMake(inImageX, inImageY, inImageSize, inImageSize);
}

- (void)checkBounds
{
    CGFloat newX = self.frame.origin.x;
    CGFloat newY = self.frame.origin.y;
    
    CGFloat parentImageHeight;
    CGFloat parentImageWidth;
    
    if (self.parentView.image.size.height > self.parentView.image.size.width) {
        parentImageHeight = self.parentView.frame.size.height;
        parentImageWidth = (parentImageHeight/self.parentView.image.size.height) * self.parentView.image.size.width;
    } else {
        parentImageWidth = self.parentView.frame.size.width;
        parentImageHeight = (parentImageWidth/self.parentView.image.size.width) * self.parentView.image.size.height;
    }
    
    CGFloat minX = (self.parentView.frame.size.width - parentImageWidth)/2;
    CGFloat maxX = minX + parentImageWidth - self.frame.size.width;
    CGFloat minY = (self.parentView.frame.size.height - parentImageHeight)/2;
    CGFloat maxY = minY + parentImageHeight - self.frame.size.height;
    
    if (newX < minX) {
        newX = minX;
    }
    if (newX > maxX) {
        newX = maxX;
    }
    
    if (newY < minY) {
        newY = minY;
    }
    if (newY > maxY) {
        newY = maxY;
    }
    
    self.frame = CGRectMake(newX, newY, self.frame.size.width, self.frame.size.height);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.parentView != nil && [touches count] == 1) {
        //NSLog(@"moving cropper");
        CGFloat deltaX = [[touches anyObject] locationInView:self.superview].x - [[touches anyObject] previousLocationInView:self.superview].x;
        CGFloat deltaY = [[touches anyObject] locationInView:self.superview].y - [[touches anyObject] previousLocationInView:self.superview].y;
        
        CGFloat newX = self.frame.origin.x + deltaX;
        CGFloat newY = self.frame.origin.y + deltaY;
        
        CGFloat parentImageHeight;
        CGFloat parentImageWidth;
        
        if (self.parentView.image.size.height > self.parentView.image.size.width) {
            parentImageHeight = self.parentView.frame.size.height;
            parentImageWidth = (parentImageHeight/self.parentView.image.size.height) * self.parentView.image.size.width;
        } else {
            parentImageWidth = self.parentView.frame.size.width;
            parentImageHeight = (parentImageWidth/self.parentView.image.size.width) * self.parentView.image.size.height;
        }
        
        CGFloat minX = (self.parentView.frame.size.width - parentImageWidth)/2;
        CGFloat maxX = minX + parentImageWidth - self.frame.size.width;
        CGFloat minY = (self.parentView.frame.size.height - parentImageHeight)/2;
        CGFloat maxY = minY + parentImageHeight - self.frame.size.height;
        
        if (newX < minX) {
            newX = minX;
        }
        if (newX > maxX) {
            newX = maxX;
        }
        
        if (newY < minY) {
            newY = minY;
        }
        if (newY > maxY) {
            newY = maxY;
        }
        
        self.frame = CGRectMake(newX, newY, self.frame.size.width, self.frame.size.height);
    }
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
