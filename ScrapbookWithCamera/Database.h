//
//  Database.h
//  ScrapbookWithPictureCropper
//
//  Created by Patrick McNally on 9/30/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Image.h"
#import <sqlite3.h>

@interface Database : NSObject

+ (void)createEditableCopyOfDatabaseIfNeeded;
+ (void)initDatabase;
+ (NSMutableArray *)fetchAllImages;
+ (void)saveImageWithTitle:(NSString *)ttle andComment:(NSString *)cmnt andImage:(UIImage*)img;
+ (void)updateImageWithImage:(Image *)editedImage;
+ (void)deleteImage:(int)rowid;
+ (void)cleanUpDatabaseForQuit;

@end