//
//  SetRulesViewController.m
//  TagGame
//
//  Created by Farr, David on 9/14/13.
//  Copyright (c) 2013 Farr, David. All rights reserved.
//

#import "SetRulesViewController.h"

@interface SetRulesViewController ()

@end

@implementation SetRulesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Set Rules";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTouchHandler:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneTouchHandler:(id)sender {
    
    [self performSegueWithIdentifier:@"goToGames" sender:self];
}

@end
