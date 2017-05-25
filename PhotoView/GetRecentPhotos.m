//
//  GetRecentPhotos.m
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import "GetRecentPhotos.h"
#import "Photo.h"
#import "JsonRequestHelper.h"
#import "APIRouter.h"

@implementation GetRecentPhotos

+ (void)fetchPage:(NSInteger)page success:(void (^)(NSArray *photos))successBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSURLRequest *request = [APIRouter recentPhotosRequestForPage:page];
  
  [JsonRequestHelper getJsonWithRequest:request success:^(id json) {
    
    NSMutableArray *photos = [NSMutableArray new];
    
    
    NSArray *results = json[@"photos"][@"photo"];
    for (NSDictionary *info in results) {
      Photo *photo = [[Photo alloc] initWithJSON:info];
      [photos addObject:photo];
    }
    
    
    successBlock(photos);
    
  } failure:^(NSError *error) {
    
    failureBlock(error);
    
  }];
}

@end
