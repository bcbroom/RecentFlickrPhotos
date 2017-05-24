//
//  PhotosTableViewController.m
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "Photo.h"
#import "GetRecentPhotos.h"
#import "PhotoTableViewCell.h"
#import "PhotoDetailViewController.h"

@interface PhotosTableViewController ()

@property (copy, nonatomic) NSArray *photos;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [GetRecentPhotos fetchWithSuccess:^(NSArray *photos) {
    NSLog(@"Fetched photos");
    self.photos = photos;
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
  }];
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
  
  Photo *photo = self.photos[indexPath.row];
  cell.titleLabel.text = photo.title;
  
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
    PhotoDetailViewController *toVC = segue.destinationViewController;
    toVC.photo = self.photos[self.tableView.indexPathForSelectedRow.row];
  }
}

@end
