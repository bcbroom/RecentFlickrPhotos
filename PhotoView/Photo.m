//
//  Photo.m
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithJSON:(NSDictionary *)json {
  self = [super init];
  if (self) {
    _photoID = json[@"id"];
    _title = json[@"title"];
    _smallPhotoUrl = json[@"url_q"];
    _largePhotoUrl = json[@"url_l"];
    _takenOnDate = json[@"datetaken"];
  }
  return self;
}

@end
