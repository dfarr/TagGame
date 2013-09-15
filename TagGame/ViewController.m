//
//  ViewController.m
//  TagGame
//
//  Created by Farr, David on 9/13/13.
//  Copyright (c) 2013 Farr, David. All rights reserved.
//

#import "ViewController.h"
#import "GamesTableViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // check if user is already logged in
    if([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"User already logged on.");
        [self performSegueWithIdentifier:@"goToGames" sender:self];
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTouchHandler:(id)sender {
    
    NSArray *permissions = @[@"user_location", @"friends_location"];
    
    [PFFacebookUtils logInWithPermissions: permissions block:^(PFUser *user, NSError *error) {
        
        [_activityIndicator stopAnimating];
        
        if(!user) {
            if(!error) {
                NSLog(@"User cancelled login.");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Cancelled" message:@"You must login to play!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
            else {
                NSLog(@"An error occured: %@", error);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"An error of drastic proportions occured. Please try again later." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        }
        else {
            NSLog(@"User signed in.");
            [self performSegueWithIdentifier:@"goToGames" sender:self];
        }
    }];
    
    [_activityIndicator startAnimating];
}

@end
