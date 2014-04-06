//
//  Database.m
//  ScrapbookWithPictureCropper
//
// setup class for using sqlite database
//
//  Created by Patrick McNally on 9/30/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "Database.h"
#import <sqlite3.h>


@implementation Database

static sqlite3 *db;

static sqlite3_stmt *createImage;
static sqlite3_stmt *fetchImage;
static sqlite3_stmt *insertImage;
static sqlite3_stmt *editImage;
static sqlite3_stmt *deleteImage;

+ (void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    
    // look for an existing contacts database
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentDirectory stringByAppendingPathComponent:@"scrapbook.sql"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    // if failed to find one, copy the empty contacts database into the location
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"scrapbook.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"FAILED to create writable database file with message, '%@'.", [error localizedDescription]);
    }
}

+ (void)initDatabase {
    
    // create the statement strings
    const char *createImageString = "CREATE TABLE IF NOT EXISTS scrapbook (rowid INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, comment TEXT, image BLOB)";
    const char *fetchImageString = "SELECT * FROM scrapbook";
    const char *insertImageString = "INSERT INTO scrapbook (title, comment, image) VALUES (?, ?, ?)";
    const char *editImageString = "UPDATE scrapbook SET title=?, comment=?, image=? WHERE rowid=?";
    const char *deleteImageString = "DELETE FROM scrapbook WHERE rowid=?";
    
    // create the path to the database
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [documentDirectory stringByAppendingPathComponent:@"scrapbook.sql"];
    
    // open the database connection
    if (sqlite3_open([path UTF8String], &db)) {
        NSLog(@"ERROR opening the db");
    }
    
    int success;
    
    //init table statement
    if (sqlite3_prepare_v2(db, createImageString, -1, &createImage, NULL) != SQLITE_OK) {
        NSLog(@"Failed to prepare scrapbook create table statement");
    }
    
    // execute the table creation statement
    success = sqlite3_step(createImage);
    sqlite3_reset(createImage);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to create scrapbook table");
    }
    
    //init retrieval statement
    if (sqlite3_prepare_v2(db, fetchImageString, -1, &fetchImage, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare scrapbook fetching statement");
    }
    
    //init insertion statement
    if (sqlite3_prepare_v2(db, insertImageString, -1, &insertImage, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare scrapbook inserting statement");
    }
    
    //init edit statement
    if (sqlite3_prepare_v2(db, editImageString, -1, &editImage, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare scrapbook editing statement");
    }
    
    // init deletion statement
    if (sqlite3_prepare_v2(db, deleteImageString, -1, &deleteImage, NULL) != SQLITE_OK) {
        NSLog(@"ERROR: failed to prepare scrapbook deleting statement");
    }
}

+ (NSMutableArray *)fetchAllImages
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(fetchImage) == SQLITE_ROW) {
        // query columns from fetch statement
        char *titleChars = (char *) sqlite3_column_text(fetchImage, 1);
        char *commentChars = (char *) sqlite3_column_text(fetchImage, 2);
        NSString *tempTitle = [NSString stringWithUTF8String:titleChars];
        NSString *tempComment = [NSString stringWithUTF8String:commentChars];
        
        // Image data fetched from the database
        const void *dataPtr = sqlite3_column_blob(fetchImage, 3);
        int dataLength = sqlite3_column_bytes(fetchImage, 3);
        NSData* imageData = [[NSData alloc] initWithBytes:dataPtr length:dataLength];
        UIImage *tempImage = [UIImage imageWithData:imageData];
        
        //create Image object, notice the query for the row id
        Image *temp = [[Image alloc] initWithTitle:tempTitle andComment:tempComment andImage:tempImage andIndex:sqlite3_column_int(fetchImage, 0)];
        [ret addObject:temp];
    }
    
    sqlite3_reset(fetchImage);
    return ret;
}

+ (void)saveImageWithTitle:(NSString *)ttle andComment:(NSString *)cmnt andImage:(UIImage*)img
{
    // Convert UIImage to NSData for storing purposes
    NSData* imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(img)];
    
    // bind data to the statement
    sqlite3_bind_text(insertImage, 1, [ttle UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insertImage, 2, [cmnt UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_blob(insertImage, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    //NSLog(@"insert sttm: %@", insertImage);
    
    int success = sqlite3_step(insertImage);
    sqlite3_reset(insertImage);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to insert image");
    }
}

// Update the database so that the user's modified image is reflected in the database
+ (void)updateImageWithImage:(Image *)editedImage
{
    // Convert UIImage to NSData for storing purposes
    NSData* imageData = [[NSData alloc] initWithData:UIImagePNGRepresentation(editedImage.image)];
    
    // bind data to the statement
    sqlite3_bind_text(editImage, 1, [editedImage.title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(editImage, 2, [editedImage.comment UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_blob(editImage, 3, [imageData bytes], [imageData length], SQLITE_TRANSIENT);
    sqlite3_bind_int(editImage, 4, editedImage.index);
    
    int success = sqlite3_step(editImage);
    sqlite3_reset(editImage);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to edit image");
    }
}

+ (void)deleteImage:(int)rowid
{
    // bind the row id, step the statement, reset the statement, check for error... EASY
    sqlite3_bind_int(deleteImage, 1, rowid);
    int success = sqlite3_step(deleteImage);
    sqlite3_reset(deleteImage);
    if (success != SQLITE_DONE) {
        NSLog(@"ERROR: failed to delete image");
    }
}

+ (void)cleanUpDatabaseForQuit
{
    // finalize frees the compiled statements, close closes the database connection
    sqlite3_finalize(fetchImage);
    sqlite3_finalize(insertImage);
    sqlite3_finalize(editImage);
    sqlite3_finalize(deleteImage);
    sqlite3_finalize(createImage);
    sqlite3_close(db);
}

@end
