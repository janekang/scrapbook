//
//  FlickerViewController.h
//  ScrapbookWithPictureCropper
//
//  Created by Jane Kang on 2/7/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrTagSearcher.h"
#import "FlickrImageView.h"

@interface FlickrViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField* queryField;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;
@property (strong, nonatomic) IBOutlet UITableView* resultBox;
@property (strong, nonatomic) IBOutlet FlickrTagSearcher* searcher;

@property NSMutableArray* photos;
@property id target;
@property SEL action;

-(id) initWithTarget:(id)target andAction:(SEL)action;
-(void) clearField;

-(BOOL) textFieldShouldReturn:(UITextField *)textField;
-(BOOL) dismissKeyboard;
-(IBAction) didPressSearch:(id)sender;
-(void) handleData:(NSMutableArray *)data;

@end
