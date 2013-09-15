//
//  addGameViewController.h
//  TagGame
//
//  Created by Farr, David on 9/14/13.
//  Copyright (c) 2013 Farr, David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddGameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)nextTouchHandler:(id)sender;
- (IBAction)cancelTouchHandler:(id)sender;

@end
