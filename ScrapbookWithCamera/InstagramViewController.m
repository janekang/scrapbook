//
//  InstagramViewController.m
//  ScrapbookWithPictureCropper
//
// Based on starter code. Takes charge of Instagram image searching, including user interface.
//
//  Created by Jane Kang on 2/6/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import "InstagramViewController.h"
#import "AddImageViewController.h"

@interface InstagramViewController ()

@end

@implementation InstagramViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTarget:(id)target andAction:(SEL)action {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        
        self.target = target;
        self.action = action;
        
        // Create text field
        self.queryField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, 320, 30)];
        [self.queryField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.queryField setDelegate:self];
        [self.queryField setClearsOnBeginEditing:YES];
        [self.view addSubview:self.queryField];
        
        // Create search button
        self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchButton setFrame:CGRectMake(75, 60, 170, 30)];
        [self.searchButton setTitle:@"Search Instagram" forState:UIControlStateNormal];
        [self.searchButton setBackgroundColor:[UIColor grayColor]];
        [self.searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.searchButton addTarget:self action:@selector(didPressSearch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.searchButton];
        
        // Create image table view
        self.searchResultsBox = [[UITableView alloc] initWithFrame:CGRectMake(5, 100, 310, 558)];
        self.searchResultsBox.dataSource = self;
        self.searchResultsBox.delegate = self;
        [self.searchResultsBox registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.view addSubview:self.searchResultsBox];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Clear queries and images
-(void)clearField {
    self.queryField.text = @"";
    [self didPressSearch:self];
}

// Text field return key clicked, start searching
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self didPressSearch:self];
    return YES;
}

// Dismiss keyboard
-(BOOL) dismissKeyboard {
    if ([self.queryField isFirstResponder]) {
        [self.queryField resignFirstResponder];
    }
    return YES;
}

// Create tag searcher to start searching
-(IBAction) didPressSearch:(id)sender {
    // Make sure keyboard is dismissed
    [self dismissKeyboard];
    
    self.searcher = [[InstagramTagSearcher alloc] initWithTagQuery:[self.queryField text] andTarget:self andAction:@selector(handleData:)];
    //NSLog(@"instagram searcher created");
}

// Instagram response handler
-(void) handleData:(NSMutableDictionary *)data {
    // Create an array of photos for the data
    self.photos = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableDictionary* fetchedData = [data objectForKey:@"data"];
    
    for (NSMutableDictionary* photo in fetchedData) {
        NSURL* url = [NSURL URLWithString:[[[photo objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"]];
        InstagramImageView* temp =[[InstagramImageView alloc] initWithURL:url andFrame:CGRectMake(0, 0, 320, 310)];
        
        [self.photos addObject:temp];
    }
    [self.searchResultsBox reloadData];
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
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeueReusableCellWithIdentifier:forIndexPath asks the table view for recyclable cell. If one is unavailable, a new cell of the type previously registered is created and returned
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Remove past images
    for (UIView* subview in [cell subviews]) {
        [subview removeFromSuperview];
    }
    
    // Configure the cell...
    //NSLog(@"configure cell %@", [self.photos objectAtIndex:indexPath.row]);
    [cell addSubview:[self.photos objectAtIndex:indexPath.row]];
    
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
/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 //[self.tableView reloadData];
 }*/


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
    // Pass the selected image over to the addImageViewController
    UITableViewCell* cellSelected = [tableView cellForRowAtIndexPath:indexPath];
    //NSLog(@"cell object at index %d %@", 1, [cellSelected.subviews objectAtIndex:1]);
    
    [self.target performSelector:self.action withObject:[cellSelected.subviews objectAtIndex:1]];
    
    // Go back to addImageView
    [self.navigationController popViewControllerAnimated:YES];
}

//Change the height of the cell [Default is 44]:
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 320;
}

@end
