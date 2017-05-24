//
//  PhotoDetailViewController.m
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"

@interface PhotoDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *largeImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *takenOnDateLabel;

@end

@implementation PhotoDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.titleLabel.text = self.photo.title;
  
  NSDateFormatter *inputFormatter = [NSDateFormatter new];
  inputFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  inputFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
  NSDate *photoDate = [inputFormatter dateFromString:self.photo.takenOnDate];
  
  NSDateFormatter *outputFormatter = [NSDateFormatter new];
  outputFormatter.dateFormat = @"MMM d, yyyy";
  self.takenOnDateLabel.text = [outputFormatter stringFromDate:photoDate];
  
  NSURL *photoURL = [NSURL URLWithString:self.photo.largePhotoUrl];
  NSURLSessionDataTask *imageDataTask = [[NSURLSession sharedSession] dataTaskWithURL:photoURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    if (!data) { return; }
    UIImage *largeImage = [[UIImage alloc] initWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      self.largeImageView.image = largeImage;
    });
    
  }];
  [imageDataTask resume];
}


@end
