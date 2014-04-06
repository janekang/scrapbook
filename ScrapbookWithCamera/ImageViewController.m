//
//  ImageViewController.m
//  ScrapbookWithPictureCropper
//
// main view controller for the scrapbook
// functionalities:
// allow image searching, editing, deleting
// default empty image for placeholder
// store (no comment) for empty comment, (no title) for empty title
// attempted undo (sometimes goes too far)
//
//  Created by Patrick McNally on 9/25/13.
//  Modified by Jane Kang
//  Copyright (c) 2013 Pomona College. All rights reserved.
//

#import "ImageViewController.h"
#import "Database.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.images = [Database fetchAllImages];
        [self.tableView reloadData];
        
        // register the type of view to create for a table cell
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        // initialize the image creation view controller
        self.addImageViewController = [[AddImageViewController alloc] initWithNibName:nil bundle:nil];
        self.addImageViewController.target = self;
        self.addImageViewController.action = @selector(addImage:);
        
        // initialize the image detail edit view controller
        self.editImageViewController = [[EditImageViewController alloc] initWithNibName:nil bundle:nil];
        self.editImageViewController.target = self;
        self.editImageViewController.saveAction = @selector(editImage:);
        self.editImageViewController.deleteAction = @selector(deleteImage:);
        
        // initialize the image detail view controller
        self.imageDetailViewController = [[ImageDetailViewController alloc] initWithNibName:nil bundle:nil];
        self.imageDetailViewController.target = self;
        self.imageDetailViewController.action = @selector(deleteImage:);
        self.imageDetailViewController.editImageViewController = self.editImageViewController;
    }
    return self;
}

// this is called when from the AddContactViewController when someone taps the Add button
- (void)addImage:(Image *)imageInfo
{
    // we have to tell the tableView to reload itself after we modify the data array
    [Database saveImageWithTitle:imageInfo.title andComment:imageInfo.comment andImage:imageInfo.image];
    self.images = [Database fetchAllImages];
    
    // we have to tell the tableView to reload itself after we modify the data array
    [self.tableView reloadData];
}

// Called from the DetailViewController when someone taps the Delete button
- (void)deleteImage:(Image *)imageInfo
{
    [Database deleteImage:imageInfo.index];
    self.images = [Database fetchAllImages];
    [self.tableView reloadData];
}

// Called from the EditImageViewController when someone taps the Save button
- (void)editImage:(Image *)imageInfo
{
    // Change the displayed image detail
    [self.imageDetailViewController setFieldsWithImage:imageInfo];
    
    [Database updateImageWithImage:imageInfo];
    self.images = [Database fetchAllImages];
    [self.tableView reloadData];
}

- (void)addButtonPressed
{
    [self.addImageViewController clearFields];
    [self.navigationController pushViewController:self.addImageViewController animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeueReusableCellWithIdentifier:forIndexPath asks the table view for recyclable cell. If one is unavailable, a new cell of the type previously registered is created and returned
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Image *temp = [self.images objectAtIndex:indexPath.row];
    UIImage *thumbnail = [self imageWithImage:temp.image scaledToSize:CGSizeMake(44.0, 44.0)];
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@ %@", temp.title, temp.comment]];
    [[cell imageView] setImage:thumbnail];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [Database deleteImage:[[self.images objectAtIndex:indexPath.row] index]];
        self.images = [Database fetchAllImages];
        
        // When this next line is executed, the data has to agree with the changes this line is performing on the table view
        // if the data doesn't agree, the app falls all over itself and dies
        // that's why we remove the object from the contacts first
        // if you don't believe me, try reversing these two lines... just go ahead and try
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    //[self.tableView reloadData];
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Image *temp = [self.images objectAtIndex:indexPath.row];
    
    /* Interesting lesson here.
     * Technically, we've initialized the contactDetailViewController, right?
     * So you'd THINK the textFields in the nib file would already be loaded, but iOS is lazy
     * So the view is only loaded from the nib at the moment it's placed on the screen.
     * This means that if we reversed these next two lines, the very first time we tap on a contact
     * the contact detail view won't show us the data, but all subsequent contact taps WILL show us the data
     * to see what I mean, try reversing these lines and running the app
     */
    [self.imageDetailViewController setFieldsWithImage:temp];
    [self.navigationController pushViewController:self.imageDetailViewController animated:YES];
}

// Crops the given image to a designated size
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
