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
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
  [self.tableView addGestureRecognizer:longPress];
  
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)longPressGestureRecognized:(id)sender {
  UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
  UIGestureRecognizerState state = longPress.state;
  
  CGPoint location = [longPress locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  
  static UIView *snapshot = nil;
  static NSIndexPath *sourceIndexPath = nil;
  
  switch (state) {
    case UIGestureRecognizerStateBegan: {
      if (indexPath) {
        sourceIndexPath = indexPath;
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        snapshot = [self customSnapshotFromView:cell];
        
        __block CGPoint center = cell.center;
        snapshot.center = center;
        snapshot.alpha = 0.0;
        [self.tableView addSubview:snapshot];
        [UIView animateWithDuration:.25 animations:^{
          center.y = location.y;
          snapshot.center = center;
          snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
          snapshot.alpha = 0.98;
          
          cell.alpha = 0.0;
        } completion:^(BOOL finished) {
          cell.hidden = YES;
        }];
      }
      break;
    }
      
    case UIGestureRecognizerStateChanged: {
      CGPoint center = snapshot.center;
      center.y = location.y;
      snapshot.center = center;
      
      if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
        [self.photos exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
        [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
        sourceIndexPath = indexPath;
      }
      break;
    }
      
    default: {
      UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
      cell.hidden = NO;
      cell.alpha = 0.0;
      
      [UIView animateWithDuration:0.25 animations:^{
        
        snapshot.center = cell.center;
        snapshot.transform = CGAffineTransformIdentity;
        snapshot.alpha = 0.0;
        cell.alpha = 1.0;
        
      } completion:^(BOOL finished) {
        
        sourceIndexPath = nil;
        [snapshot removeFromSuperview];
        snapshot = nil;
        
      }];
      
      break;
    }
  }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {

  UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
  
  snapshot.layer.masksToBounds = NO;
  snapshot.layer.cornerRadius = 0.0;
  snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
  snapshot.layer.shadowRadius = 5.0;
  snapshot.layer.shadowOpacity = 0.4;
  
  return snapshot;
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
