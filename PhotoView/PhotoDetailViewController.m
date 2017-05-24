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
  self.takenOnDateLabel.text = self.photo.takenOnDate;
}


@end
