//
//  CropRegionView.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 10/8/13.
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CropRegionView : UIView

@property UIImageView *parentView;

- (void)checkBounds;
- (CGRect)cropBounds;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@end
