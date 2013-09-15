//
//  addGameViewController.m
//  TagGame
//
//  Created by Farr, David on 9/14/13.
//  Copyright (c) 2013 Farr, David. All rights reserved.
//

#import "AddGameViewController.h"
#import "FriendInfo.h"
#import "IconDownloader.h"

@interface AddGameViewController()

@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

@end

@implementation AddGameViewController {
    NSArray *friends;
    NSArray *searchResults;
}

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.navigation.title = @"Friends";
//    self.navigation.
//    
//    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextTouchHandler:)];
//    self.navigationItem.rightBarButtonItem = nextButton;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    friends = [[NSArray alloc] init];
    
    NSLog(@"calling facebook");
    FBRequest *friendsRequest  = [FBRequest requestForMyFriends];
    
    [friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       
        if (!error) {
            NSDictionary *friendsResults = (NSDictionary *)result;
            NSMutableArray *tempFriendsArray = [[NSMutableArray alloc] init];
            
            for(NSDictionary *f in friendsResults[@"data"]) {
                FriendInfo *friend = [[FriendInfo alloc] init];
                friend.firstName = f[@"first_name"];
                friend.lastName = f[@"last_name"];
                friend.username = f[@"username"];
                friend.fullName = [[friend.firstName stringByAppendingString:@" "] stringByAppendingString:friend.lastName];
                
                if(friend.username != nil) {
                    friend.displayPicURL = [[@"http://graph.facebook.com/" stringByAppendingString:friend.username] stringByAppendingString:@"/picture"];
                }
                
                [tempFriendsArray addObject:friend];
            }
            
            // sort by last name
            NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
            friends = [tempFriendsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
            
            // reload the table to show this info
            [self.tableView reloadData];
        }
        else {
            NSLog(@"An error occured: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return [friends count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if([friends count] > 0) {
        
        FriendInfo *friend;
        
        if(tableView == self.searchDisplayController.searchResultsTableView) {
            friend = [searchResults objectAtIndex:indexPath.row];
        }
        else if(tableView) {
            friend = [friends objectAtIndex:indexPath.row];
        }

        
        NSString *name = friend.fullName;
        cell.textLabel.text = name;
        
        if (!friend.displayPic) {
            if (friend.displayPicURL && tableView.dragging == NO && tableView.decelerating == NO) {
                [self startIconDownload:friend forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Placeholder"];
        }
        else {
            cell.imageView.image = friend.displayPic;
        }
    }
    
    return cell;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    if(searchString == nil || [searchString length] == 0) {
        return NO;
    }
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullName contains[cd] %@", searchString];
    searchResults = [friends filteredArrayUsingPredicate:resultPredicate];
    
    return YES;
}

- (void)startIconDownload:(FriendInfo *)friend forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) {
        
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.friend = friend;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = friend.displayPic;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
    }
}

- (IBAction)nextTouchHandler:(id)sender {
    
    // first we will save the new game
    
    [self dismissViewControllerAnimated:YES completion:^(void) {}];
}

- (IBAction)cancelTouchHandler:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(void) {}];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
