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

@property (strong, nonatomic) NSMutableArray *photos;

@end

@implementation PhotosTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [GetRecentPhotos fetchWithSuccess:^(NSArray *photos) {
    NSLog(@"Fetched photos");
    self.photos = [photos mutableCopy];
    [self.tableView reloadData];
  } failure:^(NSError *error) {
    NSLog(@"Error: %@", [error localizedDescription]);
  }];
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
  
  Photo *photo = self.photos[indexPath.row];
  cell.titleLabel.text = photo.title;
  cell.thumbnailImageView.image = [UIImage imageNamed:@"default"];
  
  NSURL *thumbnailURL = [NSURL URLWithString:photo.smallPhotoUrl];
  NSURLSessionDataTask *thumbnailDataTask = [[NSURLSession sharedSession] dataTaskWithURL:thumbnailURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!data) { return; }
    
    UIImage *thumbnailImage = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      if (cell == [self.tableView cellForRowAtIndexPath:indexPath]) {
        cell.thumbnailImageView.image = thumbnailImage;
      }
    });
    
  }];
  [thumbnailDataTask resume];
  
  return cell;
}

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.photos removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [self.photos exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowDetailSegue"]) {
    PhotoDetailViewController *toVC = segue.destinationViewController;
    toVC.photo = self.photos[self.tableView.indexPathForSelectedRow.row];
  }
}

@end
