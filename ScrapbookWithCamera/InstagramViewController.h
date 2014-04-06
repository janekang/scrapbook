//
//  InstagramViewController.h
//  ScrapbookWithPictureCroopper
//
//  Created by Jane Kang on 2/6/14.
//  Copyright (c) 2014 Jane Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramImageView.h"
#import "InstagramTagSearcher.h"

@class AddImageViewController;

@interface InstagramViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITextField* queryField;
@property (strong, nonatomic) IBOutlet UIButton* searchButton;
@property (strong, nonatomic) IBOutlet UITableView* searchResultsBox;
@property (strong, nonatomic) IBOutlet InstagramTagSearcher* searcher;

@property NSMutableArray* photos;
@property UIImage* emptyImage;
@property id target;
@property SEL action;

-(id)initWithTarget:(id)target andAction:(SEL)action;
-(void)clearField;

-(BOOL) textFieldShouldReturn:(UITextField *)textField;
-(BOOL) dismissKeyboard;
-(IBAction) didPressSearch:(id)sender;
-(void) handleData:(NSMutableDictionary *)data;

@end
